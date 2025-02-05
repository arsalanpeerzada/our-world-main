import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewPage extends StatefulWidget {
  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final String telegramUrl = 'http://t.me/ourworldtrip';

  @override
  void initState() {
    super.initState();
    _launchTelegram();
  }

  Future<void> _launchTelegram() async {
    final Uri url = Uri.parse(telegramUrl);

    // Check if the Telegram app can handle the URL
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication, // Opens the Telegram app or browser
      );
      Navigator.pop(context); // Automatically navigate back after launching
    } else {
      // If Telegram app is not installed, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open Telegram. Please ensure it is installed.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Join Us"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Back icon
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Center(
        child: Text(
          'Launching Telegram...',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
