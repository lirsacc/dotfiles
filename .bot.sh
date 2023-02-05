#!/usr/bin/env bash

source .colors.sh

function _bot() {
    clr_bold clr_green "    .     "
    clr_bold clr_green " ~(0_0)~  " -n
    clr_bold "$@"
}

function _bot_error() {
    clr_bold clr_red "    .     "
    clr_bold clr_red " ~(0_0)~  " -n
    clr_bold clr_red "$@"
    echo
}

function _bot_exit() {
    clr_bold clr_cyan "    .     "
    clr_bold clr_cyan " ~(0_0)~  " -n
    clr_bold clr_cyan "Bot out!"
    echo
    exit 0
}

function _align() {
    echo -n "           "
}
