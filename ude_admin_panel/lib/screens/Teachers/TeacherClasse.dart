// ignore_for_file: file_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ude_admin_panel/Repository/UserRepo.dart';
import 'package:ude_admin_panel/Services/db.dart';
import 'package:ude_admin_panel/module/loading.dart';

import '../../Bloc/BlocState.dart';
import '../../Model/Enseignant.dart';
import '../../module/estension.dart';
import '../../module/widgets.dart';

class TeacherClasse extends StatelessWidget {
  final EnseignantM enseignant;
  const TeacherClasse({required this.enseignant, super.key});

  @override
  Widget build(BuildContext context) {
    MBloc<bool> newclasse = MBloc<bool>()..setValue(false);
    TextEditingController? classe = TextEditingController();
    List<DocumentReference> classeRefs = [];
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

    return Stack(
      children: [
        SizedBox(
          width: context.width * 0.75,
          height: context.height * 0.75,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 2,
                    height: 35,
                    color: Colors.green,
                  ),
                  const Icon(Icons.person).hMargin9,
                  '${enseignant.id}'.toLabel(bold: true).expand,
                  '      ${enseignant.firstname}'.toLabel(bold: true).expand,
                  '                ${enseignant.lastname}'
                      .toLabel(bold: true)
                      .expand,
                  '                  ${enseignant.hours}'
                      .toLabel(bold: true)
                      .expand,
                ],
              )
                  .padding9
                  .cardColor(color: context.accentColor.withOpacity(0.15)),
              Row(
                children: [
                  const SizedBox(
                    width: 45,
                  ),
                  'Nom'.toLabel(bold: true).expand,
                  '       Fille'.toLabel(bold: true).expand,
                  '                      Garcon'.toLabel(bold: true).expand,
                  '                 Total'.toLabel(bold: true).expand,
                  MIconButton(
                    hint: 'new classe',
                    icon:
                        const Icon(Icons.add_box_outlined, color: Colors.blue),
                    onPressed: () {
                      newclasse.setValue(true);
                    },
                  ),
                ],
              )
                  .padding9
                  .cardColor(color: context.accentColor.withOpacity(0.15)),
              StreamBuilder<Object>(
                  stream: context.userBloc.userClasseListStream,
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
                                '          ${classe.fille}'
                                    .toLabel(bold: true)
                                    .expand,
                                '                               ${classe.garcon}'
                                    .toLabel(bold: true)
                                    .expand,
                                '                           ${classe.total}'
                                    .toLabel(bold: true)
                                    .expand,
                                MIconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {},
                                    hint: 'Supprimer'),
                              ],
                            ).padding9.cardColor(
                                color: index.isOdd
                                    ? context.bottomAppBarColor
                                    : null);
                          },
                        ),
                      );
                    }
                    return const MWaiting().center;
                  }).expand
            ],
          ),
        ),
        StreamBuilder<bool>(
            stream: newclasse.stream,
            builder: (context, snap) {
              return snap.hasData && snap.data!
                  ? Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.grey.withOpacity(0.35),
                      child: Center(
                        child: SizedBox(
                          width: 300,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              CheckboxTextField(
                                controller: classe,
                                hint: 'Classe',
                                options: userclasse,
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
                                        newclasse.setValue(false);
                                      },
                                      title: 'Cancel'),
                                  MButton(
                                      type: ButtonType.New,
                                      onTap: () async {
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
                                        if (await DBServices.addTeacherClasse(
                                            context.user!.id!.substring(0, 4),
                                            enseignant.id,
                                            classeRefs)) {
                                          Navigator.of(context).pop();
                                          newclasse.setValue(false);
                                        } else {
                                          Navigator.of(context).pop();
                                          newclasse.setValue(false);
                                          context.snackBar(
                                              "Erreur lors de l'ajout de la classe");
                                        }
                                      },
                                      title: 'new'),
                                ],
                              )
                            ],
                          ),
                        ).padding9.card,
                      ),
                    )
                  : Container();
            })
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
