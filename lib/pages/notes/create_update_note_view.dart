import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:my_notes/pages/widgets/appbar_defautl.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/utilities/generics/get_arguments.dart';
import 'package:my_notes/services/cloud/cloud_note.dart';
import 'package:my_notes/services/cloud/firebase_cloud_storage.dart';

import '../../utilities/dialogs/cannot_share_empty_note_dialog.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  // DatabaseNote? _note;
  // late final NoteService _noteService;
  CloudNote? _note;
  late final FirebaseCloudStorage _noteService;
  late TextEditingController _titleController;
  late TextEditingController _textController;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    // _noteService = NoteService();
    _noteService = FirebaseCloudStorage();
    _formKey = GlobalKey<FormState>();
    _titleController = TextEditingController();
    _textController = TextEditingController();
    super.initState();
  }

  //! Listen typing and real time update data
  void _typeControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final title = _titleController.text;
    final text = _textController.text;
    // await _noteService.updateNote(note: note, text: text, title: title,);
    await _noteService.updateNote(
      documentId: note.documentId,
      text: text,
      title: title,
    );
  }

  //! setup Type Controller Listener
  void _setupTypeControllerListener() {
    _titleController.removeListener(_typeControllerListener);
    _textController.removeListener(_typeControllerListener);

    _titleController.addListener(_typeControllerListener);
    _textController.addListener(_typeControllerListener);
  }

  //! Create New Note
  // Future<DatabaseNote> createOrGetExistingNote(BuildContext context) async {
  //   final widgetNote = context.getArguments<DatabaseNote>();
  //   if (widgetNote != null) {
  //     _note = widgetNote;
  //     _titleController.text = widgetNote.title;
  //     _textController.text = widgetNote.text;
  //     return widgetNote;
  //   }
  //   final existingNote = _note;
  //   if (existingNote != null) {
  //     return existingNote;
  //   }
  //   final currentUser = AuthService.firebase().currentUser!;
  //   final email = currentUser.email;
  //   final owner = await _noteService.getUser(email: email);
  //   final newnote = await _noteService.createNote(owner: owner);
  //   _note = newnote;
  //   return newnote;
  // }
  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArguments<CloudNote>();
    if (widgetNote != null) {
      _note = widgetNote;
      _titleController.text = widgetNote.title;
      _textController.text = widgetNote.text;
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id!;
    final newnote = await _noteService.createNewNote(ownerUserId: userId);
    _note = newnote;
    return newnote;
  }

  //! delete Note If Text Is Empty
  // void _deleteNoteIfTextIsEmpty() async {
  //   final note = _note;
  //   final title = _titleController.text;
  //   final text = _textController.text;
  //   if (text.isEmpty && title.isEmpty && note != null) {
  //     _noteService.deleteNote(id: note.id);
  //   }
  // }
  void _deleteNoteIfTextIsEmpty() async {
    final note = _note;
    final title = _titleController.text;
    final text = _textController.text;
    if (text.isEmpty && title.isEmpty && note != null) {
      _noteService.deleteNote(documentId: note.documentId);
    }
  }

  // ! save Note If Text Not Empty
  // void _saveNoteIfTextNotEmpty() async {
  //   final note = _note;
  //   final title = _titleController.text;
  //   final text = _textController.text;
  //   if (note != null && text.isNotEmpty) {
  //     await _noteService.updateNote(note: note, text: text, title: title);
  //   }
  // }
  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final title = _titleController.text;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _noteService.updateNote(
          documentId: note.documentId, text: text, title: title);
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDefault(
        context,
        "New Note",
        [
          IconButton(
              onPressed: () async {
                final title = _titleController.text;
                final text = _textController.text;
                if (title.isEmpty || text.isEmpty || _note == null) {
                  await showCannotShareEmptyNoteDialog(context);
                } else {
                  Share.share(text, subject: title);
                }
              },
              icon: const Icon(Icons.share))
        ],
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              // _note = snapshot.data as DatabaseNote;
              // _note = snapshot.data as DatabaseNote?;
              _setupTypeControllerListener();
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Center(
                    //   child: Text(
                    //     "New Note",
                    //     style: Theme.of(context).textTheme.headline5,
                    //   ),
                    // ),
                    // Center(
                    //   child: Text(
                    //     "Any idea or",
                    //     style: Theme.of(context).textTheme.overline,
                    //   ),
                    // ),
                    // Center(
                    //   child: Text(
                    //     "Anything you wanna keep?",
                    //     style: Theme.of(context).textTheme.overline,
                    //   ),
                    // ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _titleController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: "Title",
                              hintText: "Enter your title",
                            ),
                            // validator: (value) {
                            //   if (value == null || value.trim().isEmpty) {
                            //     return 'Please enter your title';
                            //   }
                            //   // Return null if the entered email is valid
                            //   return null;
                            // },
                          ),
                          TextFormField(
                            controller: _textController,
                            keyboardType: TextInputType.multiline,
                            // textInputAction: TextInputAction.done,
                            maxLines: null,
                            decoration: const InputDecoration(
                              labelText: "Note",
                              hintText: "Enter your note",
                            ),
                            // onFieldSubmitted: (value) => loginCheck(),
                            // validator: (value) {
                            //   if (value == null || value.trim().isEmpty) {
                            //     return 'Please enter your note';
                            //   }
                            //   return null;
                            // },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
