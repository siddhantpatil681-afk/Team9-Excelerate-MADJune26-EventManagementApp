import 'package:flutter/material.dart';
import 'event_details.dart';

class EventModel {
  final String id;
  final String title;
  final String date;
  final String location;
  final String badge;
  final String imagePlaceholder;
  final int registered;
  final int capacity;
  final String description;

  const EventModel({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.badge,
    required this.imagePlaceholder,
    required this.registered,
    required this.capacity,
    required this.description,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      location: json['location'] ?? '',
      badge: json['badge'] ?? '',
      imagePlaceholder: json['imagePlaceholder'] ?? '📅',
      registered: json['registered'] ?? 0,
      capacity: json['capacity'] ?? 0,
      description: json['description'] ?? 'No description provided.',
    );
  }
}

class HomeScreenBody extends StatelessWidget {
  final List<EventModel> featuredEvents;
  final List<EventModel> upcomingEvents;
  final Set<String> savedEventIds;
  final Set<String> registeredEventIds;
  final Function(String) onSaveToggle;
  final Function(String) onRegisterToggle;
  final bool notificationsEnabled;
final VoidCallback onNotificationToggle;

  const HomeScreenBody({
    super.key,
    required this.featuredEvents,
    required this.upcomingEvents,
    required this.savedEventIds,
    required this.registeredEventIds,
    required this.onSaveToggle,
    required this.onRegisterToggle,
    required this.notificationsEnabled,
    required this.onNotificationToggle,

  });

// Inside home_screen.dart
@override
Widget build(BuildContext context) {
  if (featuredEvents.isEmpty) {
    return const Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      body: Center(child: Text('No featured events available.', style: TextStyle(color: Colors.white))),
    );
  }

  return SafeArea(
    child: CustomScrollView(
      slivers: [
        // ── Header ──────────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1E),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF26262B)),
                      ),
                      child: const Icon(Icons.grid_view_rounded, size: 18, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    const Text('EventHub', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5)),
                  ],
                ),
                GestureDetector(
  onTap: onNotificationToggle, // callback from MainShell
  child: Container(
    padding: const EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: const Color(0xFF1A1A1E),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color(0xFF26262B)),
    ),
    child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Icon(
        notificationsEnabled
            ? Icons.notifications_none_rounded
            : Icons.notifications_off_rounded,
        key: ValueKey(notificationsEnabled),
        size: 18,
        color: Colors.white,
      ),
    ),
  ),
),
              ],
            ),
          ),
        ),

        // ── First Horizontal Slider (Featured Events) ──────────────────────
        SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Featured Events',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 290,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: featuredEvents.length,
                      itemBuilder: (context, index) {
                        final event = featuredEvents[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EventDetailScreen(
                                event: event,
                                isSaved: savedEventIds.contains(event.id),
                                isRegistered: registeredEventIds.contains(event.id),
                                onSaveToggle: () => onSaveToggle(event.id),
                                onRegisterToggle: () => onRegisterToggle(event.id),
                              ),
                            ),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            margin: const EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1E),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFF26262B)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 110,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF26262B),
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                                  ),
                                  child: Center(
                                    child: Text(event.imagePlaceholder, style: const TextStyle(fontSize: 36)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        event.title,
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.calendar_today_outlined, size: 12, color: Color(0xFF9696A0)),
                                          const SizedBox(width: 6),
                                          Text(event.date, style: const TextStyle(fontSize: 12, color: Color(0xFF9696A0))),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF9696A0)),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              event.location,
                                              style: const TextStyle(fontSize: 12, color: Color(0xFF9696A0)),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('+${event.registered} going', style: const TextStyle(fontSize: 11, color: Color(0xFF9696A0))),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                                            child: const Text(
                                              'Register',
                                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Slider 2: Discover More Events (Underneath Slider 1) ────────────
          if (upcomingEvents.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Discover More Events',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 290,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: upcomingEvents.length,
                        itemBuilder: (context, index) {
                          final event = upcomingEvents[index];
                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EventDetailScreen(
                                  event: event,
                                  isSaved: savedEventIds.contains(event.id),
                                  isRegistered: registeredEventIds.contains(event.id),
                                  onSaveToggle: () => onSaveToggle(event.id),
                                  onRegisterToggle: () => onRegisterToggle(event.id),
                                ),
                              ),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              margin: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A1A1E),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFF26262B)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 110,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF26262B),
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                                    ),
                                    child: Center(
                                      child: Text(event.imagePlaceholder, style: const TextStyle(fontSize: 36)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          event.title,
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_today_outlined, size: 12, color: Color(0xFF9696A0)),
                                            const SizedBox(width: 6),
                                            Text(event.date, style: const TextStyle(fontSize: 12, color: Color(0xFF9696A0))),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF9696A0)),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                event.location,
                                                style: const TextStyle(fontSize: 12, color: Color(0xFF9696A0)),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('+${event.registered} going', style: const TextStyle(fontSize: 11, color: Color(0xFF9696A0))),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                                              child: const Text(
                                                'Register',
                                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }
}
