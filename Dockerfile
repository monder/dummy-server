FROM golang:1.14 as builder
ENV GO111MODULE=on

ADD . /go/src/github.com/monder/dummy-server
WORKDIR /go/src/github.com/monder/dummy-server

RUN go get
RUN go generate
RUN CGO_ENABLED=0 GOOS=linux go build -tags prod -a -installsuffix cgo -ldflags '-extldflags "-static"' -o server .

FROM scratch

COPY --from=builder /go/src/github.com/monder/dummy-server/server /server

WORKDIR /
ENTRYPOINT ["/server"]
