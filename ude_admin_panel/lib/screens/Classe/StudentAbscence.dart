// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:ude_admin_panel/Model/Matiere.dart';

import '../../Bloc/BlocState.dart';
import '../../Model/Student.dart';
import '../../module/estension.dart';
import '../../module/widgets.dart';

class StudentAbscence extends StatelessWidget {
  final StudentM student;
  final List<MatiereM> matieres;
  const StudentAbscence(
      {required this.student, required this.matieres, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width * 0.75,
      height: context.height * 0.75,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 2,
                height: 42,
                decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12))),
              ),
              const SizedBox(
                width: 3,
              ),
              const Icon(Icons.person).hMargin9,
              '${student.id}'.toLabel(bold: true).expand,
              '      ${student.firstname}'.toLabel(bold: true).expand,
              '                ${student.lastname}'.toLabel(bold: true).expand,
              '                  ${student.abscence}'
                  .toLabel(bold: true)
                  .expand,
            ],
          ).padding9.cardColor(color: context.bottomAppBarColor),
          Row(
            children: matieres
                .map((matiere) {
                  return '${matiere.matiere}'.toLabel(bold: true).expand;
                })
                .toList()
                .cast<Widget>(),
          ).padding9.cardColor(color: context.accentColor.withOpacity(0.15)),
          StreamBuilder<Object>(
              stream: context.userBloc.studentAbscenceListStream,
              builder: (context, snap) {
                if (snap.data is Failed) {
                  return MError(exception: (snap.data as Failed).exception);
                }
                if (snap.data is LoadData) {
                  return Row(
                    children: [
                      const SizedBox(
                        width: 8,
                      ),
                      for (var abscence in (snap.data as LoadData).rows)
                        '     ${abscence.abscence}'.toLabel(bold: true).expand,
                    ],
                  ).padding9.cardColor(color: context.bottomAppBarColor);
                }
                return const MWaiting().center;
              })
        ],
      ).margin9.padding9.card,
    );
  }
}
