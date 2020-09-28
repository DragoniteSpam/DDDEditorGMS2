/// @param Dialog
/// @param [force?]
function dc_close_no_questions_asked() {
    // closes the dialog without any questions. [force?] is just
    // a formality to keep game maker from exploding, it doesn't
    // currently do anything. don't use this if it may not be safe
    // to close the dialog because bad things might happen.

    // this is for the "x" button on dialogs. if you want to attach
    // this to the "okay" button at the bottom, use the dmu_ version.

    var dialog = argument[0];
    var force = (argument_count > 1) ? argument[1] : false;

    dialog_destroy();


}
