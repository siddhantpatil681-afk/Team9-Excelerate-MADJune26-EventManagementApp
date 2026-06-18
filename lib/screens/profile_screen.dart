import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart'; // Safe path access to share EventModel configurations
import 'profile_setting.dart';
import 'login_signin.dart';
import 'registered_event_screen.dart';

class ProfileScreenBody extends StatelessWidget {
  final List<EventModel> allEvents;
  final Set<String> savedEventIds;
  final Set<String> registeredEventIds;
  final Function(int)? onTabChange;
  final Function(String) onSaveToggle;
final Function(String) onRegisterToggle;

  const ProfileScreenBody({
    super.key,
    required this.allEvents,
    required this.savedEventIds,
    required this.registeredEventIds,
    required this.onTabChange,
    required this.onSaveToggle,
    required this.onRegisterToggle,
  });

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF121212);
    const textGrey = Color(0xFF8E8E93);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    // Filter matching datasets out of global configuration rules
    final registeredEventsList = allEvents.where((e) => registeredEventIds.contains(e.id)).toList();
    final previewEvents = registeredEventsList.take(4).toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Profile',
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  ),
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

            // ── Stats row (Dynamically updated counts) ───────────────────────
            Row(
              children: [
                Expanded(child:
                _buildStatCard(
  '${registeredEventIds.length}',
  'Registered',
  cardColor,
  onTap: () {

    final registeredEvents = allEvents
        .where((event) => registeredEventIds.contains(event.id))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegisteredEventsScreen(
          events: registeredEvents,
          savedEventIds: savedEventIds,
          registeredEventIds: registeredEventIds,
          onSaveToggle: onSaveToggle,
          onRegisterToggle: onRegisterToggle,
        ),
      ),
    );
  },
)
                ),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('0', 'Attended', cardColor)),
                const SizedBox(width: 12),
                Expanded(
  child: _buildStatCard(
    '${savedEventIds.length}',
    'Saved',
    cardColor,
    onTap: () {
      onTabChange?.call(2); // Saved tab index
    },
  ),
),
              ],
            ),
            const SizedBox(height: 32),

            // ── Registered events section ────────────────────────────────────
            const Text(
              'MY REGISTERED EVENTS',
              style: TextStyle(color: textGrey, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
            const SizedBox(height: 16),

            if (registeredEventsList.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: const Text(
                  'You have not registered for any events yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textGrey, fontSize: 14),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: previewEvents.length,
                itemBuilder: (context, index) {
                  final event = previewEvents[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _buildEventCard(
                      icon: Icons.calendar_today_outlined,
                      title: event.title,
                      date: event.date,
                      location: event.location.split(',').last.trim(), // Pulls city clean
                      status: 'Confirmed',
                      statusColor: Colors.green[800]!,
                      cardColor: cardColor,
                    ),
                  );
                },
              ),

            const SizedBox(height: 32),

            // ── Account section ──────────────────────────────────────────────
            const Text(
              'ACCOUNT',
              style: TextStyle(color: textGrey, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
            const SizedBox(height: 16),

            _buildAccountOption(
              icon: Icons.notifications_none_outlined,
              title: 'Notifications',
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
              cardColor: cardColor,
              onTap: () {},
            ),
            const SizedBox(height: 12),

            _buildAccountOption(
              icon: Icons.logout_outlined,
              title: 'Sign out',
              trailing: const SizedBox.shrink(),
              cardColor: cardColor,
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
  String count,
  String label,
  Color cardColor, {
  VoidCallback? onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
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
    ),
  );
}

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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
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
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(date, style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 13)),
                const SizedBox(height: 4),
                Text(location, style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

typedef ProfileScreen = ProfileScreenBody;