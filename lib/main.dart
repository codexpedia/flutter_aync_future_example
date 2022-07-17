import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

Future<String> getIPAddress() async {
  final url = Uri.parse('https://httpbin.org/ip');
  final httpClient = HttpClient();
  final request = await httpClient.getUrl(url);
  final response = await request.close();
  final responseBody = await response.transform(utf8.decoder).join();
  final String ip = jsonDecode(responseBody)['origin'];
  return ip;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getIPAddress(),
        builder: (context, AsyncSnapshot<String> ipAddress) {
          return MaterialApp(
            title: 'Flutter Future',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: MyHomePage(title: 'Flutter Future Home Page', asyncSnapshotIpAddress: ipAddress),
          );
        }
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final AsyncSnapshot<String> asyncSnapshotIpAddress;

  const MyHomePage({
    Key? key,
    required this.title,
    required this.asyncSnapshotIpAddress,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _ipAddress = "";

  @override
  Widget build(context) {

    if (widget.asyncSnapshotIpAddress.hasData && widget.asyncSnapshotIpAddress.data != null) {
      _ipAddress = widget.asyncSnapshotIpAddress.data!;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your ip address is:',
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              '$_ipAddress',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
