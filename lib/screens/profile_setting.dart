import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Local states for preferences toggles
  bool _isDarkMode = true;
  String _selectedLanguage = 'English (IN)';

  // Custom theme colors matching your profile design
  final Color backgroundColor = const Color(0xFF0A0A0A);
  final Color cardColor = const Color(0xFF121212);
  final Color textGrey = const Color(0xFF8E8E93);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // 1. USER ACCOUNT MANAGEMENT
            // ==========================================
            _buildSectionHeader('USER ACCOUNT MANAGEMENT'),
            _buildTile(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              subtitle: 'Change picture, name, bio, and contact info',
              onTap: () {
                
              },
            ),
            const SizedBox(height: 24),

            // ==========================================
            // 2. APP PREFERENCES
            // ==========================================
            _buildSectionHeader('APP PREFERENCES'),
            // Dark Mode Toggle
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.dark_mode_outlined, color: Colors.white, size: 22),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dark Mode',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          _isDarkMode ? 'Sleek Dark Theme' : 'Light Theme',
                          style: TextStyle(color: textGrey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isDarkMode,
                    activeThumbColor: Colors.white,
                    activeTrackColor: Colors.grey[800],
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.grey[300],
                    onChanged: (value) {
                      setState(() {
                        _isDarkMode = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            // Language Selector Dropdown Tile
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.language_outlined, color: Colors.white, size: 22),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Language / Region',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Select regional preferences',
                          style: TextStyle(color: textGrey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  DropdownButton<String>(
                    value: _selectedLanguage,
                    dropdownColor: cardColor,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                    underline: const SizedBox(),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    items: <String>['English (IN)', 'English (US)', 'Hindi'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedLanguage = newValue;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // 3. PRIVACY & DATA
            // ==========================================
            _buildSectionHeader('PRIVACY & DATA'),
            _buildTile(
              icon: Icons.delete_forever_outlined,
              title: 'Delete Account',
              subtitle: 'Permanently remove your account and data',
              titleColor: Colors.redAccent,
              iconColor: Colors.redAccent,
              onTap: () => _showDeleteAccountDialog(context),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // 4. SUPPORT & LEGAL
            // ==========================================
            _buildSectionHeader('SUPPORT & LEGAL'),
            _buildTile(
              icon: Icons.help_outline_outlined,
              title: 'Help & Support',
              subtitle: 'FAQs, report a bug, or contact us',
              onTap: () {},
            ),
            _buildTile(
              icon: Icons.description_outlined,
              title: 'Terms & Privacy Policy',
              subtitle: 'How we securely handle your data',
              onTap: () {},
            ),
            _buildTile(
              icon: Icons.info_outline,
              title: 'About the App',
              subtitle: 'App Version v1.0.0',
              onTap: () => _showAboutAppDialog(context),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Section Header Helper
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          color: textGrey,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // Base Settings Row Custom Tile Helper
  Widget _buildTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color titleColor = Colors.white,
    Color iconColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: titleColor, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: textGrey, fontSize: 13),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: textGrey, size: 14),
          ],
        ),
      ),
    );
  }

  // Warning Popup Dialog for Account Deletion
  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Delete Account?', style: TextStyle(color: Colors.white)),
          content: Text(
            'This action is permanent and cannot be undone. All your event history and ticket registrations will be erased.',
            style: TextStyle(color: textGrey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
            TextButton(
              onPressed: () {
                // Handle deletion logic
                Navigator.pop(context);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }

  // Pop up showing developer/team details
  void _showAboutAppDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('About App', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Event Planner App', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Version 1.0.0', style: TextStyle(color: textGrey)),
              const SizedBox(height: 16),
              const Text('Developed by:', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text('• Your Name\n• Teammate 2\n• Teammate 3\n• Teammate 4\n• Teammate 5', style: TextStyle(color: textGrey, height: 1.4)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}