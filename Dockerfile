FROM golang:1.22.1 as builder

WORKDIR /go/src/app
COPY . .

RUN make build

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/mybot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /ets/ssl/certs/
ENTRYPOINT [ "./mybot" ]

