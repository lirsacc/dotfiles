#!/usr/bin/bash
# AWS helpers, thanks Lorenz Gruber (@bandinigo) for the original

function aws_unset_credentials () {
  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_SESSION_TOKEN
}

function aws_mfa () {
  # Use with aws_mfa arn profile_name token
  aws_unset_credentials

  aws sts get-session-token \
    --output text --serial-number "${1}" --token-code "${4}" | \
    awk '/^CRED/ {print "aws_access_key_id " $2 "\naws_secret_access_key " $4 "\naws_session_token " $5}' | \

  while read -r key value; do aws configure set "$key" "$value" --profile "$2"; done
  aws configure set region "$3" --profile "$2"
  aws_export_credentials "$2"
}

function aws_assume_role () {
  # Use with aws_assume_role role_arn session_name profile_name token
  aws_unset_credentials

  aws sts assume-role \
    --role-arn "$1" --role-session-name="$2-session" --output text | \
    awk '/^CRED/ {print "aws_access_key_id " $2 "\naws_secret_access_key " $4 "\naws_session_token " $5}' | \

  while read -r key value; do aws configure set "$key" "$value" --profile "$2"; done
  aws configure set region "$3" --profile "$2"
  aws_export_credentials "$2"
}

function aws_export_credentials () {

  local credentials
  local aws_access_key_id aws_secret_access_key aws_session_token
  local _AWS_ACCESS_KEY_ID _AWS_SECRET_ACCESS_KEY _AWS_SESSION_TOKEN
  typeset -A aws_access_key_id
  typeset -A aws_secret_access_key
  typeset -A aws_session_token

  credentials="$HOME/.aws/credentials"

  [[ -z "$1" ]] && echo "Profile name can't be empty" && return 1
  [[ ! -f "$credentials" ]] && echo "Can't find file $credentials" && return 1

  declare $(awk -F ' *= *' '{ if ($1 ~ /^\[/) section=$1; else if ($1 !~ /^$/) print $1 section "=" "\"" $2 "\"" }' < "$credentials")

  grep -q "\[$1\]" < "$credentials"
  [[ $? == 1 ]] && echo "Can't find profile '$1' in '$credentials'" && return 1

  aws_unset_credentials

  # Code should work in bash and zsh so the sed pipe is here to avoid the
  # quoting of array variables happenning in zsh

  # shellcheck disable=2128
  _AWS_ACCESS_KEY_ID=$(echo "${aws_access_key_id[$1]}" | sed -e 's/^"//'  -e 's/"$//')
  # shellcheck disable=2128
  _AWS_SECRET_ACCESS_KEY=$(echo "${aws_secret_access_key[$1]}" | sed -e 's/^"//'  -e 's/"$//')
  # shellcheck disable=2128
  _AWS_SESSION_TOKEN=$(echo "${aws_session_token[$1]}" | sed -e 's/^"//'  -e 's/"$//')

  if [[ ! -z $_AWS_ACCESS_KEY_ID ]] && [[ ! -z $_AWS_SECRET_ACCESS_KEY ]]; then
    export AWS_ACCESS_KEY_ID=$_AWS_ACCESS_KEY_ID
    export AWS_SECRET_ACCESS_KEY=$_AWS_SECRET_ACCESS_KEY
  else
    echo "Missing entry for AWS_ACCESS_KEY_ID and/or AWS_SECRET_ACCESS_KEY in profile '$1'"
    return 1
  fi

  if [[ ! -z $_AWS_SESSION_TOKEN ]]; then
    export AWS_SESSION_TOKEN=$_AWS_SESSION_TOKEN
  fi
}
