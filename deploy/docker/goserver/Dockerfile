ARG BUILDER_IMAGE_NAME=golang
ARG BUILDER_IMAGE_TAG=1.13.0-alpine3.10
ARG RELEASE_IMAGE_NAME=alpine
ARG RELEASE_IMAGE_TAG=latest

FROM ${BUILDER_IMAGE_NAME}:${BUILDER_IMAGE_TAG} as builder

RUN apk add --update make

WORKDIR /app

COPY Makefile .

COPY ./server ./server

RUN make update.server-vendor

WORKDIR /app/server

RUN go build -o .build/server .

FROM ${RELEASE_IMAGE_NAME}:${RELEASE_IMAGE_TAG}

COPY --from=builder /app/server/.build/server opt/grpc-exam/server

WORKDIR /opt/grpc-exam/
ENTRYPOINT ["./server"]

