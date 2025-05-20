
import 'dart:math';

class KeyGenerationService {
  static const String baseAlphabet =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 !@#\$%&*()-_=+[]{};:,.<>?/|';

  static String generateCustomAlphabet(String first_name, String last_name, String dob) {
    String key = (first_name.length >= 3 ? first_name.substring(0, 3) : first_name) +
        (last_name.length >= 3 ? last_name.substring(0, 3) : last_name) +
        dob; // MM/DD

    StringBuffer filteredKey = StringBuffer();
    for (var c in key.runes) {
      if (!filteredKey.toString().contains(String.fromCharCode(c)) &&
          baseAlphabet.contains(String.fromCharCode(c))) {
        filteredKey.writeCharCode(c);
      }
    }

    StringBuffer customAlphabet = StringBuffer(filteredKey.toString());
    for (var c in baseAlphabet.runes) {
      if (!filteredKey.toString().contains(String.fromCharCode(c))) {
        customAlphabet.writeCharCode(c);
      }
    }
    return customAlphabet.toString();
  }

  static Map<String, String> generateKeys(DateTime now) {
    String dd = now.day.toString().padLeft(2, '0');
    String hh = now.hour.toString().padLeft(2, '0');
    String mm = now.minute.toString().padLeft(2, '0');
    String ss = now.second.toString().padLeft(2, '0');

    int sum1 = int.parse(dd) + int.parse(ss);
    int sum2 = int.parse(hh) + int.parse(mm);

    int p = _nextPrime(sum1);
    int q = _nextPrime(sum2);

    int n = p * q;
    int phi = (p - 1) * (q - 1);
    int e = 3;
    while (_gcd(e, phi) != 1) e++;
    int d = _modInverse(e, phi);

    return {
      'publicKey': 'PUB-$n\$_$e',
      'privateKey': 'PRV-$n\$_$d',
    };
  }

  static String encryptWithPublicKey(
    String text,
    String publicKey,
    String first_name,
    String last_name,
    String dob,
  ) {
    try {
      String alphabet = generateCustomAlphabet(first_name, last_name, dob);
      // ignore: unused_local_variable
      int alphabetLength = alphabet.length;

      final parts = publicKey.replaceFirst('PUB-', '').split('\$_');
      final n = int.parse(parts[0]);
      final e = int.parse(parts[1]);

      List<String> encryptedChars = [];

      for (var char in text.runes) {
        String c = String.fromCharCode(char);
        int charIndex = alphabet.indexOf(c);
        if (charIndex == -1) charIndex = alphabet.indexOf(' ');

        BigInt charCode = BigInt.from(charIndex);
        BigInt encrypted = charCode.modPow(BigInt.from(e), BigInt.from(n));

        int fixedLength = n.toString().length;

        String encryptedStr = encrypted.toString().padLeft(fixedLength, '0');
        encryptedChars.add(encryptedStr);
      }

      return encryptedChars.join('');
    } catch (e) {
      return 'Erro ao criptografar: chave pública inválida ou dados incorretos';
    }
  }

  static int _nextPrime(int n) {
    while (!_isPrime(n)) n++;
    return n;
  }

  static bool _isPrime(int n) {
    if (n < 2) return false;
    for (int i = 2; i <= sqrt(n).toInt(); i++) {
      if (n % i == 0) return false;
    }
    return true;
  }

  static int _gcd(int a, int b) {
    while (b != 0) {
      int t = b;
      b = a % b;
      a = t;
    }
    return a;
  }

  static int _modInverse(int a, int m) {
    for (int x = 1; x < m; x++) {
      if ((a * x) % m == 1) return x;
    }
    throw Exception('Mod inverse does not exist');
  }

  static String decryptWithPrivateKey({
    required String encrypted,
    required String privateKeyFormatted,
    required String first_Name,
    required String last_Name,
    required String dobMMDD,
  }) {
    // Extrai n e d da chave no formato "PRV-$n\$_$d"
    final match = RegExp(r'PRV-(\d+)\$_(\d+)').firstMatch(privateKeyFormatted);
    if (match == null) {
      throw FormatException('Chave privada inválida.');
    }

    final n = BigInt.parse(match.group(1)!);
    final d = BigInt.parse(match.group(2)!);

    // Gera o alfabeto personalizado com base no nome e data de nascimento
    final alphabet = generateCustomAlphabet(first_Name, last_Name, dobMMDD);

    // Divide o texto criptografado em blocos de mesmo tamanho de n
    final blockSize = n.toString().length;
    final encryptedBlocks = <String>[];
    for (var i = 0; i < encrypted.length; i += blockSize) {
      encryptedBlocks.add(encrypted.substring(i, i + blockSize));
    }

    // Descriptografa cada bloco e converte em caractere do alfabeto
    final decryptedChars = encryptedBlocks.map((block) {
      final encryptedValue = BigInt.parse(block);
      final decryptedValue = encryptedValue.modPow(d, n).toInt();
      if (decryptedValue < 0 || decryptedValue >= alphabet.length) {
        throw Exception('Valor descriptografado fora do intervalo do alfabeto.');
      }
      return alphabet[decryptedValue];
    });

    return decryptedChars.join();
  }

}


