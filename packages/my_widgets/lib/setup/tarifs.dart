import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class GetTarifs extends StatefulWidget {
  const GetTarifs({super.key});

  @override
  State<GetTarifs> createState() => GetTarifsState();
}

final _formKey = GlobalKey<FormBuilderState>();

class GetTarifsState extends State<GetTarifs> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 250,
      child: FormBuilder(
        key: _formKey,
        child: FormBuilderTextField(
          name: 'text',
          autovalidateMode: AutovalidateMode.always,
          onChanged: (val) {
            if (kDebugMode) {
              print(val);
            } // Print the text value write into TextField
          },
        ),
      ),
    );
  }
}
