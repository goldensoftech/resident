import 'package:flutter/material.dart';
import 'package:resident/app_export.dart';

class RRRSearchBillersScreen extends StatefulWidget {
  const RRRSearchBillersScreen({super.key});

  @override
  State<RRRSearchBillersScreen> createState() => _RRRSearchBillersScreenState();
}

class _RRRSearchBillersScreenState extends State<RRRSearchBillersScreen> {
  TextEditingController _textcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Stack(children: [
        Scaffold(
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
            children: [
              TextFormField(
                controller: _textcontroller,
                style: const TextStyle(height: 1),
                cursorOpacityAnimates: true,
                cursorWidth: 1,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    //labelStyle: const TextStyle(color: Colors.black54),
                    hintText: 'Search Biller',
                    filled: true,
                    fillColor: AppColors.lightGrey,
                    hintStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.schemeColor),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28.r),
                        borderSide: BorderSide.none),
                    suffixIcon: Icon(
                      Icons.search,
                      color: AppColors.schemeColor,
                      size: 18,
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (ctx, i) {
                  return Text("");
                },
              )
            ],
          ),
        )
      ]),
    );
  }
}
