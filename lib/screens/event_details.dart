import 'package:flutter/material.dart';
import 'home_screen.dart'; // Explicit reference to see EventModel structure
import 'feedback_screen.dart';

class EventDetailScreen extends StatefulWidget {
  final EventModel event;
  final bool isSaved;
  final bool isRegistered;
  final VoidCallback onSaveToggle;
  final VoidCallback onRegisterToggle;


  const EventDetailScreen({
    super.key,
    required this.event,
    required this.isSaved,
    required this.isRegistered,
    required this.onSaveToggle,
    required this.onRegisterToggle,
    
  });


  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late bool _localIsSaved;
  late bool _isRegistered;
  
  @override
  void initState() {
    super.initState();
    _localIsSaved = widget.isSaved;
    _isRegistered = widget.isRegistered;
  }
   void _toggleRegistration() {
    setState(() {
      _isRegistered = !_isRegistered;
    });

    widget.onRegisterToggle();
  }
   
  @override
  Widget build(BuildContext context) {
    final int spotsLeft = widget.event.capacity - widget.event.registered;
    final bool isFull = spotsLeft <= 0;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F11),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Event Details',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.feedback_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(
            context,
              MaterialPageRoute(
            builder: (context) => const FeedbackScreen(), // <-- Change this to your exact Feedback widget class name
              ),
             );
            },
          ),
          IconButton(
            icon: Icon(
              _localIsSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _localIsSaved = !_localIsSaved;
              });
              widget.onSaveToggle(); // Propagates the saved state to MainShell
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 130),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF26262B)),
                    ),
                    child: Center(
                      child: Text(widget.event.imagePlaceholder, style: const TextStyle(fontSize: 56)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.event.title,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1E),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF26262B)),
                        ),
                        child: Text(
                          widget.event.badge,
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _InfoRow(icon: Icons.calendar_today_outlined, text: widget.event.date),
                  const SizedBox(height: 14),
                  _InfoRow(icon: Icons.location_on_outlined, text: widget.event.location),
                  const SizedBox(height: 14),
                  _InfoRow(icon: Icons.people_outline_rounded, text: '${widget.event.registered} registered • $spotsLeft spots left'),
                  
                  const SizedBox(height: 28),
                  const Text('ABOUT', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                  const SizedBox(height: 10),
                  Text(
                    widget.event.description,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF9696A0), height: 1.5),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(child: _StatCard(value: widget.event.badge, label: 'Entry')),
                      const SizedBox(width: 12),
                      Expanded(child: _StatCard(value: '${widget.event.capacity}', label: 'Capacity')),
                      const SizedBox(width: 12),
                      Expanded(child: _StatCard(value: isFull ? 'Full' : '$spotsLeft', label: 'Available')),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              decoration: const BoxDecoration(
                color: Color(0xFF0F0F11),
                border: Border(top: BorderSide(color: Color(0xFF1A1A1E), width: 1)),
              ),
              child: 
              // Locate your registration button block at the bottom of the column/sheet:
ElevatedButton(
  onPressed: () {
    
    _toggleRegistration();
    // 2. Show your notification toast
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          
          _isRegistered
                  ? 'Successfully registered for ${widget.event.title}'
                  : 'Cancelled registration for ${widget.event.title}!'

        ),
        duration: const Duration(seconds: 2),
      ),
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: _isRegistered ? const Color(0xFF2E7D32) : Colors.white,
    foregroundColor: _isRegistered ? Colors.white : Colors.black,
    minimumSize: const Size.fromHeight(54),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0,
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      if (widget.isRegistered) ...[
        const Icon(Icons.check_circle_outline, size: 18),
        const SizedBox(width: 8),
      ],
      Text(
        _isRegistered
            ? 'Registered'
            : 'Register for this event',
      ),
    ],
  ),
),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF9696A0)),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14, color: Color(0xFF9696A0)))),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF26262B)),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF5A5A65))),
        ],
      ),
    );
  }
}