import 'package:flutter/material.dart';
import 'package:projekt2/phone_model.dart';
import 'package:url_launcher/url_launcher.dart';

class AddNewPhone extends StatefulWidget {
  final PhoneModel newPhone;
  const AddNewPhone({super.key, required this.newPhone});

  @override
  State<AddNewPhone> createState() => _AddNewPhoneState();
}

class _AddNewPhoneState extends State<AddNewPhone> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Uri _url = Uri.parse('https://flutter.dev');
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PhoneDB'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  initialValue: widget.newPhone.manufacturer,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Manufacturer: ',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Cannot be empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      widget.newPhone.manufacturer = value;
                    });
                  }),
              TextFormField(
                  initialValue: widget.newPhone.model,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Phone model: ',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Cannot be empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      widget.newPhone.model = value;
                    });
                  }),
              TextFormField(
                  initialValue: widget.newPhone.androidVerion,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Android version: ',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Cannot be empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      widget.newPhone.androidVerion = value;
                    });
                  }),
              TextFormField(
                initialValue: widget.newPhone.page,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Web site: ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Cannot be empty';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  setState(() {
                    if (('https://').matchAsPrefix(value) == null &&
                        ('http://').matchAsPrefix(value) == null) {
                      value = 'https://$value';
                    }
                    widget.newPhone.page = value;
                  });
                },
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (widget.newPhone.page != '') {
                          _url = Uri.parse(widget.newPhone.page);
                        }
                      });
                      _launchUrl();
                    },
                    child: const Text('WEB SITE'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('CANCEL'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pop(context, widget.newPhone);
                      }
                    },
                    child: const Text('SAVE'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
