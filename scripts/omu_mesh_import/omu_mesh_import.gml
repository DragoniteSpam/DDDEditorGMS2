/// @param UIThing

var thing = argument0;

var adjust = !keyboard_check(vk_control);

var fn = get_open_filename_mesh();

// @todo try catch
if (file_exists(fn)) {
    switch (filename_ext(fn)) {
        case ".obj": import_obj(fn, undefined, adjust); break;
        case ".d3d": case ".gmmod": import_d3d(fn, undefined, adjust); break;
        case ".vrax": import_vrax(fn); break;
        case ".smf": import_smf(fn); break;
        case ".qma": import_qma(fn); break;
    }
}