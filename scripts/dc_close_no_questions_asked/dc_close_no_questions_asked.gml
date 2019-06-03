/// @description void dc_close_no_questions_asked(Dialog, [force?]);
/// @param Dialog
/// @param [force?]
// closes the dialog without any questions. [force?] is just
// a formality to keep game maker from exploding, it doesn't
// actually do anything. don't use this if it may not be safe
// to close the dialog because bad things might happen.

// this is for the "x" button on dialogs. if you want to attach
// this to the "okay" button at the bottom, use the dmu_ version.

var dialog=argument[0];
switch (argument_count) {
    case 2:
        var force=argument[1];
}

dialog_destroy();
