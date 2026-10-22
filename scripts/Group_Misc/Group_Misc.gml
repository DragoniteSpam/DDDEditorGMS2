function instance_destroy_later(what) {
    // if you can't savely destroy anything until the end of the step
    ds_queue_enqueue(Stuff.stuff_to_destroy, what);
}

function not_yet_implemented() {
    // you're only allowed to have one; if more than one are requested at the same time,
    // only the first will be created
    var top = ds_list_top(Stuff.dialogs);
    if (!(top && (top.flags & DialogFlags.IS_EXCEPTION))) {
        var dialog = new EmuDialog(320, 240, "whoops");
        dialog.flags = DialogFlags.IS_EXCEPTION;
        
        var text = new EmuText(32, EMU_AUTO, 320 - 64, "Stack trace requested, probably in lieu of a NotImplementedException. (If you're an end user and seeing this, most of the time this means the developer meant to add a feature and probably forgot.)\n\n");
        dialog.AddContent([text]).AddDefaultCloseButton();
        
        var callstack = debug_get_callstack();
        var max_lines = 9;
        // index 0 is this script, and you don't need it
        for (var i = 1; i < min(max_lines, array_length(callstack) - 2); i++) {
            text.text += string(callstack[i]) + "\n";
        }
        var difference = array_length(callstack) - max_lines - 1;
        if (difference) {
            text.text += "    (" + string(difference) + " more)";
        }
        
        wtf(string_replace_all(text.text, "\n", " "));
        
        return dialog;
    }
}

function null() { }

function game_auto_title() {
    window_set_caption("DDD Editor - " + (string_length(Stuff.save_name) > 0 ? Stuff.save_name : "(none)"));
}