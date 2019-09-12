import { EchoRequest } from './lib/echopb/echo_pb'
import { EchoServiceClient } from './lib/echopb/echo_grpc_web_pb'

// const echoService = new EchoServiceClient('http://' + window.location.hostname + ':8080', null, null)
const API_URL = process.env.REACT_APP_API_URL
console.log('API_URL>>>', API_URL)
const echoService = new EchoServiceClient(API_URL, null, null)

const request = new EchoRequest()
request.setMessage('Hello World!')

echoService.echo(request, {}, (err, response) => {
  if (err) {
    return
  }

  console.log('response>>>', response.getMessage())
})
