import 'package:flutter/material.dart';
import 'package:my_notes/services/cloud/cloud_note.dart';
import 'package:my_notes/utilities/dialogs/delete_dialog.dart';

// typedef NoteCallback = void Function(DatabaseNote note);
typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  // final List<DatabaseNote> listNotes;
  final Iterable<CloudNote> listNotes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTapNote;
  const NotesListView(
      {Key? key,
      required this.listNotes,
      required this.onDeleteNote,
      required this.onTapNote})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listNotes.length,
      itemBuilder: (context, index) {
        // final note = listNotes[index];
        final note = listNotes.elementAt(index);
        return ListTile(
          onTap: () {
            onTapNote(note);
          },
          dense: true,
          leading: const Icon(Icons.add_to_home_screen),
          title: Text(
            note.title,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context: context);
              if (shouldDelete) {
                onDeleteNote(note);
              }
            },
          ),
        );
      },
    );
  }
}
