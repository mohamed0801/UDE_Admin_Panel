// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:ude_admin_panel/Model/Sceance.dart';

import '../../Bloc/BlocState.dart';
import '../../Model/Student.dart';
import '../../module/estension.dart';
import '../../module/widgets.dart';

class SceanceAbscence extends StatelessWidget {
  final SceanceM sceance;
  const SceanceAbscence({required this.sceance, super.key});

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
              '${sceance.id}'.toLabel(bold: true).expand,
              '${sceance.classe}'.toLabel(bold: true).expand,
              '      ${sceance.matiere}'.toLabel(bold: true).expand,
              '                ${sceance.creneau}'.toLabel(bold: true).expand,
              '                  ${sceance.volume}'.toLabel(bold: true).expand,
              '                ${sceance.date}'.toLabel(bold: true).expand,
            ],
          ).padding9.cardColor(color: context.bottomAppBarColor),
          Row(
            children: [
              const SizedBox(
                width: 45,
              ),
              'Matricule'.toLabel(bold: true).expand,
              '        Nom'.toLabel(bold: true).expand,
              '              Prénom'.toLabel(bold: true).expand,
            ],
          ).padding9.cardColor(color: context.accentColor.withOpacity(0.15)),
          StreamBuilder<Object>(
              stream: context.userBloc.sceanceAbscenceListStream,
              builder: (context, snap) {
                if (snap.data is Failed) {
                  return MError(exception: (snap.data as Failed).exception);
                }
                if (snap.data is LoadData) {
                  return SizedBox(
                    height: 500,
                    child: ListView.builder(
                      itemCount: (snap.data as LoadData).rows.length,
                      itemBuilder: (context, index) {
                        final StudentM student =
                            (snap.data as LoadData).rows[index];
                        return Column(
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
                                '    ${student.id}'.toLabel(bold: true).expand,
                                '                   ${student.firstname}'
                                    .toLabel(bold: true)
                                    .expand,
                                '                          ${student.lastname}'
                                    .toLabel(bold: true)
                                    .expand,
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
                  );
                }
                return const MWaiting().center;
              }).expand
        ],
      ).margin9.padding9.card,
    );
  }
}
