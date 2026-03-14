import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';
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
    {'sender': 'Claw', 'text': 'Hello! I am Claw. How can I help you today?'}
  ];
  final TextEditingController _textController = TextEditingController();
  Shell? _shell;

  Future<void> _toggleConnection() async {
    if (_isBusy) return;

    setState(() {
      _isBusy = true;
    });

    try {
      if (!_isConnected) {
        // Start connection
        await _setupAndStartGateway();
        setState(() {
          _isConnected = true;
          _messages.add({
            'sender': 'System',
            'text': 'Connected to OpenClaw Gateway'
          });
        });
      } else {
        // Stop connection
        await _stopGateway();
        setState(() {
          _isConnected = false;
          _messages.add({
            'sender': 'System',
            'text': 'Disconnected from OpenClaw Gateway'
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          'sender': 'System',
          'text': 'Error: ${e.toString()}\n\nNote: This app requires a Termux environment or specific system permissions to run the OpenClaw gateway.'
        });
      });
    } finally {
      setState(() {
        _isBusy = false;
      });
    }
  }

  Future<void> _setupAndStartGateway() async {
    final directory = await getApplicationDocumentsDirectory();
    final scriptPath = '${directory.path}/setup_gateway.sh';

    // Copy script from assets to local storage to make it executable
    final byteData = await rootBundle.load('assets/setup_gateway.sh');
    final file = File(scriptPath);
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    _shell = Shell(workingDirectory: directory.path);
    await _shell!.run('chmod +x $scriptPath');
    await _shell!.run(scriptPath);

    // Start gateway in background (mocked here for the UI, in real app would keep process alive)
    // await _shell!.run('openclaw gateway &');
  }

  Future<void> _stopGateway() async {
    if (_shell != null) {
      // In a real app, you would kill the process
      // await _shell!.run('pkill -f openclaw');
      _shell = null;
    }
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _messages.add({'sender': 'You', 'text': text});
      // Mock response from Claw
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _messages.add({
              'sender': 'Claw',
              'text': 'Processing task: "$text"... (Mock response)'
            });
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
              itemCount: _messages.size,
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

extension on List {
  int get size => length;
}
