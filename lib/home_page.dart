// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _numberController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  int _totalAngka = 0;

  bool _isDimulai08 = false;
  bool _isValidTotalAngka = false;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _numberController.addListener(() {
      _updateValues();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  void _updateValues() {
    String input = _numberController.text;

    // Hitung jumlah angka dalam input
    int count = input.replaceAll(RegExp(r'\D'), '').length;

    // Periksa apakah input dimulai dengan 08
    bool startWith08 = input.startsWith('08');

    // Periksa apakah jumlah angka valid (10 hingga 13)
    bool isValidCount = count >= 10 && count <= 13;

    setState(() {
      _totalAngka = count;
      _isDimulai08 = startWith08;
      _isValidTotalAngka = isValidCount;
      _isButtonEnabled = _isDimulai08 && _isValidTotalAngka;
    });
  }

  Future<void> _launchWhatsApp() async {
    // Menghapus semua karakter non-digit dari input
    String cleanedNumber = _numberController.text.replaceAll(RegExp(r'\D'), '');

    // Menghapus digit pertama jika ada
    if (cleanedNumber.isNotEmpty) {
      cleanedNumber = cleanedNumber.substring(1);
    }

    // Menambahkan kode negara (62 untuk Indonesia)
    final Uri url = Uri.parse('https://wa.me/62$cleanedNumber');

    if (!await launchUrl(url)) {
      throw Exception('Tidak bisa mengakses $url');
    }
  }

  Future<void> _launchTelegram() async {
    // Menghapus semua karakter non-digit dari input
    String cleanedNumber = _numberController.text.replaceAll(RegExp(r'\D'), '');

    // Menghapus digit pertama jika ada
    if (cleanedNumber.isNotEmpty) {
      cleanedNumber = cleanedNumber.substring(1);
    }

    // Menambahkan kode negara (62 untuk Indonesia)
    final Uri url = Uri.parse('https://t.me/+62$cleanedNumber');

    if (!await launchUrl(url)) {
      throw Exception('Tidak bisa mengakses $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Langsung Chat"),
        automaticallyImplyLeading: true,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const Text(
                    // "masukkan nomor \nuntuk langsung chat di whatsapp",
                    "masukkan nomor baru untuk langsung chat",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "simpan nomor setelahnya bila perlu",
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    "(+62) Indonesia",
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                            left: 16.0,
                            top: 10.0,
                          ),
                          child: Text(
                            "Pengecekan:",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            _isDimulai08 ? Icons.done : Icons.close,
                            color: _isDimulai08 ? Colors.green : Colors.red,
                          ),
                          title: const Text(
                            "Dimulai angka 08",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            _isValidTotalAngka ? Icons.done : Icons.close,
                            color:
                                _isValidTotalAngka ? Colors.green : Colors.red,
                          ),
                          title: Text(
                            "Total angka = $_totalAngka (min 10, maks 13)",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 4,
                  child: TextFormField(
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    focusNode: _focusNode,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _NumberTextInputFormatter()
                    ],
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: "Masukkan nomor",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _updateValues();
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    color: Colors.amber,
                    onPressed: _isButtonEnabled
                        ? () {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Chat ke Aplikasi"),
                                  actions: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black54, width: 1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: InkWell(
                                        onTap: _launchWhatsApp,
                                        child: ListTile(
                                          leading: Image.asset(
                                            "assets/logo/whatsapp.png",
                                            width: 32,
                                          ),
                                          title: const Text("WhatsApp"),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black54, width: 1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: InkWell(
                                        onTap: _launchTelegram,
                                        child: ListTile(
                                          leading: Image.asset(
                                            "assets/logo/telegram.png",
                                            width: 32,
                                          ),
                                          title: const Text("Telegram"),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        "Tutup",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        : null,
                    icon: Icon(
                      Icons.chat,
                      color: _isButtonEnabled
                          ? const Color.fromARGB(255, 54, 130, 57)
                          : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class _NumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove all non-digit characters
    final cleanedInput = newValue.text.replaceAll(RegExp(r'\D'), '');
    // Add spaces every 4 digits
    final buffer = StringBuffer();
    for (var i = 0; i < cleanedInput.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(cleanedInput[i]);
    }
    return newValue.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
