import 'package:flutter/material.dart';
import 'Add_Edit_DeleteChilde.dart';

class ChildDetailsPage extends StatefulWidget {
  final Map<String, dynamic> child;
  final bool showEditButton;
  final bool showDeleteButton;

  const ChildDetailsPage({
    required this.child,
    this.showEditButton = false,
    this.showDeleteButton = false,
    super.key,
  });

  @override
  _ChildDetailsPageState createState() => _ChildDetailsPageState();
}

class _ChildDetailsPageState extends State<ChildDetailsPage> {
  late Map<String, dynamic> childDetails;

  @override
  void initState() {
    super.initState();
    childDetails = widget.child;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายละเอียดของเด็ก'),
        backgroundColor: Colors.greenAccent,
        automaticallyImplyLeading: false, // This removes the back arrow
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display all the child details here
                Text(
                  'ชื่อ: ${childDetails['firstName']}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'นามสกุล: ${childDetails['lastName']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'ชื่อเล่น: ${childDetails['nickname']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'วันเกิด: ${childDetails['birthdate']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'หมู่เลือด: ${childDetails['bloodType']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'เพศ: ${childDetails['gender']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'ส่วนสูง: ${childDetails['height']} ซม.',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'น้ำหนัก: ${childDetails['weight']} กก.',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'การแพ้ยา: ${childDetails['allergies']}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'cancel',
                  onPressed: () {
                    Navigator.pop(context); // Navigate back to ChildrenPage
                  },
                  backgroundColor: Colors.grey,
                  child: const Icon(Icons.arrow_back),
                ),
                if (widget.showEditButton)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: FloatingActionButton(
                      heroTag: 'edit',
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditChildrenPage(child: childDetails),
                          ),
                        );

                        if (result != null && result == true) {
                          setState(() {
                            childDetails = result; // Update the child details
                          });
                        }
                      },
                      backgroundColor: Colors.blue,
                      child: const Icon(Icons.edit),
                    ),
                  ),
                if (widget.showDeleteButton)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: FloatingActionButton(
                      heroTag: 'delete',
                      onPressed: () {
                        _showDeleteConfirmationDialog(context);
                      },
                      backgroundColor: Colors.red,
                      child: const Icon(Icons.delete),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการลบ'),
          content: const Text('คุณต้องการลบข้อมูลเด็กคนนี้หรือไม่?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                // Implement the delete functionality here
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Go back to the previous page after deletion
              },
              child: const Text('ลบ'),
            ),
          ],
        );
      },
    );
  }
}
