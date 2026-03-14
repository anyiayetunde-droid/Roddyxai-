import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const ClawApp());
}

class ClawApp extends StatelessWidget {
  const ClawApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Claw App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const MainChatScreen(),
    );
  }
}

class MainChatScreen extends StatefulWidget {
  const MainChatScreen({super.key});

  @override
  State<MainChatScreen> createState() => _MainChatScreenState();
}

class _MainChatScreenState extends State<MainChatScreen> {
  bool _isConnected = false;
  bool _isBusy = false;
  final List<Map<String, String>> _messages = [
    {'sender': 'Claw', 'text': 'Hello! I am Claw, powered by Jules AI. How can I help you today?'}
  ];
  final TextEditingController _textController = TextEditingController();

  // Jules AI API Key provided by the user
  final String _apiKey = "AQ.Ab8RN6KXejXyQYXVXnCvpKHZUeEuZUxdm32fBv_P4RX-kDIF1w";

  Future<void> _toggleConnection() async {
    if (_isBusy) return;

    setState(() {
      _isBusy = true;
    });

    // Simulate connecting to Jules AI service
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isConnected = !_isConnected;
      _isBusy = false;
      _messages.add({
        'sender': 'System',
        'text': _isConnected
            ? 'Connected to Jules AI Gateway using API Key: ${_apiKey.substring(0, 5)}...'
            : 'Disconnected from Jules AI Gateway'
      });
    });
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;
    _textController.clear();
    setState(() {
      _messages.add({'sender': 'You', 'text': text});

      // Simulate interaction with Jules AI
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() {
            if (!_isConnected) {
               _messages.add({
                'sender': 'Claw',
                'text': 'I am currently offline. Please tap the connection icon (🔗) to start the Jules AI Gateway.'
              });
            } else {
              _messages.add({
                'sender': 'Claw',
                'text': 'Jules AI is processing your request: "$text". I am connected and ready to assist with your tasks.'
              });
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Claw AI Assistant'),
        actions: [
          if (_isBusy)
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: Icon(
                _isConnected ? Icons.link : Icons.link_off,
                color: _isConnected ? Colors.green : Colors.red,
              ),
              onPressed: _toggleConnection,
              tooltip: _isConnected ? 'Disconnect' : 'Connect',
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['sender'] == 'You';
                final isSystem = message['sender'] == 'System';

                return Align(
                  alignment: isUser ? Alignment.centerRight : (isSystem ? Alignment.center : Alignment.centerLeft),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Colors.blue[100]
                          : (isSystem ? Colors.grey[200] : Colors.grey[300]),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        if (!isSystem)
                          Text(
                            message['sender']!,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                          ),
                        Text(message['text']!),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.primary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: const InputDecoration.collapsed(hintText: 'Send a message'),
                enabled: _isConnected,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: _isConnected ? () => _handleSubmitted(_textController.text) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
