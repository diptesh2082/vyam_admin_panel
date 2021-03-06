import 'package:admin_panel_vyam/dashboard.dart';
import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/CustomTextFieldClass.dart';
import '../services/MatchIDMethod.dart';

class CategoryInfoScreen extends StatefulWidget {
  const CategoryInfoScreen({Key? key}) : super(key: key);

  @override
  State<CategoryInfoScreen> createState() => _CategoryInfoScreenState();
}

class _CategoryInfoScreenState extends State<CategoryInfoScreen> {
  CollectionReference? categoryStream;
  final catId =
      FirebaseFirestore.instance.collection('category').doc().id.toString();

  @override
  void initState() {
    categoryStream = FirebaseFirestore.instance.collection('category');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20.0)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                  child: GestureDetector(
                    onTap: showAddbox,
                    child: Container(
                      width: 120,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Row(
                        children: const [
                          Icon(Icons.add),
                          Text('Add Product',
                              style: TextStyle(fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: categoryStream!.snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data == null) {
                        return Container();
                      }

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          dataRowHeight: 65,
                          columns: const [
                            DataColumn(
                              label: Text(
                                'Name',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Images',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Status',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Position',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Edit',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Delete',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                          rows: _buildlist(context, snapshot.data!.docs),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DataRow> _buildlist(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return snapshot.map((data) => _buildListItem(context, data)).toList();
  }

  DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
    String categoryID = data['category_id'];
    return DataRow(cells: [
      DataCell(
        data['name'] != null ? Text(data['name'] ?? "") : const Text(""),
      ),
      DataCell(
        data['image'] != null
            ? Image.network(
                data['image'] ?? "",
                scale: 0.5,
                height: 150,
                width: 150,
              )
            : const Text(""),
      ),
      DataCell(
        data['status'] == 'true'
            ? const Text("Enabled")
            : const Text("Disabled"),
      ),
      DataCell(
        data['position'] != null ? Center(child: Text(data['position'].toString() )) : const Text(""),
      ),
      DataCell(
        const Text(''),
        showEditIcon: true,
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SingleChildScrollView(
                    child: ProductEditBox(
                      name: data['name'],
                      status: data['status'],
                      image: data['image'],
                      categoryId: data['category_id'],
                    ),
                  ),
                );
              });
        },
      ),
      DataCell(Icon(Icons.delete), onTap: () {
        deleteMethod(stream: categoryStream, uniqueDocId: categoryID);
      })
    ]);
  }

  final TextEditingController _addName = TextEditingController();
  final TextEditingController _addStatus = TextEditingController();
  final TextEditingController _addImage = TextEditingController();
  showAddbox() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
          content: SizedBox(
            height: 480,
            width: 800,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Records',
                    style: TextStyle(
                        fontFamily: 'poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  ),
                  customTextField(hinttext: "Name", addcontroller: _addName),
                  customTextField(
                      hinttext: "Status", addcontroller: _addStatus),
                  customTextField(hinttext: "Image", addcontroller: _addImage),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await matchID(
                            newId: catId,
                            matchStream: categoryStream,
                            idField: 'category_id');
                        FirebaseFirestore.instance
                            .collection('category')
                            .doc(catId)
                            .set(
                          {
                            'status': _addStatus.text,
                            'image': _addImage.text,
                            'name': _addName.text,
                            'category_id': catId,
                          },
                        );
                        Navigator.pop(context);
                      },
                      child: const Text('Done'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
}

// EDIT FEATURE
class ProductEditBox extends StatefulWidget {
  const ProductEditBox({
    Key? key,
    required this.name,
    required this.status,
    required this.image,
    required this.categoryId,
  }) : super(key: key);

  final String name;
  final String status;
  final String image;
  final String categoryId;

  @override
  _ProductEditBoxState createState() => _ProductEditBoxState();
}

class _ProductEditBoxState extends State<ProductEditBox> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _status = TextEditingController();
  final TextEditingController _image = TextEditingController();

  @override
  void initState() {
    super.initState();
    _status.text = widget.status;
    _image.text = widget.image;
    _name.text = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      content: SizedBox(
        height: 580,
        width: 800,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Update Records for this doc',
                style: TextStyle(
                    fontFamily: 'poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
              customTextField(hinttext: "Name", addcontroller: _name),
              customTextField(hinttext: "Status", addcontroller: _status),
              customTextField(hinttext: "Image", addcontroller: _image),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      print("The Gym id is : ${widget.categoryId}");
                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection('category')
                          .doc(widget.categoryId);
                      Map<String, dynamic> data = <String, dynamic>{
                        'status': _status.text,
                        'image': _image.text,
                        'name': _name.text,
                        'category_id': widget.categoryId,
                      };
                      await documentReference
                          .update(data)
                          .whenComplete(() => print("Item Updated"))
                          .catchError((e) => print(e));
                      Navigator.pop(context);
                    },
                    child: const Text('Done'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
