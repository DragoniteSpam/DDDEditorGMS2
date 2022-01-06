/// @param UIInputCode
function omu_edit_code(argument0) {

    var code = argument0;

    var location = code.is_code ? get_temp_code_path(code) : get_temp_text_path(code);
    buffer_write_file(code.value, location);

    emu_dialog_notice("The \"open\" command is temporarily unavailable. I might bring it back some other time if it's really needed. Sorry!");


}
