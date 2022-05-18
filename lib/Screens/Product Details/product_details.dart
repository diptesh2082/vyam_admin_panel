import 'dart:io';

import 'package:admin_panel_vyam/services/maps_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/MatchIDMethod.dart';
import '../../services/deleteMethod.dart';
import 'Packages/Extra_package.dart';
import 'Packages/packages.dart';
import 'Trainers/Trainers.dart';
import 'package:admin_panel_vyam/services/CustomTextFieldClass.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final id = FirebaseFirestore.instance
      .collection('product_details')
      .doc()
      .id
      .toString();
  CollectionReference? productStream;

  @override
  void initState() {
    productStream = FirebaseFirestore.instance.collection("product_details");
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
                    stream: productStream!.snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data == null) {
                        return Container();
                      }
                      print("-----------------------------------");

                      print(snapshot.data.docs);
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                            // ? DATATABLE
                            dataRowHeight: 65,
                            columns: const [
                              DataColumn(
                                  label: Text(
                                'Name',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                label: Text(
                                  'Address',
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
                                  'Gender',
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
                                  'Landmark',
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
                                  'Trainers',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ), //! For trainer
                              DataColumn(
                                label: Text(
                                  'Packages',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ), //!For Package
                              DataColumn(
                                label: Text(
                                  'Extra Packages',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Gym_status',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Validity of User',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Upload Image',
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

// Upload Images
  Future<List<XFile>> multiimagepicker() async {
    List<XFile>? _images = await ImagePicker().pickMultiImage();
    if (_images != null && _images.isNotEmpty) {
      return _images;
    }
    return [];
  }

  Future<String> uploadimage(XFile image) async {
    Reference db = FirebaseStorage.instance
        .ref("TransformerGymImage/${getImageName(image)}");
    await db.putFile(File(image.path));
    print("image uploaded1");
    return await db.getDownloadURL();
  }

  String getImageName(XFile image) {
    return image.path.split("/").last;
  }

  Future<List<String>> multiimageuploader(List<XFile> list) async {
    List<String> _path = [];
    for (XFile _image in list) {
      _path.add(await uploadimage(_image));
    }
    return _path;
  }

  List<DataRow> _buildlist(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return snapshot.map((data) => _buildListItem(context, data)).toList();
  }

  DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
    String gymId = data['gym_id'];
    GeoPoint loc = data['location'];
    bool legit = data['legit'];
    bool status = data["gym_status"];
    String loctext = "${loc.latitude},${loc.longitude}";
    return DataRow(cells: [
      DataCell(data != null ? Text(data['name'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['address'] ?? "") : Text("")),
      DataCell(data != null ? Text(gymId) : Text("")),
      DataCell(data != null ? Text(data['gym_owner'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['gender'] ?? "") : Text("")),
      DataCell(data != null
          ? GestureDetector(
              onTap: () async {
                await MapsLaucherApi().launchMaps(loc.latitude, loc.longitude);
              },
              child: Text(loctext))
          : Text("")),
      DataCell(data != null ? Text(data['landmark'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['pincode'] ?? "") : Text("")),
      DataCell(const Text('Trainer'), onTap: (() {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TrainerPage(tGymId: gymId),
        ));
      })),
      DataCell(const Text('Package '), onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PackagesPage(
            pGymId: gymId,
          ),
        ));
      }),
      DataCell(const Text('Extra Package '), onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ExtraPackagesPage(
            pGymId: gymId,
          ),
        ));
      }),
      DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () async {
              bool temp = status;
              temp = !temp;
              DocumentReference documentReference = FirebaseFirestore.instance
                  .collection('product_details')
                  .doc(gymId);
              await documentReference
                  .update({'gym_status': temp})
                  .whenComplete(() => print("Legitimate toggled"))
                  .catchError((e) => print(e));
            },
            child: Text(status.toString()),
            style: ElevatedButton.styleFrom(
                primary: status ? Colors.green : Colors.red),
          ),
        ),
      ),
      DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () async {
              bool temp = legit;
              temp = !temp;
              DocumentReference documentReference = FirebaseFirestore.instance
                  .collection('product_details')
                  .doc(gymId);
              await documentReference
                  .update({'legit': temp})
                  .whenComplete(() => print("Legitimate toggled"))
                  .catchError((e) => print(e));
            },
            child: Text(legit.toString()),
            style: ElevatedButton.styleFrom(
                primary: legit ? Colors.green : Colors.red),
          ),
        ),
      ),

// Image Upload data Cell
      DataCell(Row(children: [
        const Spacer(),
        GestureDetector(
          onTap: () async {
            List<XFile>? _images = await multiimagepicker();
            //  multiimages = await multiimagepicker();
            if (_images.isNotEmpty) {
              await multiimageuploader(_images);
              setState(() {});
            }
          },
          child: const Center(
            child: Icon(
              Icons.file_upload_outlined,
              size: 20,
            ),
          ),
        )
      ])),

      DataCell(
        const Text(""),
        showEditIcon: true,
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return GestureDetector(
                onTap: () => Navigator.pop(context),
                child: SingleChildScrollView(
                  child: ProductEditBox(
                    address: data['address'],
                    gender: data['gender'],
                    name: data['name'],
                    pincode: data['pincode'],
                    gymId: data['gym_id'],
                    gymOwner: data['gym_owner'],
                    landmark: data['landmark'],
                    location: data['location'],
                  ),
                ),
              );
            },
          );
        },
      ),
      DataCell(Icon(Icons.delete), onTap: () {
        deleteMethod(stream: productStream, uniqueDocId: gymId);
      })
    ]);
  }

  final TextEditingController _addaddress = TextEditingController();
  final TextEditingController _addgender = TextEditingController();
  final TextEditingController _addname = TextEditingController();
  final TextEditingController _addpincode = TextEditingController();
  final TextEditingController _addlandmark = TextEditingController();
  final TextEditingController _addgymowner = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
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
                    customTextField(hinttext: "Name", addcontroller: _addname),
                    customTextField(
                        hinttext: "Address", addcontroller: _addaddress),
                    customTextField(
                        hinttext: "Gym Owner", addcontroller: _addgymowner),
                    customTextField(
                        hinttext: "Gender", addcontroller: _addgender),
                    customTextField(
                        hinttext: 'Latitude',
                        addcontroller: _latitudeController),
                    customTextField(
                        hinttext: 'Longitude',
                        addcontroller: _longitudeController),
                    customTextField(
                        hinttext: "Landmark", addcontroller: _addlandmark),
                    customTextField(
                      addcontroller: _addpincode,
                      hinttext: "Pincode",
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          GeoPoint dataForGeoPint = GeoPoint(
                              double.parse(_latitudeController.text),
                              double.parse(_longitudeController.text));

                          await matchID(
                              newId: id,
                              matchStream: productStream,
                              idField: 'gym_id');
                          FirebaseFirestore.instance
                              .collection('product_details')
                              .doc(id)
                              .set(
                            {
                              'address': _addaddress.text,
                              'gender': _addgender.text,
                              'name': _addname.text,
                              'pincode': _addpincode.text,
                              'location': dataForGeoPint,
                              'gym_id': id,
                              'gym_owner': _addgymowner.text,
                              'landmark': _addlandmark.text,
                              'total_booking': " ",
                              'total_sales': " ",
                              'legit': true
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
          ));
}

// *Updating Item list Class

class ProductEditBox extends StatefulWidget {
  const ProductEditBox({
    Key? key,
    required this.address,
    required this.name,
    required this.gymId,
    required this.gymOwner,
    required this.gender,
    required this.location,
    required this.landmark,
    required this.pincode,
  }) : super(key: key);

  final String name;
  final String address;
  final String gymId;
  final String gymOwner;
  final String gender;
  final GeoPoint location;
  final String landmark;
  final String pincode;

  @override
  _ProductEditBoxState createState() => _ProductEditBoxState();
}

class _ProductEditBoxState extends State<ProductEditBox> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _gymiid = TextEditingController();
  final TextEditingController _gymowner = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _landmark = TextEditingController();
  final TextEditingController _pincode = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print(widget.address);
    _address.text = widget.address;
    _gender.text = widget.gender;
    _name.text = widget.name;
    _pincode.text = widget.pincode;
    _gymiid.text = widget.gymId;
    _gymowner.text = widget.gymOwner;
    _landmark.text = widget.landmark;
    _location.text = "${widget.location.latitude}, ${widget.location.latitude}";
    _latitudeController.text = widget.location.latitude.toString();
    _longitudeController.text = widget.location.longitude.toString();
    print(widget.location.latitude);
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
              customTextField(hinttext: "Address", addcontroller: _address),
              customTextField(hinttext: "Gym ID", addcontroller: _gymiid),
              customTextField(hinttext: "Gym Owner", addcontroller: _gymowner),
              customTextField(hinttext: "Gender", addcontroller: _gender),
              customTextField(
                  hinttext: 'Latitude', addcontroller: _latitudeController),
              customTextField(
                  hinttext: 'Longitude', addcontroller: _longitudeController),
              customTextField(hinttext: "Landmark", addcontroller: _landmark),
              customTextField(hinttext: "Pincode", addcontroller: _pincode),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      print("The Gym id is : ${_gymiid.text}");
                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection('product_details')
                          .doc(_gymiid.text);

                      GeoPoint dataForGeoPint = GeoPoint(
                          double.parse(_latitudeController.text),
                          double.parse(_longitudeController.text));

                      Map<String, dynamic> data = <String, dynamic>{
                        'address': _address.text,
                        'gender': _gender.text,
                        'name': _name.text,
                        'pincode': _pincode.text,
                        'location': dataForGeoPint,
                        'gym_id': _gymiid.text,
                        'gym_owner': _gymowner.text,
                        'landmark': _landmark.text
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
