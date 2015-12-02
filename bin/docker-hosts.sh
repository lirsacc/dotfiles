running=( $(docker-machine ls | grep Running | awk '{ print $1 }') )

for i in "${running[@]}"; do
    ip=$(docker-machine ip $i)
    #remove line matching ip
    sudo sed -i '/'$ip'/d' /etc/hosts
    #insert ip/host on last line
    echo "$ip $i.docker" | sudo tee -a /etc/hosts
done
