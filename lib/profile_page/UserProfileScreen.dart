import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourworldmain/profile_page/ProfileManageScreen.dart';
import 'package:ourworldmain/profile_page/UserProfileScreenController.dart';

class UserProfileScreen extends StatelessWidget {
  var controller = Get.put(UserProfileScreenController());
  UserProfileScreen({Key? key}) : super(key: key);

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
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?img=3'), // Replace with the actual image URL
            ),
            const SizedBox(height: 10),
            Obx(() => Text(
              controller.uservalue.value, // Dynamically bind the username
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            )),
            const SizedBox(height: 20),
            _buildInputCard(
              icon: Icons.account_balance,
              label: 'PayPal Accounts',
              hintText: '352.96 × 78',
            ),
            _buildInputCard(
              icon: Icons.email,
              label: 'Email',
              hintText: 'Enter your email',
            ),
            _buildInputCard(
              icon: Icons.phone,
              label: 'Mobile Number',
              hintText: 'Enter your mobile number',
            ),
            _buildInputCard(
              icon: Icons.location_on,
              label: 'Locations',
              hintText: 'Enter your location',
            ),
            _buildInputCard(
              icon: Icons.flag,
              label: 'Nationality',
              hintText: 'Enter your nationality',
            ),
            _buildInputCard(
              icon: Icons.call,
              label: 'Telephone',
              hintText: 'Enter your telephone',
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton('Clear All', Colors.white),
                _buildActionButton('Save', Colors.white),
                _buildActionButton('Update', Colors.white),
                _buildActionButton('Next', Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard({
    required IconData icon,
    required String label,
    required String hintText,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Colors.grey),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, Color color) {
    return ElevatedButton(
      onPressed: () {
        if(label == "Next"){
          Get.to(() => ProfileManageScreen());
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(label),
    );
  }
}