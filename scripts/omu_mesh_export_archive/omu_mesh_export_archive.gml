/// @param UIThing
function omu_mesh_export_archive(argument0) {

    var thing = argument0;

    var fn = get_save_filename_mesh_qma("");

    // @todo try catch
    if (string_length(fn) > 0) {
        export_qma(fn);
    }


}
