import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; // <-- Required package package access helper
import 'home_screen.dart';
import 'profile_screen.dart';
import 'event_details.dart';


class MainShell extends StatefulWidget {
  final int initialIndex;
  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex = 0;
  bool _isLoading = true;
   bool _notificationsEnabled = true;

   void _toggleNotifications() {
    setState(() {
      _notificationsEnabled = !_notificationsEnabled;
    });
  }


  final Set<String> _savedEventIds = {};
  final Set<String> _registeredEventIds = {};
  List<EventModel> _allEvents = [];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _loadEventsFromJSON();
  }

  // ─── READ SEPARATED JSON FILE ─────────────────────────────────────────────
  Future<void> _loadEventsFromJSON() async {
    try {
      // 1. Fetch file string streams straight from assets bundle registry folder location
      final String jsonString = await rootBundle.loadString('assets/events.json');
      
      // 2. Decode string stream down into a structural collection pool map array
      final List<dynamic> decodedJson = json.decode(jsonString);
      
      // 3. Cast maps clean straight into your active EventModel structures
      setState(() {
        _allEvents = decodedJson.map((item) => EventModel.fromJson(item)).toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading JSON asset: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ─── Slicing Logic Tab Router ─────────────────────────────────────────────
  Widget _bodyForIndex(int index) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A0A0A),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    final int totalCount = _allEvents.length;
    
    // Slider 1: Featured (Gets first 2 items)
    final int featuredCount = totalCount < 2 ? totalCount : 2;
    final List<EventModel> featuredList = _allEvents.sublist(0, featuredCount);

    // Slider 2: Discover (Starts at 2, takes exactly up to 4 items)
    final int slider2Start = featuredCount;
    final int slider2End = (slider2Start + 4) < totalCount ? (slider2Start + 4) : totalCount;
    final List<EventModel> discoverList = _allEvents.sublist(slider2Start, slider2End);

    // Event Tab: Remaining (Everything left over after index 6)
    final List<EventModel> remainingList = _allEvents.sublist(slider2End);

    switch (index) {
      case 0:
        return HomeScreenBody(
          featuredEvents: featuredList,
          upcomingEvents: discoverList,
          savedEventIds: _savedEventIds,
          registeredEventIds: _registeredEventIds,
          onSaveToggle: _toggleSaveEvent,
          onRegisterToggle: _toggleRegisterEvent,
          notificationsEnabled: _notificationsEnabled,
          onNotificationToggle: _toggleNotifications,
        );
      case 1:
        return AllEventsTab(
          events: remainingList, // Shows items 7, 8, etc., from your file
          savedEventIds: _savedEventIds,
          registeredEventIds: _registeredEventIds,
          onSaveToggle: _toggleSaveEvent,
          onRegisterToggle: _toggleRegisterEvent,
          showSearchBar: true, // Show search bar in this tab
          appBarTitle: 'Events',
        );
      case 2:
        // Filter out all events from your JSON array whose ID matches our saved Set
        final List<EventModel> savedEventsList = _allEvents
            .where((event) => _savedEventIds.contains(event.id))
            .toList();

        return AllEventsTab(
          events: savedEventsList, // Reuses your scrollable tab view layout
          savedEventIds: _savedEventIds,
          registeredEventIds: _registeredEventIds,
          onSaveToggle: _toggleSaveEvent,
          onRegisterToggle: _toggleRegisterEvent,
          showSearchBar: false,
          appBarTitle: 'Saved Events',
        );
      case 3:
        return ProfileScreenBody(
          allEvents: _allEvents,
          savedEventIds: _savedEventIds,
          registeredEventIds: _registeredEventIds,
          onTabChange: (index){
            setState(() {
              _currentIndex = index;
            });
          },
          onSaveToggle: _toggleSaveEvent,
          onRegisterToggle: _toggleRegisterEvent,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _toggleSaveEvent(String eventId) {
    setState(() {
      if (_savedEventIds.contains(eventId)) {
        _savedEventIds.remove(eventId);
      } else {
        _savedEventIds.add(eventId);
      }
    });
  }

  void _toggleRegisterEvent(String eventId) {
    setState(() {
      if (_registeredEventIds.contains(eventId)) {
        _registeredEventIds.remove(eventId);
      } else {
        _registeredEventIds.add(eventId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: IndexedStack(
        index: _currentIndex,
        children: List.generate(4, (i) => _bodyForIndex(i)),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF131316),
          border: Border(top: BorderSide(color: Color(0xFF202024), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: const Color(0xFF5A5A65),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled, size: 20), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.event_outlined, size: 20), label: 'Event'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline_rounded, size: 20), label: 'Saved'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded, size: 20), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class AllEventsTab extends StatefulWidget {
  final List<EventModel> events;
  final Set<String> savedEventIds;
  final Set<String> registeredEventIds;
  final Function(String) onSaveToggle;
  final Function(String) onRegisterToggle;
  final bool showSearchBar; // <-- New configuration
  final String appBarTitle; // <-- Custom title handling

  const AllEventsTab({
    super.key,
    required this.events,
    required this.savedEventIds,
    required this.registeredEventIds,
    required this.onSaveToggle,
    required this.onRegisterToggle,
    this.showSearchBar = true,
    required this.appBarTitle,
  });

  @override
  State<AllEventsTab> createState() => _AllEventsTabState();
}

class _AllEventsTabState extends State<AllEventsTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Only apply text filtering if the search bar is actually enabled/visible
    final filteredEvents = widget.events.where((event) {
      if (!widget.showSearchBar) return true;
      
      final query = _searchQuery.toLowerCase();
      final titleMatch = event.title.toLowerCase().contains(query);
      final descriptionMatch = event.description.toLowerCase().contains(query);
      return titleMatch || descriptionMatch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: Text(
          widget.appBarTitle, 
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22)
        ),
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        automaticallyImplyLeading: false,
        // Only render the search bar bottom area if showSearchBar is true
        bottom: widget.showSearchBar
            ? PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: 'Search events...',
                      hintStyle: const TextStyle(color: Color(0xFF5A5A65)),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF5A5A65)),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Color(0xFF5A5A65)),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = "";
                                });
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: const Color(0xFF131316),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF202024)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF202024)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white24),
                      ),
                    ),
                  ),
                ),
              )
            : null, // Removes bottom panel completely if false
      ),
      body: filteredEvents.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.showSearchBar ? Icons.search_off_rounded : Icons.bookmark_outline_rounded, 
                    size: 52, 
                    color: const Color(0xFF3A3A3F)
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.showSearchBar 
                        ? (_searchQuery.isEmpty ? 'No Events Available' : 'No Match Found')
                        : 'No Saved Events',
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.showSearchBar 
                        ? (_searchQuery.isEmpty ? 'Check back later for new updates.' : 'Try searching for something else.')
                        : 'Events you bookmark will appear here.',
                    style: const TextStyle(color: Color(0xFF5A5A65), fontSize: 14),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                final event = filteredEvents[index];
                final isSaved = widget.savedEventIds.contains(event.id);
                final isRegistered = widget.registeredEventIds.contains(event.id);

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
                            isSaved: isSaved,
                            isRegistered: isRegistered,
                            onSaveToggle: () => widget.onSaveToggle(event.id),
                            onRegisterToggle: () => widget.onRegisterToggle(event.id),
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
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(event.date, style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 13)),
                              ],
                            ),
                          ),
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



// ignore: unused_element
class _PlaceholderTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;

  const _PlaceholderTab({
    required this.icon,
    required this.label,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 52, color: const Color(0xFF3A3A3F)),
            const SizedBox(height: 16),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF5A5A65), fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}