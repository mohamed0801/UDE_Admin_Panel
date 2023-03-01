// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ude_admin_panel/Services/db.dart';
import 'package:ude_admin_panel/module/loading.dart';

import '../../Bloc/BlocState.dart';
import '../../Model/Classe.dart';
import '../../module/estension.dart';
import '../../module/widgets.dart';
import 'StudentAbscence.dart';

class ClasseStudent extends StatelessWidget {
  final ClasseM classe;
  const ClasseStudent({required this.classe, super.key});

  @override
  Widget build(BuildContext context) {
    String newcode = '';
    MBloc<bool> newstudent = MBloc<bool>()..setValue(false);
    final formkey = GlobalKey<FormState>();
    TextEditingController? code = TextEditingController();
    TextEditingController? firstname = TextEditingController();
    TextEditingController? lastname = TextEditingController();
    TextEditingController? sexe = TextEditingController();
    final List<String> studentsexe = ['Masculin', 'Feminin'];
    final String codePattern =
        "^${context.user!.id!.substring(0, 4)}[a-zA-Z0-9]{7}\$";
    final RegExp codregex = RegExp(codePattern);
    final RegExp simpleFieldRegex = RegExp(r'^[a-zA-Z\s]+$');
    final RegExp simpleFieldNumberRegex = RegExp(r'^[a-zA-Z0-9]+$');
    return Stack(
      children: [
        SizedBox(
          width: context.width * 0.75,
          height: context.height * 0.75,
          child: StreamBuilder<Object>(
              stream: context.userBloc.studentListStream,
              builder: (context, snap) {
                if (snap.data is Failed) {
                  return MError(exception: (snap.data as Failed).exception);
                }
                if (snap.data is LoadData) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 2,
                              height: 35,
                              color: Colors.green,
                            ),
                            const Icon(Icons.school).hMargin9,
                            '${classe.name}'.toLabel(bold: true).expand,
                            '      ${classe.fille}'.toLabel(bold: true).expand,
                            '                ${classe.garcon}'
                                .toLabel(bold: true)
                                .expand,
                            '       ${classe.total}'.toLabel(bold: true).expand,
                            MIconButton(
                                icon: const Icon(Icons.people),
                                onPressed: () {},
                                hint: 'Eleves'),
                          ],
                        ).padding9.cardColor(color: context.bottomAppBarColor),
                        Row(
                          children: [
                            const SizedBox(
                              width: 45,
                            ),
                            'Matricule'.toLabel(bold: true).expand,
                            ' Nom'.toLabel(bold: true).expand,
                            '          Prenom'.toLabel(bold: true).expand,
                            'abscence'.toLabel(bold: true).expand,
                            MIconButton(
                              hint: 'new student',
                              icon: const Icon(Icons.add_box_outlined,
                                  color: Colors.blue),
                              onPressed: () {
                                newstudent.setValue(true);
                              },
                            ),
                          ],
                        ).padding9.cardColor(
                            color: context.accentColor.withOpacity(0.15)),
                        SizedBox(
                          height: 500,
                          child: ListView.builder(
                            itemCount: (snap.data as LoadData).rows.length,
                            itemBuilder: (context, index) {
                              final student =
                                  (snap.data as LoadData).rows[index];
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      int.parse(student.abscence) > 0
                                          ? Container(
                                              width: 2,
                                              height: 42,
                                              decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  12),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  12))),
                                            )
                                          : Container(
                                              width: 2,
                                              height: 42,
                                              decoration: const BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  12),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  12))),
                                            ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      const Icon(Icons.person).hMargin9,
                                      '${student.id}'
                                          .toLabel(bold: true)
                                          .expand,
                                      '      ${student.firstname}'
                                          .toLabel(bold: true)
                                          .expand,
                                      '                ${student.lastname}'
                                          .toLabel(bold: true)
                                          .expand,
                                      '                  ${student.abscence}'
                                          .toLabel(bold: true)
                                          .expand,
                                      MIconButton(
                                          icon: const Icon(Icons.info),
                                          onPressed: () async {
                                            context.userBloc
                                                .loadStudentAbscenceList(
                                                    context.user!.id!
                                                        .substring(0, 4),
                                                    classe.name,
                                                    student.id);
                                            final matieres = await DBServices
                                                .getClasseMatiere(
                                                    context.user!.id!
                                                        .substring(0, 4),
                                                    classe.name);
                                            context
                                                .showAsDialog(StudentAbscence(
                                              student: student,
                                              matieres: matieres,
                                            ));
                                          },
                                          hint: 'Abscence'),
                                      MIconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {},
                                          hint: 'Supprimer')
                                    ],
                                  ).padding9.cardColor(
                                      color: index.isOdd
                                          ? context.bottomAppBarColor
                                          : null),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ).margin9.padding9.card,
                  );
                }
                return const MWaiting().center;
              }),
        ),
        StreamBuilder<bool>(
            stream: newstudent.stream,
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
                                      'student code(must start with ${context.user!.id!.substring(0, 4)})',
                                  onChange: (val) {
                                    newcode = val;
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
                                  pattern: simpleFieldNumberRegex,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                MDropdownTextField(
                                  controller: sexe,
                                  hint: 'Sexe',
                                  dropvalues: studentsexe,
                                  autoFocus: true,
                                  notEmpty: true,
                                  pattern: simpleFieldRegex,
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
                                          newstudent.setValue(false);
                                        },
                                        title: 'Cancel'),
                                    MButton(
                                        type: ButtonType.New,
                                        onTap: () async {
                                          Chargement(context);
                                          if (await context.userBloc
                                              .addStudentToClasse(
                                                  context,
                                                  classe.name,
                                                  newcode.toUpperCase(),
                                                  firstname.text,
                                                  lastname.text,
                                                  sexe.text)) {
                                            Navigator.of(context).pop();
                                            newstudent.setValue(false);
                                          } else {
                                            Navigator.of(context).pop();
                                            newstudent.setValue(false);
                                            context.snackBar(
                                                "Erreur lors de l'ajout de l'eleve");
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
