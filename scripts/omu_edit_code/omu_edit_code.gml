/// @param UIInputCode
function omu_edit_code(argument0) {

    var code = argument0;

    var location = code.is_code ? get_temp_code_path(code) : get_temp_text_path(code);
    buffer_write_file(code.value, location);

    code.editor_handle = ds_stuff_open_local(location);


}
