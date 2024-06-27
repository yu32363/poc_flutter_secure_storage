import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:intl/intl.dart';
import 'package:crypto/crypto.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  // Base key (should be kept secret)
  final String _baseKey = 'yu16basekeysecret';

  // Generate transaction key by DateFormat 'yyyyMMddHHmmssSSS'
  String _generateTransactionKey() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyyMMddHHmmssSSS');
    return formatter.format(now);
  }

  // Combine transactionKey then Hash key
  encrypt.Key _getKey(String transactionKey) {
    final keyString = _baseKey + transactionKey;
    final hashedKey = sha256.convert(utf8.encode(keyString)).toString();
    return encrypt.Key.fromBase16(hashedKey.substring(0, 32));
  }

  // Encrypt the data
  String _encrypt(String plainText) {
    final transactionKey = _generateTransactionKey();
    final key = _getKey(transactionKey);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return json.encode({
      'iv': iv.base64,
      'ciphertext': encrypted.base64,
      'transactionKey': transactionKey
    });
  }

  // Decrypt the data
  String _decrypt(String encryptedText) {
    final decoded = json.decode(encryptedText);
    final iv = encrypt.IV.fromBase64(decoded['iv']);
    final transactionKey = decoded['transactionKey'];
    final key = _getKey(transactionKey);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final decrypted = encrypter.decrypt64(decoded['ciphertext'], iv: iv);
    return decrypted;
  }

  Future<String> writeSecureData(String key, String value) async {
    String encryptedValue = _encrypt(value);
    await storage.write(key: key, value: encryptedValue);
    return encryptedValue;
  }

  Future<String> readSecureData(String key) async {
    String encryptedValue = await storage.read(key: key) ?? '';
    if (encryptedValue.isEmpty) return 'No data found!';
    String decryptedValue = _decrypt(encryptedValue);
    return decryptedValue;
  }

  Future<void> deleteSecureData(String key) async {
    await storage.delete(key: key);
  }
}
