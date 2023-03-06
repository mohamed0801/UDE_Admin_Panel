// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:ude_admin_panel/module/estension.dart';
import 'package:ude_admin_panel/module/loading.dart';
import 'package:ude_admin_panel/module/widgets.dart';

class Reset extends StatelessWidget {
  const Reset({super.key});

  @override
  Widget build(BuildContext context) {
    MBloc<bool> reset = MBloc<bool>()..setValue(true);
    TextEditingController? code = TextEditingController();
    String secretCode = '';
    final RegExp codePattern = RegExp(r'RESETALLDATA2023');
    final formkey = GlobalKey<FormState>();

    return StreamBuilder<bool>(
        stream: reset.stream,
        builder: (context, snap) {
          return snap.hasData && snap.data!
              ? SizedBox(
                  height: 300,
                  width: context.width * 0.3 > 350 ? 450 : context.width * 0.3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      'Reset All Data'
                          .toLabel(bold: true, color: Colors.grey, fontsize: 18)
                          .margin9,
                      Form(
                        key: formkey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            MEdit(
                              controller: code,
                              hint: 'Enter your secret code for reset all data',
                              onChange: (val) {
                                secretCode = val;
                              },
                              autoFocus: true,
                              notEmpty: true,
                              pattern: codePattern,
                              error: 'Code Incorrect',
                              password: true,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MButton(
                                    type: ButtonType.Cancel,
                                    onTap: () {
                                      reset.setValue(false);
                                    },
                                    title: 'Cancel'),
                                const SizedBox(
                                  width: 10,
                                ),
                                MButton(
                                    type: ButtonType.Save,
                                    onTap: () async {
                                      if (formkey.currentState!.validate()) {
                                        Chargement(context);
                                        if (await context.userBloc.resetAll(
                                          context,
                                          secretCode,
                                        )) {
                                          Navigator.of(context).pop();

                                          reset.setValue(false);
                                          context.snackBar(
                                              "Vos donnees ont ete reinitialiser avec success",
                                              color: Colors.green);
                                        } else {
                                          Navigator.of(context).pop();

                                          context.snackBar(
                                              "Erreur lors de la reinitialisation des donnees");
                                          reset.setValue(false);
                                        }
                                      }
                                    },
                                    title: 'Save'),
                              ],
                            )
                          ],
                        ),
                      ).padding9.card,
                    ],
                  ),
                ).center
              : 'Go to Dashboard'.toLabel(bold: true).center;
        });
  }
}
