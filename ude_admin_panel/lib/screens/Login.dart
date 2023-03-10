// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../Bloc/BlocState.dart';
import '../module/estension.dart';
import '../module/widgets.dart';

TextEditingController? _matricule = TextEditingController();
TextEditingController? _password = TextEditingController();
bool _remember = false;
final RegExp simpleFieldRegex = RegExp(r'^[a-zA-Z0-9]+$');

class Login extends StatelessWidget {
  final BlocState state;
  const Login({required this.state, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formkey = GlobalKey<FormState>();
    return Scaffold(
      body: Form(
        key: formkey,
        child: SafeArea(
            child: SizedBox(
          width: context.width * 0.3 > 350 ? 450 : context.width * 0.3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              'Welcome to ude admin panel'
                  .toLabel(bold: true, color: Colors.grey, fontsize: 18)
                  .margin9,
              MEdit(
                hint: 'Matricule',
                controller: _matricule,
                notEmpty: true,
                pattern: simpleFieldRegex,
              ).margin9,
              MEdit(
                hint: 'Password',
                controller: _password,
                password: true,
                notEmpty: true,
                pattern: simpleFieldRegex,
              ).margin9,
              AbsorbPointer(
                absorbing: state is Loading,
                child: Column(
                  children: [
                    Row(
                      children: [
                        MSwitch(
                          value: _remember,
                          hint: 'Se souvenir de moi',
                          onChanged: (v) {
                            _remember = v;
                          },
                        ),
                        'Se Souvenir de moi!'.toLabel(),
                        const Spacer(),
                        MTextButton(title: "S'enregistrer", onPressed: () {})
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MButton(
                          title: 'Login',
                          onTap: () {
                            if (formkey.currentState!.validate()) {
                              context.userBloc.authenticate(
                                  _matricule!.text
                                      .substring(0, 4)
                                      .toUpperCase(),
                                  _matricule!.text.toUpperCase(),
                                  _remember);
                            }
                          },
                          icon: const Icon(Icons.vpn_key, size: 15),
                          color: Colors.blue,
                        ).margin9,
                        state is Loading ? const MWaiting() : Container(),
                        const Spacer(),
                        MTextButton(
                            title: 'Mot de passe oublie?', onPressed: () {})
                      ],
                    ),
                  ],
                ),
              ),
              state is Failed
                  ? MError(exception: (state as Failed).exception)
                  : Container(),
            ],
          ),
        ).padding9.card.center),
      ),
    );
  }
}
