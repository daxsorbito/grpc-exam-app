# Overview

This is an example app that uses the following:

1. gRPC-Web
1. golang web server
1. create-react-app web app
1. envoy

This app demonstrates how to integrate and use `gRPC-Web` in a `create-react-app` that is communicating to a golang `gRPC` server.

`Envoy` is used to proxy all `gRPC-Web` call from the web to the server.
