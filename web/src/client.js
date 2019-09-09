import { EchoRequest } from "./lib/echopb/echo_pb"
import { EchoServiceClient } from "./lib/echopb/echo_grpc_web_pb"

// const echoService = new EchoServiceClient('http://' + window.location.hostname + ':8080', null, null)
const echoService = new EchoServiceClient('http://0.0.0.0:8080', null, null)

const request = new EchoRequest()
request.setMessage('Hello World!')

echoService.echo(request, {}, (err, response) => {
  console.log("response>>>", response.getMessage())
})