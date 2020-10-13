function instance_destroy_later(what) {
    // if you can't savely destroy anything until the end of the step
    ds_queue_enqueue(Stuff.stuff_to_destroy, what);
}

function not_yet_implemented() {
    throw @"Stack trace requested, probably in lieu of a NotImplementedException.
(If you're an end user and seeing this, most of the time this means the developer meant to add a
feature and probably forgot.)";
}

function not_yet_implemented_polite() {
    // you're only allowed to have one; if more than one are requested at the same time,
    // only the first will be created
    var top = ds_list_top(Stuff.dialogs);
    if (!(top && (top.dialog_flags & DialogFlags.IS_EXCEPTION))) {
        var dialog = dialog_create_notice(noone,
            "Stack trace requested, probably in lieu of a NotImplementedException. (If you're an end user and seeing this, most of the time this means the developer meant to add a feature and probably forgot.)\n\n",
            "Whoa, whoa!", "Okay", 640, 400
        );
        
        dialog.dialog_flags |= DialogFlags.IS_EXCEPTION;
        dialog.el_text.x = 32;
        dialog.el_text.y = 32;
        dialog.el_text.wrap_width = dialog.width - 64;
        dialog.el_text.alignment = fa_left;
        dialog.el_text.valignment = fa_top;
        
        var callstack = debug_get_callstack();
        var max_lines = 9;
        // index 0 is this script, and you don't need it
        for (var i = 1; i < min(max_lines, array_length(callstack) - 2); i++) {
            dialog.el_text.text = dialog.el_text.text + string(callstack[i]) + "\n";
        }
        var difference = array_length(callstack) - max_lines - 1;
        if (difference) {
            dialog.el_text.text = dialog.el_text.text + "    (" + string(difference) + " more)";
        }
        
        wtf(string_replace_all(dialog.el_text.text, "\n", " "));
    }
}

function null() { }

function game_auto_title() {
    window_set_caption("DDD Editor - " + (string_length(Stuff.save_name) > 0 ? Stuff.save_name : "(none)"));
}