FROM golang:latest

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    make \
    jq \
    tree \
    tar \
    zip \
 && rm -rf /var/lib/apt/lists/*

RUN go get -d github.com/tools/godep && \
    go install github.com/tools/godep && \
    go get -u github.com/golang/lint/golint && \
    go get -u github.com/sanbornm/go-selfupdate && \
    go install github.com/sanbornm/go-selfupdate

RUN echo 'alias ll="ls -al"' >> ~/.bashrc

#
# downloading the latest go-coding source code so that it allows to
# run the container without mapping to any local go-coding copy
# e.g.
#       docker build -t go-coding .
#       docker run --rm -it go-coding
#
RUN mkdir -p /go/src/github.com/jasonzhuyx
RUN git clone https://github.com/jasonzhuyx/go-coding /go/src/github.com/jasonzhuyx/go-coding

ENV PROJECT_DIR $GOPATH/src/github.com/jasonzhuyx/go-coding
RUN mkdir -p "$PROJECT_DIR"
WORKDIR $PROJECT_DIR

CMD /bin/bash
