// Takes any number of arguments but doesn't do anything, good for when you
// might need a placeholder script. this one also shows the call stack.
// Note: it won't take arguments if called by its name, because it then thinks
// it's supposed to ask for zero arguments. It will take (and eat) arguments
// if called with script_execute, though.

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
    for (var i = 1; i < min(max_lines, array_length_1d(callstack) - 2); i++) {
        dialog.el_text.text = dialog.el_text.text + string(callstack[i]) + "\n";
    }
    var difference = array_length_1d(callstack) - max_lines - 1;
    if (difference) {
        dialog.el_text.text = dialog.el_text.text + "    (" + string(difference) + " more)";
    }
    
    debug(string_replace_all(dialog.el_text.text, "\n", " "));
}