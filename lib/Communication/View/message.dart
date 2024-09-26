import 'package:flutter/material.dart';

void main() {
  runApp(MensajesApp());
}

class MensajesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MensajesScreen(),
    );
  }
}

class Message {
  final String title;
  final String recipient;
  final String date;

  Message(this.title, this.recipient, this.date);
}

class MessageTile extends StatelessWidget {
  final String title;
  final String recipient;
  final String date;
  final bool isSelected;
  final VoidCallback onSelect;

  MessageTile(this.title, this.recipient, this.date, {required this.isSelected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                Text('sent to $recipient'),
              ],
            ),
            Text(date),
          ],
        ),
      ),
    );
  }
}

class MensajesScreen extends StatefulWidget {
  @override
  _MensajesScreenState createState() => _MensajesScreenState();
}

class _MensajesScreenState extends State<MensajesScreen> {
  final List<Message> _messages = [
    Message('Meeting Today', 'S.T.', '2/02/2019'),
    Message('Dismissal', 'H.K.', '4/02/2019'),
    Message('Settlement', 'Reception', '5/02/2019'),
    Message('New Policy', 'HR', '6/02/2019')
  ];

  List<Message> _filteredMessages = [];
  String _searchQuery = '';
  Set<int> _selectedMessageIndices = {};

  @override
  void initState() {
    super.initState();
    _filteredMessages = _messages;
  }

  void _filterMessages(String query) {
    final filtered = _messages.where((message) {
      return message.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredMessages = filtered;
      _searchQuery = query;
    });
  }

  void _deleteSelectedMessages() {
    setState(() {
      _filteredMessages.removeWhere((message) => _selectedMessageIndices.contains(_filteredMessages.indexOf(message)));
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Message Registry'.toUpperCase(),
          style: TextStyle(
            color: Color(0xFF183952),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.select_all),
            onPressed: _selectAllMessages,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Messages',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
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
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredMessages.length,
                itemBuilder: (context, index) {
                  final message = _filteredMessages[index];
                  return Dismissible(
                    key: Key(message.title),
                    onDismissed: (direction) {
                      setState(() {
                        _filteredMessages.removeAt(index);
                        _selectedMessageIndices.remove(index);
                      });
                    },
                    background: Container(color: Colors.red),
                    child: MessageTile(
                      message.title,
                      message.recipient,
                      message.date,
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
                    backgroundColor: Color(0xFF2C5282),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
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
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
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
