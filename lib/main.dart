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
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ScrapboxSummary'),
          shape: const Border(
            bottom: BorderSide(
              color: Color(0xFFD1D1D1),
              width: 1.0,
            ),
          ),
        ),
        body: const SummaryForm(),
      ),
    );
  }
}

class SummaryForm extends StatefulWidget {
  const SummaryForm({super.key});

  @override
  State<SummaryForm> createState() => _SummaryFormState();
}

class _SummaryFormState extends State<SummaryForm> {
  final _formKey = GlobalKey<FormState>();
  String _apiKey = '';
  String _model = 'gpt-4';
  String _scrapboxProjectName = 'okaryo';
  String _scrapboxAuthToken = '';
  String _scrapboxPages = '';
  String _prompt = '''
以下の開発日誌の内容を週報としてまとめてください。''';
  String _output = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 675),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: _apiKey,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'OpenAI API Key',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _model,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'モデル名',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _scrapboxProjectName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Scrapboxのプロジェクト名',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _scrapboxAuthToken,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Scrapboxの認証情報(プライベートプロジェクトの場合)',
                    hintText: 'Cookie内のconnect.sidの値',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _scrapboxPages,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '要約したいページ(改行区切りで複数指定可)',
                  ),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _prompt,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '要約用プロンプト(プロンプトの下にページの内容が追加される)',
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _summarize(),
                    child: const Text('要約する'),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _output,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '出力結果',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _summarize() async {
    final cookies = 'connect.sid=$_scrapboxAuthToken';
    final res = await http.get(
      Uri.parse('https://scrapbox.io/api/pages/okaryo/ScrapboxSummary/text'),
      headers: {
        'Cookie': cookies,
      },
    );
  }
}
