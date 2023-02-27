// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../Bloc/BlocState.dart';
import '../../module/estension.dart';
import '../../module/widgets.dart';
import 'Student.dart';

class Classe extends StatelessWidget {
  const Classe({super.key});

  @override
  Widget build(BuildContext context) {
    context.userBloc.loadClasseList(context.user!.id!.substring(0, 4));
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(
              width: 45,
            ),
            'Nom'.toLabel(bold: true).expand,
            'Fille'.toLabel(bold: true).expand,
            'Garcon'.toLabel(bold: true).expand,
            'Total'.toLabel(bold: true).expand
          ],
        ).padding9.cardColor(color: context.accentColor.withOpacity(0.15)),
        StreamBuilder<Object>(
            stream: context.userBloc.classeListStream,
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
                      final classe = (snap.data as LoadData).rows[index];
                      return Row(
                        children: [
                          Container(
                            width: 2,
                            height: 42,
                            decoration: const BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12))),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          const Icon(Icons.school).hMargin9,
                          '${classe.name}'.toLabel(bold: true).expand,
                          '   ${classe.fille}'.toLabel(bold: true).expand,
                          '        ${classe.garcon}'.toLabel(bold: true).expand,
                          '          ${classe.total}'
                              .toLabel(bold: true)
                              .expand,
                          MIconButton(
                              icon: const Icon(Icons.people),
                              onPressed: () {
                                context.userBloc.loadClasseStudentList(
                                    context.user!.id!.substring(0, 4),
                                    classe.name);
                                context.showAsDialog(ClasseStudent(
                                  classe: classe,
                                ));
                              },
                              hint: 'Eleves'),
                        ],
                      ).padding9.cardColor(
                          color:
                              index.isOdd ? context.bottomAppBarColor : null);
                    },
                  ),
                );
              }
              return const MWaiting().center;
            }).expand
      ],
    );

    /*Container(
      height: 500,
      child: ListView.builder(
        itemCount: enseignants.length,
        itemBuilder: (context, index) {
          final enseignant = enseignants[index];
          return ListTile(
            title: Text('${enseignant.firstname} ${enseignant.lastname}'),
            subtitle: Text('${enseignant.id}'),
          );
        },
      ),
    );*/
  }
}
