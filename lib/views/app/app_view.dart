import 'package:baseapp/services/bloc/auth_bloc.dart';
import 'package:baseapp/services/bloc/auth_event.dart';
import 'package:baseapp/utils/dialogs/logout_dialog.dart';
import 'package:baseapp/utils/enums/menu_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  get itemBuilder => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App'),
        actions: [
          PopupMenuButton<MenuAction>(
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                ),
              ];
            },
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout && context.mounted) {
                    context.read<AuthBloc>().add(const AuthEventLogout());
                  }
              }
            },
          )
        ],
      ),
    );
  }
}
