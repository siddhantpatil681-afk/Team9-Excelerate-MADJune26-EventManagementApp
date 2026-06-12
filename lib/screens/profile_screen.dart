// profile_screen
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter/services.dart';
import 'profile_setting.dart';
import 'login_signin.dart';

@Preview()
Widget profileScreenPreview(){
  return const MaterialApp(
    home: ProfileScreen(),
    );
}
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Custom dark background color matching the design
    const backgroundColor = Color(0xFF0A0A0A);
    const cardColor = Color(0xFF121212);
    const textGrey = Color(0xFF8E8E93);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Makes the bar blend in
      statusBarIconBrightness: Brightness.light, // For Android (white icons)
      statusBarBrightness: Brightness.dark, // For iOS (white icons)
    ));

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Title and Settings Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                    GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  },
  child: Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white10),
    ),
    child: const Icon(Icons.settings_outlined, color: Colors.white),
  ),
),    
                ],
              ),
              const SizedBox(height: 24),

              // Statistics Row (Registered, Attended, Saved)
              Row(
                children: [
                  Expanded(child: _buildStatCard('4', 'Registered', cardColor)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard('2', 'Attended', cardColor)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard('3', 'Saved', cardColor)),
                ],
              ),
              const SizedBox(height: 32),

              // Section: My Registered Events
              const Text(
                'MY REGISTERED EVENTS',
                style: TextStyle(
                  color: textGrey,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),

              // Event Card 1: Flutter Dev Conf
              _buildEventCard(
                icon: Icons.calendar_today_outlined,
                title: 'Flutter Dev Conf',
                date: 'Jun 22 • 10:00 AM',
                location: 'BKC, Mumbai',
                status: 'Confirmed',
                statusColor: Colors.grey[800]!,
                cardColor: cardColor,
              ),
              const SizedBox(height: 16),

              // Event Card 2: Startup Pitch Night
              _buildEventCard(
                icon: Icons.mic_none_outlined,
                title: 'Startup Pitch Night',
                date: 'Jun 25 • 06:00 PM',
                location: 'Powai, Mumbai',
                status: 'Pending',
                statusColor: Colors.grey[800]!,
                cardColor: cardColor,
              ),
              const SizedBox(height: 32),

              // Section: Account
              const Text(
                'ACCOUNT',
                style: TextStyle(
                  color: textGrey,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),

              // Account Option: Notifications
              _buildAccountOption(
                icon: Icons.notifications_none_outlined,
                title: 'Notifications',
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                cardColor: cardColor,
                onTap: () {}
              ),
              const SizedBox(height: 12),

              // Account Option: Sign Out
              _buildAccountOption(
                icon: Icons.logout_outlined,
                title: 'Sign out',
                trailing: const SizedBox.shrink(),
                cardColor: cardColor,
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },

              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: backgroundColor,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: textGrey,
          currentIndex: 3, // Highlight the Profile tab
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Events'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), label: 'Saved'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Stats
  Widget _buildStatCard(String count, String label, Color cardColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF8E8E93),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget for Event Cards
  Widget _buildEventCard({
    required IconData icon,
    required String title,
    required String date,
    required String location,
    required String status,
    required Color statusColor,
    required Color cardColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Icon Container
          Container(
            padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          // Event Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  date,
                  style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget for Account Menu List Rows
  Widget _buildAccountOption({
    required IconData icon,
    required String title,
    required Widget trailing,
    required Color cardColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}