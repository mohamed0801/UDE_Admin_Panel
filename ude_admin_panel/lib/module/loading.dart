// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

Chargement(BuildContext context) async {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => const Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ));
}
