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

function emu_bitfield_flags(x, y, element_width, element_height, value, callback, tooltip = "") {
    return (new EmuBitfield(x, y, element_width * 2 / 3, element_height * 48, value, callback))
    .SetOrientation(E_BitfieldOrientations.VERTICAL, 24)
    .AddOptions(array_clone(Game.vars.flags))
    .AddOptions([
        new EmuBitfieldOption("[c_aqua]All", 0x7fffffffffffffff, emu_bitfield_option_callback_exact, emu_bitfield_option_eval_exact),
        new EmuBitfieldOption("[c_aqua]None", 0, emu_bitfield_option_callback_exact, emu_bitfield_option_eval_exact),
    ])
    .SetTooltip(tooltip);
}

function emu_color_data_instances(index) {
    var inst = self.At(index);
    if (inst.flags & DataInstanceFlags.SEPARATOR_VALUE) return c_aqua;
    if (inst.flags & DataInstanceFlags.DEFAULT_VALUE) return c_aqua;
    return c_white;
}