import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  String _response = '';
  String _appBarTitle = 'Your assisting buddy'; //adding the title change potential to the class

  Future<void> _sendMessage(String message) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/chat'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'context': '', 'question': message}),
    );
    final responseData = json.decode(response.body);
    setState(() {
      _response = responseData['response'];
      _appBarTitle = 'Your assisting buddy'; //title change here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_appBarTitle)),
      body: Column(
        children: [
          Expanded(child: Text(_response)),
          TextField(
            controller: _controller,
            onSubmitted: (text) {
              _sendMessage(text);
              _controller.clear();
            },
            decoration: const InputDecoration(labelText: 'Type your message'),
          ),
        ],
      ),
    );
  }
}
