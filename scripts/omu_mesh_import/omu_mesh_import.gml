/// @param UIThing

var thing = argument0;

var fn = get_open_filename_mesh();

// @todo try catch
if (file_exists(fn)) {
    switch (filename_ext(fn)) {
        case ".obj": import_obj(fn); break;
        case ".d3d": case ".gmmod": import_d3d(fn); break;
        case ".vrax": import_vrax(fn); break;
        case ".smf": import_smf(fn); break;
    }
}