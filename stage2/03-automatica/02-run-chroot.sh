ldconfig -v

curl -sSL https://get.docker.com | sh
systemctl enable docker

docker pull automaticacore/automatica-supervisor:develop-latest

docker run --restart unless-stopped -v /var/run/docker.sock:/var/run/docker.sock automaticacore/automatica-supervisor:develop-latest