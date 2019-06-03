/// @description void dialog_note_changes(Dialog);
/// @param Dialog

var old_title=argument0.text;

if (argument0.changed) {
    argument0.text="* "+argument0.text;
}

dialog_default(argument0);

argument0.text=old_title;
