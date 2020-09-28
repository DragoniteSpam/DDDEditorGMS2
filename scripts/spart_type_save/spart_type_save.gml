/// @description spart_type_save(partType, fname)
/// @param partType
/// @param fname
function spart_type_save(argument0, argument1) {
    /*
        Saves a particle type to a file

        Script created by TheSnidr
        www.thesnidr.com
    */
    var partType = argument0;
    var fname = argument1;
    var saveBuff = buffer_create(1, buffer_grow, 1);
    spart__write_type_to_buffer(saveBuff, partType, 0);
    buffer_save(saveBuff, fname);
    buffer_delete(saveBuff);


}
