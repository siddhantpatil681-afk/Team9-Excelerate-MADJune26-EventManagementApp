import 'package:flutter/material.dart';
import 'feedback_screen.dart';
import 'main_shell.dart';

class FlutterDevScreen extends StatelessWidget {
  const FlutterDevScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // ── Scrollable body ────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),

                  // ── Page header with back button ───────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back_ios,
                              color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Event Details',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Event info card ────────────────────────────────────────
                  Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Flutter Dev Conference 2025',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(children: const [
                          Icon(Icons.calendar_today,
                              size: 22, color: Colors.white),
                          SizedBox(width: 12),
                          Text('June 22, 2025 • 10:00 AM',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16)),
                        ]),
                        const SizedBox(height: 12),
                        Row(children: const [
                          Icon(Icons.location_on,
                              size: 22, color: Colors.white),
                          SizedBox(width: 12),
                          Text('MMRDA Grounds, BKC, Mumbai',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16)),
                        ]),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text('248 registered',
                                style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 15)),
                            const SizedBox(width: 8),
                            Text('•',
                                style: TextStyle(
                                    color: Colors.grey.shade500)),
                            const SizedBox(width: 8),
                            Text('50 spots left',
                                style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 15)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ── About section ──────────────────────────────────────────
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'ABOUT',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatCard('6', 'Sessions'),
                        _buildStatCard('12', 'Speakers'),
                        _buildStatCard('Free', 'Entry'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Register button ────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Registration clicked!'),
                              backgroundColor: Colors.white,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding:
                              const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Register for this event',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: Text(
                        'Registration closes Jun 20',
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Feedback button ────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const FeedbackScreen()),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Colors.white38, width: 1),
                          padding:
                              const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text(
                          'Submit Feedback',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // ── Bottom nav (display-only; shell owns the real one) ─────────────
            BottomNav(currentIndex: 1),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 8),
          Text(label,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade300,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ─── Shared decorative bottom bar for detail screens ─────────────────────────
class BottomNav extends StatelessWidget {
  final int currentIndex;
  // ignore: use_key_in_widget_constructors
  const BottomNav({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF131316),
        border: Border(top: BorderSide(color: Color(0xFF202024), width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
    // ignore: unnecessary_underscores
    pageBuilder: (_, __, ___) => MainShell(initialIndex: i),
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
          ),
          (route) => false,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color(0xFF5A5A65),
        selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled, size: 20), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.event_outlined, size: 20), label: 'Event'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline_rounded, size: 20), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded, size: 20), label: 'Profile'),
        ],
      ),
    );
  }
}
