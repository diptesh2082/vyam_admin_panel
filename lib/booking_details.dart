import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class BookingDetails extends StatefulWidget {
  const BookingDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  TextEditingController? _address;
  TextEditingController? _gender;
  TextEditingController? _gymid;
  TextEditingController? _addaddress;
  TextEditingController? _addgender;
  TextEditingController? _gymowner;
  TextEditingController? _landmark;
  TextEditingController? _location;
  TextEditingController? _gymname;
  TextEditingController? _pincode;

  @override
  void initState() {
    super.initState();
    _address = TextEditingController();
    _landmark = TextEditingController();
    _location = TextEditingController();
    _gymname = TextEditingController();
    _pincode = TextEditingController();
    _gender = TextEditingController();
    _gymid = TextEditingController();
    _addaddress = TextEditingController();
    _addgender = TextEditingController();
    _gymowner = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
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
                      width: 90,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Row(
                        children: const [
                          Icon(Icons.add),
                          Text('Add User',
                              style: TextStyle(fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collectionGroup("user_booking")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                            dataRowHeight: 65,
                            columns: const [
                              DataColumn(
                                  label: Text(
                                'Address',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                label: Text(
                                  'Gender',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Gym ID',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Gym Owner',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Landmark',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Location',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Gym Name',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Pincode',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Timing',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Timing',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Timing',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Timing',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Timing',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(label: Text(''))
                            ],
                            rows: _buildlist(context, snapshot.data!.docs)),
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
    return DataRow(cells: [
      DataCell(Text(data['address'])),
      DataCell(Text(data['gender'])),
      DataCell(Text(data['gym_id'])),
      DataCell(Text(data['gym_owner'])),
      DataCell(Text(data['landmark'])),
      DataCell(Text(data['location'].toString())),
      DataCell(Text(data['name'])),
      DataCell(Text(data['pincode'].toString())),
      DataCell(Text(data['pincode'].toString())),
      DataCell(Text(data['pincode'].toString())),
      DataCell(Text(data['pincode'].toString())),
      DataCell(Text(data['pincode'].toString())),
      DataCell(Text(data['pincode'].toString())),
      DataCell(const Text(""), showEditIcon: true, onTap: () {
        showEditbox(
          address: data['address']!,
          gender: data['gender'],
          gymID: data['gym_id'],
          gymOwner: data['gym_owner'],
          landmark: data['landmark'],
          location: data['location'],
          name: data['name'],
          pincode: data['pincode'],
        );
      }),
    ]);
  }

  showAddbox() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            content: SizedBox(
              height: 200,
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
                  SizedBox(
                    height: 50,
                    child: Card(
                        child: TextField(
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      controller: _addaddress,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          hintMaxLines: 2,
                          hintText: 'Address'),
                    )),
                  ),
                  SizedBox(
                    height: 50,
                    child: Card(
                        child: TextField(
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      controller: _addgender,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          hintMaxLines: 2,
                          hintText: 'Gender'),
                    )),
                  ),
                  const Center(
                    child: ElevatedButton(
                      onPressed: null,
                      /*() async {

                            Map<String, dynamic> data1 = <String, dynamic>{
                              'address': add_address.text,
                              'gender': add_gender.text,
                              // 'gym_id': gymid
                            };
                            await FirebaseFirestore.instance
                                .collection('product_details')
                                .add(data1).whenComplete(() => print("Item Updated"))
                                .catchError((e) => print(e));



                            Navigator.pop(context);

                            /*FirebaseFirestore.instance
                                .collection('product_details')
                                .doc('RBRQKBuboUVvDAriCCVe')
                                .update(
                              {'address': address},
                            );*/
                          },*/
                      child: Text('Done'),
                    ),
                  )
                ],
              ),
            ),
          ));

  showEditbox({
    required String? address,
    required String? gender,
    required String? gymID,
    required String? gymOwner,
    required String? landmark,
    required GeoPoint? location,
    required String? name,
    required String? pincode,
  }) =>
      showDialog(
        context: context,
        builder: (context) {
          print("Address of this user is : $address");
          _address!.text = address!;
          _gender!.text = gender!;
          _gymid!.text = gymID!;
          _gymowner!.text = gymOwner!;
          _landmark!.text = landmark!;
          location = GeoPoint(location!.latitude, location!.longitude);
          _location!.text = "${location!.latitude}. ${location!.longitude}";
          _pincode!.text = pincode!;
          _gymname!.text = name!;
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            content: SizedBox(
              height: 480,
              width: 800,
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
                  SizedBox(
                    height: 50,
                    child: Card(
                        child: TextField(
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      controller: _address,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          hintMaxLines: 2,
                          hintText: 'Address'),
                    )),
                  ),
                  SizedBox(
                    height: 50,
                    child: Card(
                        child: TextField(
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      controller: _gender,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          hintMaxLines: 2,
                          hintText: 'Gender'),
                    )),
                  ),
                  SizedBox(
                    height: 50,
                    child: Card(
                        child: TextField(
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      controller: _gymid,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          hintMaxLines: 2,
                          hintText: 'Gym ID'),
                    )),
                  ),
                  SizedBox(
                    height: 50,
                    child: Card(
                        child: TextField(
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      controller: _gymowner,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          hintMaxLines: 2,
                          hintText: 'Gym Owner'),
                    )),
                  ),
                  SizedBox(
                    height: 50,
                    child: Card(
                        child: TextField(
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      controller: _landmark,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          hintMaxLines: 2,
                          hintText: 'Landmark'),
                    )),
                  ),
                  SizedBox(
                    height: 50,
                    child: Card(
                        child: TextField(
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      controller: _location,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          hintMaxLines: 2,
                          hintText: 'Location'),
                    )),
                  ),
                  SizedBox(
                    height: 50,
                    child: Card(
                        child: TextField(
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      controller: _gymname,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          hintMaxLines: 2,
                          hintText: 'Gym Name'),
                    )),
                  ),
                  SizedBox(
                    height: 50,
                    child: Card(
                        child: TextField(
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      controller: _pincode,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          hintMaxLines: 2,
                          hintText: 'Pincode'),
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          print("/////");
                          print(_gymname!.text);
                          print(_gymid!.text);
                          DocumentReference documentReference =
                              FirebaseFirestore.instance
                                  .collection('product_details')
                                  .doc('RBRQKBuboUVvDAriCCVe');

                          Map<String, dynamic> data = <String, dynamic>{
                            'address': _address!.text,
                            'gender': _gender!.text,
                            'gym_id': _gymid!.text,
                            'gym_owner': _gymowner!.text,
                            'landmark': _landmark!.text,
                            'location': _location!.text,
                            'name': _gymname!.text,
                            'pincode': _pincode!.text,
                          };
                          await documentReference
                              .set(data)
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
          );
        },
      );
}
