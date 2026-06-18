import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'event_details.dart';

class RegisteredEventsScreen extends StatelessWidget {
  final List<EventModel> events;
  final Set<String> savedEventIds;
  final Set<String> registeredEventIds;
  final Function(String) onSaveToggle;
  final Function(String) onRegisterToggle;

  const RegisteredEventsScreen({
    super.key,
    required this.events,
    required this.savedEventIds,
    required this.registeredEventIds,
    required this.onSaveToggle,
    required this.onRegisterToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),

      appBar: AppBar(
        title: const Text('Registered Events', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22)),
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];

          // return ListTile(
          //   title: Text(
          //     event.title,
          //     style: const TextStyle(color: Colors.white),
          //   ),

          //   subtitle: Text(
          //     event.date,
          //     style: const TextStyle(color: Colors.grey),
          //   ),

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF121212),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EventDetailScreen(
                    event: event,
                    isSaved: savedEventIds.contains(event.id),
                    isRegistered: true,
                    onSaveToggle: () => onSaveToggle(event.id),
                    onRegisterToggle: () => onRegisterToggle(event.id),
                  ),
                ),
              );
            },
child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(event.imagePlaceholder, style: const TextStyle(fontSize: 24)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title, 
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15), 
                            maxLines: 1, 
                            overflow: TextOverflow.ellipsis
                          ),
                          const SizedBox(height: 4),
                          Text(event.date, style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 13)),
                        ],
                  ),
                ),
                // 
              ],
            ),
          ),
        ),
          );
        },
      ),
    );
  }
}