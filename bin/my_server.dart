import 'dart:convert';
import 'dart:io';


var myStringStorage  = 'hello from dart server';

Future<void> main() async {
  final server = await createServer();
  print('Server started: ${server.address} port ${server.port}');
  await handleRequests(server);
}
Future<HttpServer> createServer() async {
  final address = InternetAddress.loopbackIPv4;
  const port = 4040;
  return await HttpServer.bind(address, port);
}


Future<void>handleRequests(HttpServer server) async {
  await for (HttpRequest request in server){
    //request.response.write('Hello from dart server');
    switch(request.method){
      case 'GET':
        handleGet(request);
        break;
      case 'POST':
        handlePost(request);
        break;
      default:
        handleDefault(request);
    }
    await request.response.close();
  }
}

void handleDefault(HttpRequest request) {
  request.response
      ..statusCode = HttpStatus.methodNotAllowed
      ..write('Unsupported Request: ${request.method}')
    ..close();
}

void handlePost(HttpRequest request) async {
  myStringStorage = await utf8.decoder.bind(request).join();
  request.response
  ..write('got it thanks')
   ..close();
}

void handleGet(HttpRequest request) {
  request.response
      ..write(myStringStorage)
      ..close();
}

