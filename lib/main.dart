import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TextGenerationScreen(),
    );
  }
}

class TextGenerationScreen extends StatefulWidget {
  const TextGenerationScreen({super.key});

  @override
  State<TextGenerationScreen> createState() => _TextGenerationScreenState();
}

class _TextGenerationScreenState extends State<TextGenerationScreen> {
  final _promptController = TextEditingController();
  String _generatedText = '';

  Future<String> generateText(String prompt) async {
    final apiKey = "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";
    final apiUrl = 'https://api.openai.com/v1/completions';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey"
      },
      body: jsonEncode(
        {
          "prompt": prompt,
          "max_tokens": 500,
          "stop": ".",
          "model": 'text-davinci-003',
        },
      ),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return json['choices'][0]['text'];
    } else {
      throw Exception('Failed to generate text');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Generation'),
      ),
      backgroundColor: const Color(0xff1e1e1e),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              TextField(
                controller: _promptController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Ask me anything',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _generatedText = 'Loading...';
                  });
                  String text = await generateText(_promptController.text);
                  setState(
                    () {
                      _generatedText = text;
                      _promptController.text = '';
                    },
                  );
                },
                child: const Text(
                  'Generate response',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 50),
              _generatedText != ''
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/chat.png', width: 80),
                        Expanded(
                          child: Text(
                            _generatedText,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )
                  : const Text(''),
            ],
          ),
        ),
      ),
    );
  }
}
