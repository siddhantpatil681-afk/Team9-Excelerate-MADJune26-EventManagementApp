import 'package:flutter/material.dart';

import 'flutter.dart';
import 'photograpy.dart';
import 'startup.dart';
import 'profile_screen.dart';
void main() {
  runApp(const EventHubApp());
}

class EventHubApp extends StatelessWidget {
  const EventHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1E1E1E),
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          prefixIconColor: Colors.grey,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF333333), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2C2C2C), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white, width: 1),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// ─── Data Model ───────────────────────────────────────────────────────────────

class EventModel {
  final String id;
  final String title;
  final String date;
  final String location;
  final String badge; // "Free" | "Paid" | "PMN" etc.
  final bool isFeatured;
  int registered;
  final int capacity;
  bool isSaved;

  EventModel({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.badge,
    this.isFeatured = false,
    this.registered = 0,
    this.capacity = 100,
    this.isSaved = false,
  });
}

// ─── Home Screen ──────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  final List<String> _tabs = ['Home', 'Events', 'Saved', 'Profile'];
  final List<IconData> _tabIcons = [
    Icons.home_outlined,
    Icons.event_outlined,
    Icons.bookmark_border_outlined,
    Icons.person_outline,
  ];

  final List<EventModel> _events = [];
  final GlobalKey<SliverAnimatedListState> _listKey = GlobalKey<SliverAnimatedListState>();
  
  String _searchQuery = '';
  late AnimationController _emptyStateController;

  @override
  void initState() {
    super.initState();
    _emptyStateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _emptyStateController.dispose();
    super.dispose();
  }

  List<EventModel> get _filteredEvents {
    if (_searchQuery.isEmpty) return _events;
    return _events.where((e) => e.title.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  void _addNewEvent(EventModel event) {
    setState(() {
      _events.insert(0, event);
      _listKey.currentState?.insertItem(0, duration: const Duration(milliseconds: 400));
    });
  }

  // ─── Main Build Method ─────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      // Dynamically switch the body layout based on the selected tab index
      body: SafeArea(
        child: IndexedStack(
          index: _selectedTab,
          children: [
            _buildHomeContent(),                  // Index 0: Home
            const Center(child: Text('Events', style: TextStyle(color: Colors.white))), // Index 1: Events Placeholder
            const Center(child: Text('Saved', style: TextStyle(color: Colors.white))),  // Index 2: Saved Placeholder
            const ProfileScreen(),                 // Index 3: Your separate Profile Screen
          ],
        ),
      ),

      // ── Bottom Nav ─────────────────────────────────────────────────────────
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(border: Border(top: BorderSide(color:  Color(0xFF2C2C2C), width: 1)), color: Color(0xFF121212)),
        child: BottomNavigationBar(
          currentIndex: _selectedTab,
          onTap: (i) => setState(() => _selectedTab = i),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: const Color(0xFF555555),
          selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: List.generate(
            4,
            (i) => BottomNavigationBarItem(
              icon: Icon(_tabIcons[i], size: 22),
              label: _tabs[i],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Extracted Home Content Layout ──────────────────────────────────────────
  Widget _buildHomeContent() {
    final upcomingEvents = _filteredEvents.where((e) => !e.isFeatured).toList();
    final featuredEvents = _filteredEvents.where((e) => e.isFeatured).toList();

    return CustomScrollView(
      slivers: [
        // ── App Bar ──────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF333333), width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'EventHub',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.3),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 22),
                      onPressed: () => _showAddEventBottomSheet(context),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF2C2C2C), width: 1),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(Icons.notifications_outlined, size: 18, color: Colors.white),
                          Positioned(
                            top: 6,
                            right: 7,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // ── Search Bar ───────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF2C2C2C), width: 1),
              ),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Search events…',
                  hintStyle: TextStyle(color: Color(0xFF666666), fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF666666), size: 20),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 0),
                ),
              ),
            ),
          ),
        ),

        // ── Dynamic Layout Switcher ────────
        if (_events.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: FadeTransition(
              opacity: _emptyStateController,
              child: ScaleTransition(
                scale: CurvedAnimation(parent: _emptyStateController, curve: Curves.easeOutBack),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_note_outlined, size: 64, color: Colors.grey[800]),
                      const SizedBox(height: 16),
                      const Text('No Events Scheduled', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text('Create clean layouts. Add your first app event below.', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () => _showAddEventBottomSheet(context),
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Add Live Event'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        else ...[
          if (featuredEvents.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: _FeaturedCard(event: featuredEvents.first),
              ),
            ),

          if (upcomingEvents.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Upcoming Events', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('${upcomingEvents.length} found', style: const TextStyle(fontSize: 13, color: Color(0xFF888888))),
                  ],
                ),
              ),
            ),

          SliverAnimatedList(
            key: _listKey,
            initialItemCount: _events.length,
            itemBuilder: (context, index, animation) {
              final item = _events[index];
              if (item.isFeatured) return const SizedBox.shrink();

              return SlideTransition(
                position: animation.drive(
                  Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).chain(CurveTween(curve: Curves.easeOutCubic)),
                ),
                child: FadeTransition(
                  opacity: animation,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: _EventListTile(
                      event: item,
                      onSavedToggle: () => setState(() => item.isSaved = !item.isSaved),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
  void _showAddEventBottomSheet(BuildContext context) {
    final titleController = TextEditingController();
    final locController = TextEditingController();
    String selectedBadge = 'Free';
    bool markAsFeatured = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Create New App Event', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 20),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(hintText: 'Event Title'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: locController,
                      decoration: const InputDecoration(hintText: 'Location / Venue'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Access Tier:  ', style: TextStyle(color: Colors.grey)),
                        ...['Free', 'Paid', 'PMN'].map((tier) {
                          final isSel = selectedBadge == tier;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(tier, style: TextStyle(color: isSel ? Colors.black : Colors.white, fontSize: 12)),
                              selected: isSel,
                              selectedColor: Colors.white,
                              backgroundColor: const Color(0xFF2A2A2A),
                              showCheckmark: false,
                              onSelected: (selected) {
                                if (selected) setModalState(() => selectedBadge = tier);
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      title: const Text('Highlight as Featured Event', style: TextStyle(fontSize: 14, color: Colors.white)),
                      value: markAsFeatured,
                      activeThumbColor: Colors.white,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setModalState(() => markAsFeatured = val),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          if (titleController.text.isNotEmpty) {
                            final newEvent = EventModel(
                              id: DateTime.now().toString(),
                              title: titleController.text,
                              location: locController.text.isEmpty ? 'Remote' : locController.text,
                              date: 'Today • ${locController.text}',
                              badge: selectedBadge,
                              isFeatured: markAsFeatured,
                              capacity: markAsFeatured ? 500 : 100,
                            );
                            _addNewEvent(newEvent);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Publish Event', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ─── Featured Card component ──────────────────────────────────────────────────

class _FeaturedCard extends StatefulWidget {
  final EventModel event;
  const _FeaturedCard({required this.event});

  @override
  State<_FeaturedCard> createState() => _FeaturedCardState();
}

class _FeaturedCardState extends State<_FeaturedCard> {
  bool _isRegistered = false;

  @override
  Widget build(BuildContext context) {
    final currentReg = widget.event.registered + (_isRegistered ? 1 : 0);
    final pct = widget.event.capacity > 0 ? currentReg / widget.event.capacity : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2C2C2C), width: 1),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                    child: const Text(
                      'Featured',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 0.5),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _BadgeChip(label: widget.event.badge, bright: true),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            widget.event.title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white, height: 1.3),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 13, color: Color(0xFF888888)),
              const SizedBox(width: 5),
              Text(widget.event.date, style: const TextStyle(fontSize: 12, color: Color(0xFF888888))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$currentReg registered', style: const TextStyle(fontSize: 12, color: Color(0xFF888888))),
              Text('${widget.event.capacity} spots', style: const TextStyle(fontSize: 12, color: Color(0xFF888888))),
            ],
          ),
          const SizedBox(height: 6),
          // Clean implicit width progress line
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 4,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct,
                backgroundColor: const Color(0xFF2C2C2C),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => setState(() => _isRegistered = !_isRegistered),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isRegistered ? const Color(0xFF2C2C2C) : Colors.white,
                foregroundColor: _isRegistered ? Colors.white : Colors.black,
                minimumSize: const Size.fromHeight(44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: _isRegistered ? const Color(0xFF444444) : Colors.transparent),
                ),
                elevation: 0,
              ),
              child: Text(
                _isRegistered ? 'Leave Event' : 'Register for this event',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Event List Tile component ────────────────────────────────────────────────

class _EventListTile extends StatelessWidget {
  final EventModel event;
  final VoidCallback onSavedToggle;

  const _EventListTile({
    required this.event,
    required this.onSavedToggle,
  });

  @override
  Widget build(BuildContext context) {
    // Wrap the container in a GestureDetector or InkWell to handle the tap
    return GestureDetector(
      onTap: () async {
        // Match the event title to navigate to your specific event screen
        if (event.title.contains('Flutter')) {
          await Navigator.push<int>(
            context,
            MaterialPageRoute(builder: (context) => const FlutterDevScreen()),
          );
        } else if (event.title.contains('Photography')) {
          await Navigator.push<int>(
            context,
            MaterialPageRoute(builder: (context) => const PhotographyScreen()),
          );
        } else if (event.title.contains('Startup')) {
          await Navigator.push<int>(
            context,
            MaterialPageRoute(builder: (context) => const StartupScreen()),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2C2C2C), width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF333333), width: 1),
              ),
              child: const Icon(Icons.event_outlined, size: 20, color: Color(0xFF888888)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 11, color: Color(0xFF666666)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.date,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(
                event.isSaved ? Icons.bookmark : Icons.bookmark_border_outlined,
                size: 20,
                color: event.isSaved ? Colors.white : const Color(0xFF666666),
              ),
              onPressed: onSavedToggle,
            ),
            const SizedBox(width: 12),
            _BadgeChip(label: event.badge),
          ],
        ),
      ),
    );
  }
}
class _BadgeChip extends StatelessWidget {
  final String label;
  final bool bright;
  const _BadgeChip({required this.label, this.bright = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bright ? const Color(0xFF2C2C2C) : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 1),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 0.3),
      ),
    );
  }
  }