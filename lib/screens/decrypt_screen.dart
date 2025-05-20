import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/key_generation_service.dart';
import '../services/user_service.dart';

class DecryptScreen extends StatefulWidget {
  const DecryptScreen({super.key});

  @override
  State<DecryptScreen> createState() => _DecryptScreenState();
}

class _DecryptScreenState extends State<DecryptScreen> {
  final _privateKeyController = TextEditingController();
  final _encryptedTextController = TextEditingController();

  String _decryptedText = '';

  late String _firstName;
  late String _lastName;
  late String _dobMMDD;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await UserService.getCurrentUser();
    if (user != null) {
      setState(() {
        _firstName = user.first_name;
        _lastName = user.last_name;
        _dobMMDD = user.dob; // já no formato MM/DD
      });
    }
  }
  void _decryptText() {
    try {
      final privateKeyStr = _privateKeyController.text.trim();
      final encrypted = _encryptedTextController.text.trim();

      if (privateKeyStr.isEmpty || encrypted.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preencha todos os campos obrigatórios.')),
        );
        return;
      }

      final decrypted = KeyGenerationService.decryptWithPrivateKey(
        encrypted: encrypted,
        privateKeyFormatted: privateKeyStr,
        first_Name: _firstName,
        last_Name: _lastName,
        dobMMDD: _dobMMDD,
      );

      setState(() {
        _decryptedText = decrypted;
      });
    } catch (e) {
      setState(() {
        _decryptedText = 'Erro ao descriptografar: ${e.toString()}';
      });
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _decryptedText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Texto copiado!')),
    );
  }

  void _saveText() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Texto salvo localmente (simulação).')),
    );
  }

  void _downloadText() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Download iniciado (simulação).')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Descriptografar Texto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Chave Privada'),
            TextField(
              controller: _privateKeyController,
              maxLines: 2,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            const Text('Texto Criptografado'),
            TextField(
              controller: _encryptedTextController,
              maxLines: 6,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _decryptText,
              child: const Text('Descriptografar'),
            ),
            const SizedBox(height: 24),
            const Text('Texto Descriptografado'),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                _decryptedText,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _copyToClipboard,
                  icon: const Icon(Icons.copy),
                  label: const Text('Copiar'),
                ),
                ElevatedButton.icon(
                  onPressed: _saveText,
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar'),
                ),
                ElevatedButton.icon(
                  onPressed: _downloadText,
                  icon: const Icon(Icons.download),
                  label: const Text('Baixar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
