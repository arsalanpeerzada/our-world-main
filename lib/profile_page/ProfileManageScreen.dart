import 'package:flutter/material.dart';

class ProfileManageScreen extends StatelessWidget {
  const ProfileManageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Profile Management'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(

          children: [
            _buildInputCard(
              label: "Add Money \$",
              icon: Icons.add,
              hintText: "",
            ),
            const SizedBox(height: 10),
            _buildInputCard(
              label: "The amount available in my wallet \$",
              icon: null,
              hintText: "",
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Please Note if you choose money back, company will cut 20% as taxes",
                  style: TextStyle(color: Colors.green,fontSize: 10),
                ),
              ),
            ),
            _buildInputCard(
              label: "Get my money back",
              icon: Icons.add,
              hintText: "",
            ),
            const SizedBox(height: 10),
            _buildInputCard(
              label: "Profit before deducting the app % ( app %50 ) \$",
              icon: null,
              hintText: "",
            ),
            const SizedBox(height: 10),
            _buildInputCard(
              label: "Profit after deducting the app % \$",
              icon: null,
              hintText: "",
            ),
            const SizedBox(height: 10),
            _buildInputCard(
              label: "Pass calculation number",
              icon: null,
              hintText: "",
            ),
            const SizedBox(height: 10),
            _buildInputCard(
              label: "Total Profit Pass",
              icon: null,
              hintText: "",
            ),
            const SizedBox(height: 10),
            _buildInputCard(
              label: "Total Profile for all",
              icon: null,
              hintText: "",
            ),
            const SizedBox(height: 10),
            _buildInputCard(
              label: "Total profit for events",
              icon: Icons.add,
              hintText: "",
            ),
            const SizedBox(height: 10),
            _buildInputCard(
              label: "Withdraw \$ ",
              icon: Icons.add,
              hintText: "",
            ),
            const SizedBox(height: 10),
            _buildInputCard(
              label: "Send Message",
              icon: null,
              hintText: "",
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton("Send", Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard({
    required String label,
    IconData? icon,
    required String hintText,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                if (icon != null)
                  IconButton(
                    icon: Icon(icon),
                    onPressed: () {
                      // Handle button action
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, Color color) {
    return ElevatedButton(
      onPressed: () {
        // Handle button action
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(label),
    );
  }
}
