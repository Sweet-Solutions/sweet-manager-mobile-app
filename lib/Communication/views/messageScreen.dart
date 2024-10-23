import 'package:flutter/material.dart';
import '../../Shared/widgets/base_layout.dart';
import '../components/messageTile.dart';
import '../models/notification.dart';
import '../components/notificationCard.dart';

@override
Widget build(BuildContext context) {
  return BaseLayout(role: '', childScreen: Messagescreen());
}

class Messagescreen extends StatefulWidget {
  @override
  _MessagescreenState createState() => _MessagescreenState();
}

class _MessagescreenState extends State<Messagescreen> {
  final List<Notifications> _messages = [
    Notifications(1, 1, 1, 1, 'Meeting Today', 'S.T.'),
    Notifications(1, 1, 1, 1, 'Dismissal', 'H.K.'),
    Notifications(1, 1, 1, 1, 'Settlement', 'Reception'),
    Notifications(1, 1, 1, 1, 'New Policy', 'HR')
  ];

  List<Notifications> _filteredMessages = [];
  String _searchQuery = '';
  Set<int> _selectedMessageIndices = {};

  @override
  void initState() {
    super.initState();
    _filteredMessages = _messages;
  }

  void _filterMessages(String query) {
    final filtered = _messages.where((notification) {
      return notification.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredMessages = filtered;
      _searchQuery = query;
    });
  }

  void _deleteSelectedMessages() {
    setState(() {
      _filteredMessages.removeWhere((notification) =>
          _selectedMessageIndices.contains(_filteredMessages.indexOf(notification)));
      _selectedMessageIndices.clear();
    });
  }

  void _selectMessage(int index) {
    setState(() {
      if (_selectedMessageIndices.contains(index)) {
        _selectedMessageIndices.remove(index);
      } else {
        _selectedMessageIndices.add(index);
      }
    });
  }

  void _selectAllMessages() {
    setState(() {
      if (_selectedMessageIndices.length == _filteredMessages.length) {
        _selectedMessageIndices.clear();
      } else {
        _selectedMessageIndices = Set<int>.from(Iterable<int>.generate(_filteredMessages.length));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Message Registry',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: _filterMessages,
              decoration: InputDecoration(
                hintText: 'Search message',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                ),
                filled: true,
                fillColor: Color(0xFF4A4E69),
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredMessages.length,
                itemBuilder: (context, index) {
                  final notification = _filteredMessages[index];
                  return Dismissible(
                    key: Key(notification.title),
                    onDismissed: (direction) {
                      setState(() {
                        _filteredMessages.removeAt(index);
                        _selectedMessageIndices.remove(index);
                      });
                    },
                    background: Container(color: Colors.red),
                    child: MessageTile(
                      notification.title,
                      notification.description,
                      notification.typesNotificationsId.toString(),
                      isSelected: _selectedMessageIndices.contains(index),
                      onSelect: () => _selectMessage(index),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Add functionality to create a new message
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C5282),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Create message',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: _selectedMessageIndices.isNotEmpty
                      ? _deleteSelectedMessages
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Delete selected',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}