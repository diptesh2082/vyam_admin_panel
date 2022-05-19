import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import '../services/CustomTextFieldClass.dart';
import '../services/MatchIDMethod.dart';

class Coupon extends StatefulWidget {
  const Coupon({
    Key? key,
  }) : super(key: key);

  @override
  State<Coupon> createState() => _CouponState();
}

class _CouponState extends State<Coupon> {
  final id =
      FirebaseFirestore.instance.collection('coupon').doc().id.toString();

  CollectionReference? couponStream;
  @override
  void initState() {
    couponStream = FirebaseFirestore.instance.collection("coupon");
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
                          Text('Add Coupon',
                              style: TextStyle(fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: couponStream!.snapshots(),
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
                            dataRowHeight: 65,
                            columns: const [
                              DataColumn(
                                  label: Text(
                                'Coupon ID',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                  label: Text(
                                'Code',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                label: Text(
                                  'Details',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Breif',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Tag',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Discount',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Title',
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

  List<DataRow> _buildlist(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return snapshot.map((data) => _buildListItem(context, data)).toList();
  }

  DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
    String couponIdData = data['coupon_id'];
    return DataRow(cells: [
      DataCell(data['coupon_id'] != null
          ? Text(data['coupon_id'] ?? "")
          : const Text("")),
      DataCell(
          data['code'] != null ? Text(data['code'] ?? "") : const Text("")),
      DataCell(
          data['detail'] != null ? Text(data['detail'] ?? "") : const Text("")),
      DataCell(data['brief'] != null
          ? SizedBox(width: 220.0, child: Text(data['brief'] ?? ""))
          : const Text("")),
      DataCell(data['tag'] != null ? Text(data['tag'] ?? "") : const Text("")),
      DataCell(data['discount'] != null
          ? Text(data['discount'] ?? "")
          : const Text("")),
      DataCell(
          data['title'] != null ? Text(data['title'] ?? "") : const Text("")),
      DataCell(const Text(""), showEditIcon: true, onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return GestureDetector(
                child: SingleChildScrollView(
                  child: ProductEditBox(
                    title: data['title'],
                    code: data['code'],
                    details: data['detail'],
                    brief: data['brief'],
                    tag: data['tag'],
                    discount: data['discount'],
                    couponId: data['coupon_id'],
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              );
            });
      }),
      DataCell(Icon(Icons.delete), onTap: () {
        deleteMethod(stream: couponStream, uniqueDocId: couponIdData);
      }),
    ]);
  }

  final TextEditingController _addCode = TextEditingController();
  final TextEditingController _adddetails = TextEditingController();
  final TextEditingController _addbrief = TextEditingController();
  final TextEditingController _addtag = TextEditingController();
  final TextEditingController _adddiscount = TextEditingController();
  final TextEditingController _addtitle = TextEditingController();

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
                    customTextField(hinttext: "Code", addcontroller: _addCode),
                    customTextField(
                        hinttext: "Details", addcontroller: _adddetails),
                    customTextField(
                        hinttext: "Brief", addcontroller: _addbrief),
                    customTextField(hinttext: "Tag", addcontroller: _addtag),
                    customTextField(
                        hinttext: "Discount", addcontroller: _adddiscount),
                    customTextField(
                        hinttext: "Title", addcontroller: _addtitle),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          await matchID(
                              newId: id,
                              matchStream: couponStream,
                              idField: 'coupon_id');
                          await FirebaseFirestore.instance
                              .collection('coupon')
                              .doc(id)
                              .set(
                            {
                              'code': _addCode.text,
                              'detail': _adddetails.text,
                              'brief': _addbrief.text,
                              'tag': _addtag.text,
                              'discount': _adddiscount.text,
                              'title': _addtitle.text,
                              'coupon_id': id,
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

class ProductEditBox extends StatefulWidget {
  const ProductEditBox(
      {Key? key,
      required this.details,
      required this.brief,
      required this.tag,
      required this.discount,
      required this.title,
      required this.code,
      required this.couponId})
      : super(key: key);

  final String details;
  final String brief;
  final String tag;
  final String discount;
  final String title;
  final String code;
  final String couponId;

  @override
  _ProductEditBoxState createState() => _ProductEditBoxState();
}

class _ProductEditBoxState extends State<ProductEditBox> {
  final TextEditingController _code = TextEditingController();
  final TextEditingController _detail = TextEditingController();
  final TextEditingController _brief = TextEditingController();
  final TextEditingController _tag = TextEditingController();
  final TextEditingController _discount = TextEditingController();
  final TextEditingController _title = TextEditingController();

  @override
  void initState() {
    super.initState();
    _code.text = widget.code;
    _detail.text = widget.details;
    _brief.text = widget.brief;
    _tag.text = widget.tag;
    _discount.text = widget.discount;
    _title.text = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      content: SizedBox(
        height: 300,
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
              customTextField(hinttext: "Code", addcontroller: _code),
              customTextField(hinttext: "Detail", addcontroller: _detail),
              customTextField(hinttext: "Brief", addcontroller: _brief),
              customTextField(hinttext: "Tag", addcontroller: _discount),
              customTextField(hinttext: "Discount", addcontroller: _discount),
              customTextField(hinttext: "Title", addcontroller: _title),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      print("/////");
                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection('coupon')
                          .doc(widget.couponId);
                      Map<String, dynamic> data = <String, dynamic>{
                        'code': _code.text,
                        'detail': _detail.text,
                        'brief': _brief.text,
                        'tag': _tag.text,
                        'discount': _discount.text,
                        'title': _title.text,
                        'coupon_id': widget.couponId,
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
      ),
    );
  }
}
