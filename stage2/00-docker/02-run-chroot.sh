# Get the Docker signing key for packages
echo "installing docker deb key"
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add -

echo "adding docker deb to packages"
# Add the Docker official repos
echo "deb [arch=armhf] https://download.docker.com/linux/stretch \
     $(lsb_release -cs) stable" | \
    tee /etc/apt/sources.list.d/docker.list

apt-get update