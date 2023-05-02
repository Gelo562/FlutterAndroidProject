import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projekt2/add_new_phone.dart';
import 'package:projekt2/phone_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListOfPhonesPage extends StatefulWidget {
  const ListOfPhonesPage({super.key});

  @override
  State<ListOfPhonesPage> createState() => _ListOfPhonesPageState();
}

class _ListOfPhonesPageState extends State<ListOfPhonesPage> {
  bool loaded = false;
  List<PhoneModel> phoneList = [];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  int maxID() {
    int maxid = 0;
    for (int i = phoneList.length - 1; i >= 0; i--) {
      if (phoneList[i].id > maxid) {
        maxid = phoneList[i].id;
      }
    }
    return maxid + 1;
  }

  void insertPhone(PhoneModel newPhone, int index) async {
    final SharedPreferences prefs = await _prefs;
    final dataFromFile = prefs.getStringList('SavedPhonesAtJson') ?? <String>[];
    final temporatyPhoneList =
        dataFromFile.map((e) => PhoneModel.fromJson(jsonDecode(e))).toList();

    if (index == -1) {
      newPhone.id = maxID();
      temporatyPhoneList.add(newPhone);
    } else {
      temporatyPhoneList[index] = newPhone;
    }
    final listString =
        temporatyPhoneList.map((e) => jsonEncode(e.toJson())).toList();
    prefs.setStringList('SavedPhonesAtJson', listString);
    setState(() {
      phoneList = temporatyPhoneList;
    });
  }

  void removeOnePhone(int index) async {
    final SharedPreferences prefs = await _prefs;
    final dataFromFile = prefs.getStringList('SavedPhonesAtJson') ?? <String>[];
    final temporatyPhoneList =
        dataFromFile.map((e) => PhoneModel.fromJson(jsonDecode(e))).toList();
    temporatyPhoneList.removeAt(index);
    final listString =
        temporatyPhoneList.map((e) => jsonEncode(e.toJson())).toList();
    prefs.setStringList('SavedPhonesAtJson', listString);
    setState(() {
      phoneList = temporatyPhoneList;
    });
  }

  void initPhones() async {
    final SharedPreferences prefs = await _prefs;
    final dataFromFile = prefs.getStringList('SavedPhonesAtJson') ?? <String>[];
    final temporatyPhoneList =
        dataFromFile.map((e) => PhoneModel.fromJson(jsonDecode(e))).toList();
    if (temporatyPhoneList.isEmpty) {
      temporatyPhoneList
          .add(PhoneModel(0, 'Google', 'Pixel 4', '30', 'https://google.com'));
      temporatyPhoneList.add(
          PhoneModel(1, 'Google', 'Pixel 5', '30', 'https://facebook.com'));
      temporatyPhoneList
          .add(PhoneModel(2, 'Apple', 'Iphone X', '10', 'https://gmail.com'));
    } //Adding some example data to test app
    final listString =
        temporatyPhoneList.map((e) => jsonEncode(e.toJson())).toList();
    prefs.setStringList('SavedPhonesAtJson', listString);
    setState(() {
      loaded = true;
      phoneList = temporatyPhoneList;
    });
  }

  void clearData() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setStringList('SavedPhonesAtJson', <String>[]);
    setState(() {
      phoneList = <PhoneModel>[];
    });
  }

  Future<void> _navigateAndDisplaySelection(
      BuildContext context, PhoneModel oldPhone, int index) async {
    final newPhone = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNewPhone(
          newPhone: oldPhone,
        ),
      ),
    );
    if (newPhone != null &&
        newPhone.androidVerion != '' &&
        newPhone.model != '' &&
        newPhone.page != '' &&
        newPhone.manufacturer != '') {
      insertPhone(newPhone, index);
    }
  }

  final Future<String> delayToLoadData = Future<String>.delayed(
    const Duration(seconds: 2),
    () => 'Data Loaded',
  );

  @override
  Widget build(BuildContext context) {
    if (loaded == false) {
      initPhones();
    }
    return FutureBuilder<String>(
      future: delayToLoadData,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('PhoneDB'),
              actions: [
                PopupMenuButton(itemBuilder: (context) {
                  return [
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text("Clear all data"),
                    ),
                  ];
                }, onSelected: (value) {
                  if (value == 0) {
                    clearData();
                  }
                }),
              ],
            ),
            body: ListView.builder(
              itemCount: phoneList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) => Dismissible(
                key: ValueKey(phoneList[index]),
                onDismissed: (DismissDirection direction) {
                  setState(() {
                    removeOnePhone(index);
                    phoneList.removeAt(index);
                  });
                },
                child: InkWell(
                  onTap: () {
                    _navigateAndDisplaySelection(
                        context, phoneList[index], index);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        phoneList[index].manufacturer,
                      ),
                      Text(
                        phoneList[index].model,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _navigateAndDisplaySelection(
                    context, PhoneModel(0, '', '', '', ''), -1);
              },
              child: const Icon(Icons.add),
            ),
          );
        }
        return const Center(
          child: Text(''),
        );
      },
    );
  }
}
