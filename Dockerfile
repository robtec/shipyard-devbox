FROM debian:jessie

ENV GO_VERSION 1.4.2

RUN apt-get update
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
RUN apt-get install -y \
    build-essential \
    gcc \
    libncurses5-dev \
    make \
    tmux \
    wget \
    curl \
    sudo \
    vim \
    mercurial \
    git-core \
    nodejs-legacy \
    locales \
    golang 

# go
RUN wget https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz -O /tmp/go.tar.gz && \
    tar -C /usr/local -xvf /tmp/go.tar.gz && rm /tmp/go.tar.gz
ENV GOROOT /usr/local/go
ENV GOPATH $HOME/dev/gocode
ENV PATH /usr/local/go/bin:$GOPATH/bin:$PATH
RUN go get github.com/tools/godep && \
    go get code.google.com/p/go.tools/cmd/present && \
    go get github.com/shipyard/shipyard

# npm & bower
RUN curl http://npmjs.org/install.sh -L -o -| sh
RUN npm install -g bower

# latest docker binary
RUN wget https://get.docker.io/builds/Linux/x86_64/docker-latest -O /usr/local/bin/docker && \
    chmod +x /usr/local/bin/docker

CMD ["/bin/bash"]
