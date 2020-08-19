/// @description spart_type_load(partSystem, fname)
/// @param partSystem
/// @param fname
function spart_type_load(argument0, argument1) {
    /*
        Loads a particle type from a file

        Script created by TheSnidr
        www.thesnidr.com
    */
    var partSystem = argument0;
    var fname = argument1;
    var loadBuff = buffer_load(fname);
    var partType = spart__read_type_from_buffer(loadBuff, partSystem);
    buffer_delete(loadBuff);
    return partType;


}
