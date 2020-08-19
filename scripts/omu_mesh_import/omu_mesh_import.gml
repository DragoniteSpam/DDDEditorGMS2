/// @param UIThing
function omu_mesh_import(argument0) {

    var thing = argument0;
    var fn = get_open_filename_mesh();

    // @todo try catch
    if (file_exists(fn)) {
        switch (filename_ext(fn)) {
            case ".obj": import_obj(fn, undefined); break;
            case ".d3d": case ".gmmod": import_d3d(fn, undefined); break;
            case ".vrax": import_vrax(fn); break;
            case ".smf": import_smf(fn); break;
            case ".qma": import_qma(fn); break;
            case ".dae": import_dae(fn); break;
        }
    }


}
