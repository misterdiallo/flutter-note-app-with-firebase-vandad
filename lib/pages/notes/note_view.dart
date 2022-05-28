import 'package:flutter/material.dart';
import 'package:my_notes/config/app_constante.dart';
import 'package:my_notes/config/constant/routes.dart';
import 'package:my_notes/enums/menu_action.dart';
import 'package:my_notes/pages/notes/list_note_view.dart';
import 'package:my_notes/pages/router_page.dart';
import 'package:my_notes/pages/widgets/appbar_defautl.dart';

import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/services/cloud/cloud_note.dart';
import 'package:my_notes/services/cloud/firebase_cloud_storage.dart';
import 'package:my_notes/utilities/dialogs/logout_dialog.dart';

class NoteView extends StatefulWidget {
  const NoteView({Key? key}) : super(key: key);

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  // late final NoteService _noteService;
  late final FirebaseCloudStorage _noteService;
  String get userEmail => AuthService.firebase().currentUser!.email;
  String get userId => AuthService.firebase().currentUser!.id!;

  @override
  void initState() {
    // _noteService = NoteService();
    _noteService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // devtools.log("Hello");
    return Scaffold(
      appBar: appBarDefault(
        context,
        "My Notes",
        [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createUpdateNoteRoute);
              },
              icon: const Icon(Icons.add)),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  var response = await showLogoutDialog(context: context);
                  if (response) {
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) => RouterPage(
                                  title: appName,
                                )),
                        (Route<dynamic> route) => false);
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Sign Out'),
                )
              ];
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _noteService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                if (allNotes.isEmpty) {
                  return Center(
                    child: Text(
                      "You don't have notes.",
                      style: Theme.of(context).textTheme.overline,
                    ),
                  );
                }
                return NotesListView(
                  listNotes: allNotes,
                  onTapNote: (note) {
                    Navigator.of(context).pushNamed(
                      createUpdateNoteRoute,
                      arguments: note,
                    );
                  },
                  onDeleteNote: (note) async {
                    await _noteService.deleteNote(documentId: note.documentId);
                  },
                );
              } else {
                return Center(
                  child: Text(
                    "Empty notes...",
                    style: Theme.of(context).textTheme.overline,
                  ),
                );
              }
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      // FutureBuilder(
      //   future: _noteService.getOrCreateUser(email: userEmail),
      //   builder: (context, AsyncSnapshot snapshot) {
      //     switch (snapshot.connectionState) {
      //       case ConnectionState.done:
      //         return StreamBuilder(
      //           stream: _noteService.allNotes,
      //           builder: (context, snapshot) {
      //             switch (snapshot.connectionState) {
      //               case ConnectionState.waiting:
      //               case ConnectionState.active:
      //                 if (snapshot.hasData) {
      //                   final allNotes = snapshot.data as List<DatabaseNote>;
      //                   if (allNotes.isEmpty) {
      //                     return Center(
      //                       child: Text(
      //                         "You don't have notes.",
      //                         style: Theme.of(context).textTheme.overline,
      //                       ),
      //                     );
      //                   }
      //                   return NotesListView(
      //                     listNotes: allNotes,
      //                     onTapNote: (note) {
      //                       Navigator.of(context).pushNamed(
      //                         createUpdateNoteRoute,
      //                         arguments: note,
      //                       );
      //                     },
      //                     onDeleteNote: (note) async {
      //                       await _noteService.deleteNote(id: note.id);
      //                     },
      //                   );
      //                 } else {
      //                   return Center(
      //                     child: Text(
      //                       "Empty notes...",
      //                       style: Theme.of(context).textTheme.overline,
      //                     ),
      //                   );
      //                 }
      //               default:
      //                 return const Center(child: CircularProgressIndicator());
      //             }
      //           },
      //         );
      //       default:
      //         return const Center(
      //           child: LinearProgressIndicator(),
      //         );
      //     }
      //     // return Column(
      //     //   mainAxisAlignment: MainAxisAlignment.center,
      //     //   // crossAxisAlignment: CrossAxisAlignment.center,
      //     //   children: [
      //     //     // user.displayName != null
      //     //     //     ? Center(
      //     //     //         child: Text(
      //     //     //           user.displayName.toString(),
      //     //     //           style: Theme.of(context).textTheme.headline6,
      //     //     //         ),
      //     //     //       )
      //     //     //     : const SizedBox(),
      //     //     // user.displayName != null
      //     //     //     ? const SizedBox(
      //     //     //         height: 15,
      //     //     //       )
      //     //     //     : const SizedBox(),
      //     //     Center(
      //     //       child: Text(
      //     //         "Welcome to ",
      //     //         style: Theme.of(context).textTheme.headline5,
      //     //       ),
      //     //     ),
      //     //     const SizedBox(
      //     //       height: 25,
      //     //     ),
      //     //     Center(
      //     //       child: Text(
      //     //         "let's start coding!",
      //     //         style: Theme.of(context).textTheme.overline,
      //     //       ),
      //     //     ),
      //     //   ],
      //     // );
      //   },
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      // ),
    );
  }
}
