/// @param UIButton
function ui_particle_copy_code(argument0) {

    var button = argument0;

    clipboard_set_text(editor_particle_generate_code());
    (dialog_create_notice(noone, "Code has been copied to the clipboard!")).active_shade = false;


}
