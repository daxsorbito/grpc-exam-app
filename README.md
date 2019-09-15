# Overview

This is an example app that uses the following:

1. gRPC-Web
1. golang web server
1. create-react-app web app
1. envoy

This app demonstrates how to integrate and use `gRPC-Web` in a `create-react-app` that is communicating to a golang `gRPC` server.

`Envoy` is used to proxy all `gRPC-Web` call from the web to the server.

## Requirements

1. Install `protoc` from [here](https://github.com/protocolbuffers/protobuf/releases).
2. Install `protoc-gen-grpc-web` from [here](https://github.com/grpc/grpc-web/releases).

   ```sh
   $ sudo mv ~/Downloads/protoc-gen-grpc-web-1.0.6-darwin-x86_64 \
      /usr/local/bin/protoc-gen-grpc-web
   $ chmod +x /usr/local/bin/protoc-gen-grpc-web
   ```

## Running the app
1. On the root folder run this command:
   ```sh
   $ docker-compose -f ./deployments/docker-compose.yaml up --build
   ```
2. Open a browser to `http://localhost:3001` and (for now) inspect the console, you should see something a log like this:
   ```javascript
    > API_URL>>> http://localhost:8080
    > response>>> Hello World! from server
   ```
   - Note: take a look at the `web/src/client.js` file where this log is printed out.