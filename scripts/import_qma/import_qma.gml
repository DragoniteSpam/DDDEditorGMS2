function import_qma(filename, adjust) {
    if (adjust == undefined) adjust = true;
    
    try {
        var buffer = buffer_load(filename);
        var data = json_parse(buffer_read(buffer, buffer_string));
        var version = data.version;
        var n = buffer_read(buffer, buffer_u32);
        repeat (n) {
            ds_list_add(Stuff.all_meshes, import_qma_next(buffer, version));
        }
        buffer_delete(buffer);
    } catch (e) {
        emu_dialog_notice("Could not import QMA - " + e.message);
    }
}