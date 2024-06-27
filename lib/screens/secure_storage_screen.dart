import 'package:flutter/material.dart';

import 'package:poc_flutter_secure_storage/data/local_storage/secure_storage.dart';
import 'package:poc_flutter_secure_storage/widgets/text_form_field_main.dart';

class SecureStorageScreen extends StatefulWidget {
  const SecureStorageScreen({super.key});

  @override
  State<SecureStorageScreen> createState() => _SecureStorageScreenState();
}

class _SecureStorageScreenState extends State<SecureStorageScreen> {
  final textEditingController = TextEditingController();

  String readData = 'No data read yet!';
  String writeData = 'No data written yet!';

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void _writeData() async {
    if (textEditingController.text.isEmpty) return;
    String value = await SecureStorage()
        .writeSecureData('name', textEditingController.text);
    setState(() {
      writeData = value;
    });
    textEditingController.clear();
  }

  void _readData() async {
    String value = await SecureStorage().readSecureData('name');
    setState(() {
      readData = value;
    });
  }

  void _deleteData() async {
    await SecureStorage().deleteSecureData('name');
    setState(() {
      readData = 'No data read yet!';
      writeData = 'No data written yet!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.security,
                  color: Theme.of(context).colorScheme.primary, size: 100),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Storing data securely using Flutter Secure Storage',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormFieldMain(textEditingController: textEditingController),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: _writeData,
                child: const Text(
                  'Store Data',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Data encrypted and write to secure storage:',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                writeData,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary, fontSize: 14),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: _readData,
                child: const Text(
                  'Read Data',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Data read from secure storage:',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                readData,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary, fontSize: 14),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: _deleteData,
                child: const Text(
                  'Delete Data',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
