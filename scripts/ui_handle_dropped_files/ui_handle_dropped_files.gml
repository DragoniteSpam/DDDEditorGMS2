function ui_handle_dropped_files(thing) {
    if (!dialog_is_active(thing.root)) return;
    if (array_length(Stuff.files_dropped) > 0) {
        thing.file_dropper_action(thing, Stuff.files_dropped);
    }
}