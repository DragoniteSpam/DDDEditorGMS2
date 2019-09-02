/// @param UIThing

var thing = argument0;

var data = Stuff.all_meshes[| Camera.selection_fill_mesh];

if (data) {
    var fn = get_save_filename("Anything valid|*.d3d;*.gmmod;*.obj|Game Maker model files|*.d3d;*.gmmod|Object files|*.obj", "");

    // @todo try catch
    if (string_length(fn) > 0) {
        switch (filename_ext(fn)) {
            case ".obj": export_obj(fn, data); break;
            case ".d3d": case ".gmmod": export_d3d(fn, data); break;
        }
    }
}