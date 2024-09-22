FROM golang:1.23.1 AS builder
COPY . /workspace
WORKDIR /workspace

ENV ARCH="arm64"

RUN go mod download && \
    GOOS=linux GOARCH=${ARCH} CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o /functions/version ./functions/version/* && \
    GOOS=linux GOARCH=${ARCH} CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o /functions/calc ./functions/calc/* && \
    GOOS=linux GOARCH=${ARCH} CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o /functions/check ./functions/check/*

# 本番実行用
# 2023/08/29 の latest
FROM gcr.io/distroless/static@sha256:2368c04cb307fd5244b92de95bd2bde6a7eb0eb4b9a0428cb276beeae127f118 AS aws
COPY --from=builder /functions /functions
# entrypointはlambdaの設定で上書きされる
ENTRYPOINT ["/functions/version"]

# ローカル実行用
# FROM public.ecr.aws/lambda/provided:al2 as local
FROM ubuntu:latest AS local
COPY --from=builder /functions /functions
ENTRYPOINT ["/functions/version"]
# ENTRYPOINT ["/usr/local/bin/aws-lambda-rie"]
