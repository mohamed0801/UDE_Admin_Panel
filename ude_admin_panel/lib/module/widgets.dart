// ignore_for_file: prefer_if_null_operators, prefer_final_fields, library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rxdart/subjects.dart';
import 'package:ude_admin_panel/module/Theme.dart';
import 'package:ude_admin_panel/module/estension.dart';

// ignore: constant_identifier_names
enum ButtonType { Save, New, Delete, Cancel, Other }

class MBloc<t> {
  final BehaviorSubject<t> _bloc = BehaviorSubject<t>();
  Stream<t> get stream => _bloc.stream;
  t get value => _bloc.value;

  void setValue(t val) => _bloc.add(val);
}

class MLabel extends StatelessWidget {
  final String title;
  final double? fontSize;
  final Color? color;
  final bool bold;
  const MLabel(this.title,
      {this.fontSize, this.color, this.bold = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal),
    );
  }
}

class MButton extends StatelessWidget {
  final String? title;
  final VoidCallback onTap;
  final Icon? icon;
  final ButtonType? type;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  const MButton({
    Key? key,
    this.title,
    required this.onTap,
    this.icon,
    this.type,
    this.color,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              color != null
                  ? color
                  : type == ButtonType.Save
                      ? Colors.green
                      : type == ButtonType.Cancel
                          ? Colors.deepOrangeAccent
                          : type == ButtonType.Delete
                              ? Colors.redAccent
                              : type == ButtonType.New
                                  ? Colors.blue
                                  : null,
            ),
            padding:
                MaterialStateProperty.all(padding ?? const EdgeInsets.all(22))),
        child: type != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon ??
                      Icon(
                          type == ButtonType.Save
                              ? Icons.save
                              : type == ButtonType.Cancel
                                  ? Icons.cancel
                                  : type == ButtonType.Delete
                                      ? Icons.delete
                                      : type == ButtonType.New
                                          ? Icons.add_box
                                          : Icons.help_center,
                          size: 15),
                  const SizedBox(
                    width: 5,
                  ),
                  title != null
                      ? title!.toLabel()
                      : type == ButtonType.Save
                          ? 'Save'.toLabel()
                          : type == ButtonType.Cancel
                              ? 'Cancel'.toLabel()
                              : type == ButtonType.Delete
                                  ? 'Delete'.toLabel()
                                  : type == ButtonType.New
                                      ? 'New'.toLabel()
                                      : title!.toLabel()
                ],
              )
            : icon != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      icon!,
                      const SizedBox(width: 5),
                      title!.toLabel()
                    ],
                  )
                : title!.toLabel());
  }
}

class MTextButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color? color;
  const MTextButton(
      {required this.title, required this.onPressed, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed, child: title.toLabel(color: color));
  }
}

class MEdit extends StatelessWidget {
  final String hint;
  final Function(String)? onChange;
  final RegExp? pattern;
  final bool autoFocus;
  final bool password;
  final bool notEmpty;
  final TextEditingController? controller;
  const MEdit(
      {required this.hint,
      this.controller,
      this.onChange,
      this.pattern,
      this.notEmpty = false,
      this.autoFocus = false,
      this.password = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8), gapPadding: 20),
          labelText: hint,
          labelStyle: TextStyle(color: Colors.grey.shade500, fontSize: 20)),
      obscureText: password,
      controller: controller,
      autofocus: autoFocus,
      onChanged: onChange,
      validator: (value) {
        if ((value ?? '').isEmpty && notEmpty) {
          return "Requis";
        }
        if (!pattern!.hasMatch(value!)) {
          return 'Format invalide';
        }
        return null;
      },
    );
  }
}

class MDropdownTextField extends StatefulWidget {
  final String hint;
  final List<String>? dropvalues;
  final bool autoFocus;
  final bool notEmpty;
  final RegExp? pattern;
  final TextEditingController? controller;
  const MDropdownTextField(
      {super.key,
      required this.hint,
      required this.controller,
      this.dropvalues,
      this.autoFocus = false,
      this.notEmpty = false,
      this.pattern});
  @override
  _MDropdownTextFieldState createState() => _MDropdownTextFieldState();
}

class _MDropdownTextFieldState extends State<MDropdownTextField> {
  String? _selectedDropdownValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8), gapPadding: 20),
          labelText: widget.hint,
          labelStyle: TextStyle(color: Colors.grey.shade500, fontSize: 20)),
      controller: widget.controller,
      autofocus: widget.autoFocus,
      onTap: () {
        _openDropdown(context);
      },
      validator: (value) {
        if ((value ?? '').isEmpty && widget.notEmpty) {
          return "Requis";
        }
        if (!widget.pattern!.hasMatch(value!)) {
          return 'Format invalide';
        }

        return null;
      },
    );
  }

  // ouvrir la liste déroulante
  void _openDropdown(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choisir une valeur'),
          content: DropdownButton(
            value: _selectedDropdownValue,
            items: widget.dropvalues!.map((value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              // mettre à jour la valeur sélectionnée dans la liste déroulante
              setState(() {
                _selectedDropdownValue = newValue;
                widget.controller!.text = newValue!;
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}

class MSwitch extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;
  final String? hint;
  const MSwitch(
      {required this.value, required this.onChanged, this.hint, super.key});

  @override
  Widget build(BuildContext context) {
    MBloc<bool> val = MBloc<bool>()..setValue(value);
    return StreamBuilder<bool>(
      stream: val.stream,
      builder: (_, snap) {
        if (snap.hasData) {
          return hint != null
              ? Tooltip(
                  message: hint,
                  child: Switch(
                    value: snap.data!,
                    onChanged: (v) {
                      onChanged(v);
                      val.setValue(v);
                    },
                  ))
              : Switch(
                  value: snap.data!,
                  onChanged: (v) {
                    onChanged(v);
                    val.setValue(v);
                  },
                );
        }
        return Container();
      },
    );
  }
}

class MError extends StatelessWidget {
  final Exception exception;
  const MError({required this.exception, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: exception.toString().toLabel(color: Colors.white, bold: true),
    );
  }
}

class MWaiting extends StatelessWidget {
  const MWaiting({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoActivityIndicator().center;
  }
}

class MSideBarItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final int notif;
  final bool selected;
  final VoidCallback onTap;
  const MSideBarItem(
      {required this.title,
      required this.icon,
      this.notif = 0,
      this.selected = false,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      selectedTileColor: context.bottomAppBarColor,
      title: title.toLabel(color: Colors.grey.shade600, fontsize: 13),
      leading: Icon(
        icon,
        size: 15,
        color: Colors.grey.shade600,
      ),
      trailing: notif > 0
          ? CircleAvatar(
              backgroundColor: Colors.pink,
              radius: 10,
              child: '$notif'.toLabel(fontsize: 10))
          : null,
      onTap: onTap,
    );
  }
}

class MDarkLightSwitch extends StatelessWidget {
  const MDarkLightSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.themeBloc
            .setTheme(context.isDark ? AppTheme.Light : AppTheme.Dark);
      },
      child: SizedBox(
        width: 40,
        height: 25,
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: context.accentColor.withOpacity(0.5),
              ),
            ),
            context.isDark
                ? Container()
                : Align(
                    alignment: Alignment.centerRight,
                    child: FaIcon(
                      FontAwesomeIcons.sun,
                      color: Colors.yellow.shade700,
                    ),
                  ),
            context.isDark
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: FaIcon(
                      FontAwesomeIcons.moon,
                      color: Colors.blue.shade600,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class MIconButton extends StatelessWidget {
  final Icon icon;
  final String hint;
  final VoidCallback onPressed;
  const MIconButton(
      {required this.icon,
      required this.onPressed,
      required this.hint,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: hint,
      child: IconButton(
        icon: icon,
        onPressed: onPressed,
      ),
    );
  }
}
