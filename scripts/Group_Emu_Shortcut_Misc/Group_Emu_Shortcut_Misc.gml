function emu_color_meshes(index) {
    var mesh = Game.meshes[index];
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        if (!mesh.submeshes[i].buffer) return c_red;
    }
    switch (mesh.type) {
        case MeshTypes.RAW: return EMU_COLOR_TEXT;
        case MeshTypes.SMF: return c_aqua;
    }
    return EMU_COLOR_TEXT;
}

function emu_color_maps(index) {
    return (Game.meta.start.map == Game.maps[index].GUID) ? c_aqua : EMU_COLOR_LIST_TEXT;
}
