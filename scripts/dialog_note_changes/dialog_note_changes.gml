/// @param Dialog

var dialog = argument0;

var old_title = dialog.text;

if (dialog.changed) {
    dialog.text = "* " + dialog.text;
}

dialog_default(dialog);

dialog.text = old_title;