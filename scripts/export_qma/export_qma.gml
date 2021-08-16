function export_qma(fn) {
    var carton = carton_create();
    
    var n_meshes = array_length(Game.meshes);
    var format_index = ui_list_selection(Game.ui_init_mesh.format_list);
    var format = (format_index + 1) ? Stuff.mesh_ed.formats[| format_index] : undefined;
    
    for (var i = 0; i < n_meshes; i++) {
        var mesh = Game.meshes[i];
        for (var j = 0; j < array_length(mesh.submeshes); j++) {
            var submesh = mesh.submeshes[j];
            var vbuff = submesh.GetExportedBuffer(format);
            carton_add(carton, json_stringify({
                name: mesh.name,
                index: j,
            }), vbuff);
            if (vbuff != submesh.buffer) {
                buffer_delete(vbuff);
            }
        }
    }
    
    carton_save(carton, fn, false);
    carton_destroy(carton);
}