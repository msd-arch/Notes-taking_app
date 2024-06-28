import 'package:flutter/material.dart';

// Note Model
class Note {
  final String title;
  final String content;
  final String category;

  Note({
    required this.title,
    required this.content,
    required this.category,
  });
}

// Home Screen
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Note> _notes = [];
  String _selectedCategory = 'All';

  void _addNote(Note note) {
    setState(() {
      _notes.add(note);
    });
  }

  void _deleteNote(Note note) {
    setState(() {
      _notes.remove(note);
    });
  }

  List<Note> get _filteredNotes {
    if (_selectedCategory == 'All') {
      return _notes;
    } else {
      return _notes.where((note) => note.category == _selectedCategory).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: Column(
        children: <Widget>[
          CategoryFilter(
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),
          Expanded(child: NoteList(notes: _filteredNotes, onDelete: _deleteNote)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Note? newNote = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteScreen()),
          );
          if (newNote != null) {
            _addNote(newNote);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// Note Screen
class NoteScreen extends StatefulWidget {
  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _selectedCategory = 'Work';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: null,
            ),
            DropdownButton<String>(
              value: _selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
              items: <String>['Work', 'Personal']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final String title = _titleController.text;
                final String content = _contentController.text;

                if (title.isNotEmpty && content.isNotEmpty) {
                  final newNote = Note(
                    title: title,
                    content: content,
                    category: _selectedCategory,
                  );
                  Navigator.pop(context, newNote);
                }
              },
              child: Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}

// Note List Widget
class NoteList extends StatelessWidget {
  final List<Note> notes;
  final void Function(Note) onDelete;

  NoteList({required this.notes, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(notes[index].title),
          subtitle: Text(notes[index].content),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => onDelete(notes[index]),
          ),
        );
      },
    );
  }
}

// Category Filter Widget
class CategoryFilter extends StatelessWidget {
  final String selectedCategory;
  final void Function(String) onCategorySelected;

  CategoryFilter({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildCategoryButton('All'),
          _buildCategoryButton('Work'),
          _buildCategoryButton('Personal'),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    return ElevatedButton(
      onPressed: () => onCategorySelected(category),
      child: Text(category),
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedCategory == category ? Colors.blue : Colors.grey,
      ),
    );
  }
}

// Main Function
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note Taking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
