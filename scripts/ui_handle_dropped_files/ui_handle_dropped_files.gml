function ui_handle_dropped_files(thing) {
    if (array_length(Stuff.files_dropped) > 0) {
        thing.file_dropper_action(thing, Stuff.files_dropped);
    }
}