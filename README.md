### Installing Compose
```shell
$ curl -L https://github.com/docker/compose/releases/download/1.1.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
$ chmod +x /usr/local/bin/docker-compose
```

### Starting the cluster and devbox
```
docker-machine create -d virtualbox shipyard-devbox
docker-machine env shipyard-devbox | source
git clone git@github.com:tombee/shipyard-devbox
cd shipyard-devbox
./generate.sh
docker-compose up
go get github.com/shipyard/shipyard
cd dev/gocode/src/github.com/shipyard/shipyard/controller
make
./controller server -d https://192.168.99.156:3375 --tls-ca-cert /certs/ca.pem --tls-cert /certs/cert.pem --tls-key /certs/key.pem
```

