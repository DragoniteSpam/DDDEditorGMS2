function emu_dialog_vertex_format(value, callback) {
    var dw = 680;
    var dh = 480;
    var c1x = 32;
    var c2x = 352;
    
    var dialog = new EmuDialog(dw, dh, "Vertex format attributes");
    dialog.value = value;
    dialog.cb = callback;
    dialog.AddContent([
        new EmuText(c1x, 32, 256, 32, "[c_blue]Standards attributes"),
        (new EmuCheckbox(c1x, EMU_AUTO, 256, 32, "Position", !!(value & (1 << VertexFormatData.POSITION_3D)), function() {
            var flag = 1 << VertexFormatData.POSITION_3D;
            self.root.value &= ~flag;
            if (self.value) self.root.value |= flag;
            self.root.cb(self.root.value);
        })).SetInteractive(false),
        new EmuCheckbox(c1x, EMU_AUTO, 256, 32, "Normal", !!(value & (1 << VertexFormatData.NORMAL)), function() {
            var flag = 1 << VertexFormatData.NORMAL;
            self.root.value &= ~flag;
            if (self.value) self.root.value |= flag;
            self.root.cb(self.root.value);
        }),
        new EmuCheckbox(c1x, EMU_AUTO, 256, 32, "Texture", !!(value & (1 << VertexFormatData.TEXCOORD)), function() {
            var flag = 1 << VertexFormatData.TEXCOORD;
            self.root.value &= ~flag;
            if (self.value) self.root.value |= flag;
            self.root.cb(self.root.value);
        }),
        new EmuCheckbox(c1x, EMU_AUTO, 256, 32, "Color", !!(value & (1 << VertexFormatData.COLOUR)), function() {
            var flag = 1 << VertexFormatData.COLOUR;
            self.root.value &= ~flag;
            if (self.value) self.root.value |= flag;
            self.root.cb(self.root.value);
        }),
        new EmuCheckbox(c1x, EMU_AUTO, 256, 32, "Tangent", !!(value & (1 << VertexFormatData.TANGENT)), function() {
            var flag = 1 << VertexFormatData.TANGENT;
            self.root.value &= ~flag;
            if (self.value) self.root.value |= flag;
            self.root.cb(self.root.value);
        }),
        new EmuCheckbox(c1x, EMU_AUTO, 256, 32, "Bitangent", !!(value & (1 << VertexFormatData.BITANGENT)), function() {
            var flag = 1 << VertexFormatData.BITANGENT;
            self.root.value &= ~flag;
            if (self.value) self.root.value |= flag;
            self.root.cb(self.root.value);
        }),
        new EmuCheckbox(c1x, EMU_AUTO, 256, 32, "Barycentric", !!(value & (1 << VertexFormatData.BARYCENTRIC)), function() {
            var flag = 1 << VertexFormatData.BARYCENTRIC;
            self.root.value &= ~flag;
            if (self.value) self.root.value |= flag;
            self.root.cb(self.root.value);
        }),
        
        new EmuText(c2x, 32, 256, 32, "[c_blue]Nonstandard attributes"),
        new EmuCheckbox(c2x, EMU_AUTO, 256, 32, "Small normal", !!(value & (1 << VertexFormatData.SMALL_NORMAL)), function() {
            var flag = 1 << VertexFormatData.SMALL_NORMAL;
            self.root.value &= ~flag;
            if (self.value) self.root.value |= flag;
            self.root.cb(self.root.value);
        }),
        new EmuCheckbox(c2x, EMU_AUTO, 256, 32, "Small tangent", !!(value & (1 << VertexFormatData.SMALL_TANGENT)), function() {
            var flag = 1 << VertexFormatData.SMALL_TANGENT;
            self.root.value &= ~flag;
            if (self.value) self.root.value |= flag;
            self.root.cb(self.root.value);
        }),
        new EmuCheckbox(c2x, EMU_AUTO, 256, 32, "Small bitangent", !!(value & (1 << VertexFormatData.SMALL_BITANGENT)), function() {
            var flag = 1 << VertexFormatData.SMALL_BITANGENT;
            self.root.value &= ~flag;
            if (self.value) self.root.value |= flag;
            self.root.cb(self.root.value);
        }),
        new EmuCheckbox(c2x, EMU_AUTO, 256, 32, "Small texcoord", !!(value & (1 << VertexFormatData.SMALL_TEXCOORD)), function() {
            var flag = 1 << VertexFormatData.SMALL_TEXCOORD;
            self.root.value &= ~flag;
            if (self.value) self.root.value |= flag;
            self.root.cb(self.root.value);
        }),
        new EmuCheckbox(c2x, EMU_AUTO, 256, 32, "Small normal plus palette", !!(value & (1 << VertexFormatData.SMALL_NORMAL_PLUS_PALETTE)), function() {
            var flag = 1 << VertexFormatData.SMALL_NORMAL_PLUS_PALETTE;
            self.root.value &= ~flag;
            if (self.value) self.root.value |= flag;
            self.root.cb(self.root.value);
        }),
        new EmuCheckbox(c2x, EMU_AUTO, 256, 32, "Small barycentric", !!(value & (1 << VertexFormatData.SMALL_BARYCENTIRC)), function() {
            var flag = 1 << VertexFormatData.SMALL_BARYCENTIRC;
            self.root.value &= ~flag;
            if (self.value) self.root.value |= flag;
            self.root.cb(self.root.value);
        }),
    ]).AddDefaultCloseButton("Done");
    
    return dialog;
}