/// @param UIThing

var thing = argument0;

var fn = get_open_filename("Anything valid|*.d3d;*.gmmod;*.obj;*.vrax|Game Maker model files|*.d3d;*.gmmod|Object files|*.obj|drago's old file format|*.vrax", "");

// @todo try catch
if (file_exists(fn)) {
    switch (filename_ext(fn)) {
        case ".obj": import_obj(fn); break;
        case ".d3d": case ".gmmod": import_d3d(fn); break;
        case ".vrax": import_vrax(fn); break;
    }
}