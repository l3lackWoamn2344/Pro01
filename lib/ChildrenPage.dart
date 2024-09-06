import 'package:customchart/Services/notificat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'Add_Edit_DeleteChilde.dart';
import 'ChildDetailsPage.dart';
import 'Services/Database_Helper.dart';

class ChildrenPage extends StatefulWidget {
  const ChildrenPage({super.key});

  @override
  _ChildrenPageState createState() => _ChildrenPageState();
}

class _ChildrenPageState extends State<ChildrenPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _children = [];

  @override
  void initState() {
    super.initState();
    _fetchChildren();
  }

  Future<void> _fetchChildren() async {
    final children = await _dbHelper.getAllChildren();
    setState(() {
      _children = children;
    });
  }

  void _deleteChild(int id) async {
    final child = _children.firstWhere((child) => child['id'] == id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChildDetailsPage(
          child: child,
          showDeleteButton: true,
        ),
      ),
    ).then((_) {
      _fetchChildren(); // Refresh the list after returning from the details page
    });
  }

  void _editChild(Map<String, dynamic> child) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChildDetailsPage(
          child: child,
          showEditButton: true,
        ),
      ),
    ).then((_) {
      _fetchChildren();
    });
  }

  void _viewChildDetails(Map<String, dynamic> child) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChildDetailsPage(child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ข้อมูลเด็ก'),
        backgroundColor: Colors.greenAccent,  // Green AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Back arrow
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // TextButton with an icon to add new child information
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddChildrenPage()),
                ).then((_) {
                  _fetchChildren();
                });
              },
              icon: const Icon(Icons.add, color: Colors.black), // Icon added here
              label: const Text(
                'เพิ่มข้อมูลเด็ก',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Black text color
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _children.length,
                itemBuilder: (context, index) {
                  final child = _children[index];
                  return Slidable(
                    key: ValueKey(child['id']),
                    direction: Axis.horizontal,
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) => _editChild(child),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                        SlidableAction(
                          onPressed: (context) => _deleteChild(child['id']),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 4.0,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Text(
                          'ชื่อ: ${child['firstName']} นามสกุล: ${child['lastName']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8.0),
                            Text('ชื่อเล่น: ${child['nickname']}'),
                            Text('หมู่เลือด: ${child['bloodType']} เพศ: ${child['gender']}'),
                          ],
                        ),
                        onTap: () => _viewChildDetails(child), // Navigate to details page
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
