// ignore_for_file: file_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ude_admin_panel/Repository/UserRepo.dart';
import 'package:ude_admin_panel/Services/db.dart';
import 'package:ude_admin_panel/module/loading.dart';

import '../../Bloc/BlocState.dart';
import '../../module/estension.dart';
import '../../module/widgets.dart';
import 'Sceances.dart';
import 'TeacherClasse.dart';

class Teachers extends StatelessWidget {
  const Teachers({super.key});

  @override
  Widget build(BuildContext context) {
    context.userBloc.loadTeacherList(context.user!.id!.substring(0, 4));
    Future.delayed(const Duration(seconds: 2));
    String newcode = '';
    List<DocumentReference> classeRefs = [];
    final formkey = GlobalKey<FormState>();
    MBloc<bool> newteacher = MBloc<bool>()..setValue(false);
    TextEditingController? code = TextEditingController();
    TextEditingController? firstname = TextEditingController();
    TextEditingController? lastname = TextEditingController();
    TextEditingController? classe = TextEditingController();
    final List<String> userclasse = [
      '10eCG',
      '11eS',
      '11eSES',
      '11eL',
      '12eSE',
      '12eSET',
      '12eECO',
      '12eLL'
    ];

    final String codePattern =
        "^(${context.user!.id!.substring(0, 4)}|${context.user!.id!.substring(0, 4).toLowerCase()})[a-zA-Z0-9]{7}\$";
    final RegExp codregex = RegExp(codePattern);
    final RegExp simpleFieldRegex = RegExp(r'^[a-zA-Z\s]+$');

    return Stack(
      children: [
        SizedBox(
          width: context.width * 0.80,
          height: context.height * 0.80,
          child: StreamBuilder<Object>(
              stream: context.userBloc.userListStream,
              builder: (context, snapshot) {
                if (snapshot.data is Failed) {
                  return MError(exception: (snapshot.data as Failed).exception);
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const MWaiting();
                }
                if (snapshot.data is LoadData) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 45,
                          ),
                          'Name'.toLabel(bold: true).expand,
                          'Hours'.toLabel(bold: true).expand,
                          MIconButton(
                            hint: 'new teacher',
                            icon: const Icon(Icons.add_box_outlined,
                                color: Colors.blue),
                            onPressed: () {
                              newteacher.setValue(true);
                            },
                          ),
                        ],
                      ).padding9.cardColor(
                          color: context.accentColor.withOpacity(0.15)),
                      SizedBox(
                        height: 500,
                        child: ListView.builder(
                          itemCount: (snapshot.data as LoadData).rows.length,
                          itemBuilder: (context, index) {
                            final enseignant =
                                (snapshot.data as LoadData).rows[index];
                            return Row(
                              children: [
                                const Icon(Icons.person_rounded).hMargin9,
                                '${enseignant.firstname} ${enseignant.lastname}'
                                    .toLabel(bold: true)
                                    .expand,
                                '            ${enseignant.hours}'
                                    .toLabel(bold: true)
                                    .expand,
                                MIconButton(
                                    icon: const Icon(Icons.school),
                                    onPressed: () {
                                      context.userBloc.loadTeacherClasseList(
                                          context.user!.id!.substring(0, 4),
                                          enseignant.id);
                                      context.showAsDialog(TeacherClasse(
                                        enseignant: enseignant,
                                      ));
                                    },
                                    hint: 'Classes'),
                                MIconButton(
                                    icon: const Icon(FontAwesomeIcons.scroll),
                                    onPressed: () {
                                      context.userBloc.loadTeacherSceanceList(
                                          context.user!.id!.substring(0, 4),
                                          enseignant.id);
                                      context.showAsDialog(TeacherSceance(
                                        enseignant: enseignant,
                                      ));
                                    },
                                    hint: 'Sceance'),
                                MIconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Etes vous sure de vouloir supprimer cet enseignant'),
                                            actions: [
                                              MButton(
                                                  type: ButtonType.Cancel,
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  title: 'Cancel'),
                                              MButton(
                                                  type: ButtonType.Save,
                                                  onTap: () async {
                                                    Chargement(context);
                                                    if (await DBServices
                                                        .deleteTeacherById(
                                                            context.user!.id!
                                                                .substring(
                                                                    0, 4),
                                                            enseignant.id)) {
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.of(context)
                                                          .pop();
                                                      context.userBloc
                                                          .loadTeacherList(
                                                              context.user!.id!
                                                                  .substring(
                                                                      0, 4));
                                                      context.snackBar(
                                                          'Enseigant supprimer avec success.',
                                                          color: Colors.green);
                                                    } else {
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.of(context)
                                                          .pop();
                                                      context.snackBar(
                                                          'Erreur lors de la Suppression. Veuiller recommencer ulterieurement',
                                                          color: Colors.red);
                                                    }
                                                  },
                                                  title: 'Save'),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    hint: 'Supprimer')
                              ],
                            ).padding9.cardColor(
                                color: index.isOdd
                                    ? context.bottomAppBarColor
                                    : null);
                          },
                        ),
                      ).expand
                    ],
                  );
                }
                return const MWaiting().center;
              }),
        ),
        StreamBuilder<bool>(
            stream: newteacher.stream,
            builder: (context, snap) {
              return snap.hasData && snap.data!
                  ? Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.grey.withOpacity(0.35),
                      child: Center(
                        child: SizedBox(
                          width: 300,
                          child: Form(
                            key: formkey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                MEdit(
                                  controller: code,
                                  hint:
                                      'teacher code(must start with ${context.user!.id!.substring(0, 4)})',
                                  onChange: (val) {
                                    newcode = val;
                                    debugPrint(codePattern);
                                  },
                                  autoFocus: true,
                                  notEmpty: true,
                                  pattern: codregex,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                MEdit(
                                  controller: firstname,
                                  hint: 'Firstname',
                                  onChange: (val) {},
                                  autoFocus: true,
                                  notEmpty: true,
                                  pattern: simpleFieldRegex,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                MEdit(
                                  controller: lastname,
                                  hint: 'Lastname',
                                  onChange: (val) {},
                                  autoFocus: true,
                                  notEmpty: true,
                                  pattern: simpleFieldRegex,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                CheckboxTextField(
                                  controller: classe,
                                  hint: 'Classe',
                                  options: userclasse,
                                  autoFocus: true,
                                  notEmpty: true,
                                ),
                                const SizedBox(
                                  height: 35,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    MButton(
                                        type: ButtonType.Cancel,
                                        onTap: () {
                                          newteacher.setValue(false);
                                        },
                                        title: 'Cancel'),
                                    MButton(
                                        type: ButtonType.New,
                                        onTap: () async {
                                          if (formkey.currentState!
                                              .validate()) {
                                            Chargement(context);
                                            for (var classe
                                                in classe.text.split(',')) {
                                              classe = classe.trim();

                                              var classeRef =
                                                  await UserRepo.getClasseRef(
                                                      context,
                                                      context.user!.id!
                                                          .substring(0, 4),
                                                      classe);
                                              classeRefs.add(classeRef);
                                            }

                                            if (await context.userBloc
                                                .addTeacher(
                                                    context,
                                                    newcode.toUpperCase(),
                                                    firstname.text,
                                                    lastname.text,
                                                    classeRefs)) {
                                              Navigator.of(context).pop();
                                              newteacher.setValue(false);
                                              code.dispose();
                                              firstname.dispose();
                                              lastname.dispose();
                                              classe.dispose();
                                              context.userBloc.loadTeacherList(
                                                  context.user!.id!
                                                      .substring(0, 4));
                                              context.snackBar(
                                                  "Enseignant ajouter avec success",
                                                  color: Colors.green,
                                                  title: 'Success');
                                            } else {
                                              Navigator.of(context).pop();
                                              newteacher.setValue(false);
                                              code.dispose();
                                              firstname.dispose();
                                              lastname.dispose();
                                              classe.dispose();
                                              context.snackBar(
                                                  "Erreur lors de l'ajout de l'enseignant",
                                                  color: Colors.red,
                                                  title: 'Erreur');
                                            }
                                          }
                                        },
                                        title: 'new'),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ).padding9.card,
                      ),
                    )
                  : Container();
            })
      ],
    );
  }
}
