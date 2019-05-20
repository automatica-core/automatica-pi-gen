ldconfig -v

cat /proc/cpuinfo

DOCKER_RET=$(docker -v)

if [ $DOCKER_RET -ne 0 ]; then
    curl -sSL https://get.docker.com | sh
    systemctl enable docker
fi
echo "starting docker..."
dockerd &

usermod -aG docker automatica
docker pull automaticacore/automatica-supervisor:develop-latest

docker run --restart unless-stopped -v /var/run/docker.sock:/var/run/docker.sock automaticacore/automatica-supervisor:develop-latest