function emu_dialog_notice(message, dw = 420, dh = 240) {
    var b_width = 128;
    var b_height = 32;
    
    var el_text = new EmuText(32, 32, dw - 64, dh - 64 - b_height, message);
    el_text.alignment = fa_center;
    el_text.valignment = fa_middle;
    
    var el_button = new EmuButton(dw / 2 - b_width / 2, dh - 32 - b_height / 2, b_width, b_height, "okay", function() {
        self.root.Dispose();
    });
    var dg = new EmuDialog(dw, dh, "Hey, listen!");
    dg.AddContent([el_text, el_button]);
    dg.el_text = el_text;
    dg.el_button = el_button;
    
    return dg;
}

function emu_dialog_confirm(root, message, action_confirm, caption_message = "Important!", confirm_message = "yeah!", cancel_message = "nope", action_cancel = function() { self.root.Dispose(); }) {
    var dw = 480;
    var dh = 240;
    var b_width = 128;
    var b_height = 32;
    
    var dialog = new EmuDialog(dw, dh, caption_message);
    dialog.root = root;
    
    dialog.AddContent([
        (new EmuText(32, EMU_AUTO, dw - 64, dh - 64 - b_height, message))
            .SetAlignment(fa_center, fa_middle)
    ]).AddDefaultConfirmCancelButtons(confirm_message, action_confirm, cancel_message, action_cancel);
    
    return dialog;
}

function emu_dialog_vertex_format(value, callback) {
    var dw = 680;
    var dh = 480;
    var c1x = 32;
    var c2x = 352;
    
    var dialog = new EmuDialog(dw, dh, "Vertex format attributes");
    dialog.value = value;
    dialog.cb = callback;
    dialog.AddContent([
        new EmuText(c1x, 32, 256, 32, "[c_aqua]Standards attributes"),
        (new EmuCheckbox(c1x, EMU_AUTO, 256, 32, "Position", !!(value & VertexFormatData.POSITION_3D), function() {
            self.root.value &= ~VertexFormatData.POSITION_3D;
            if (self.value) self.root.value |= VertexFormatData.POSITION_3D;
            self.root.cb(self.root.value);
        })).SetInteractive(false),
        new EmuCheckbox(c1x, EMU_AUTO, 256, 32, "Normal", !!(value & VertexFormatData.NORMAL), function() {
            self.root.value &= ~VertexFormatData.NORMAL;
            if (self.value) self.root.value |= VertexFormatData.NORMAL;
            self.root.cb(self.root.value);
        }),
        new EmuCheckbox(c1x, EMU_AUTO, 256, 32, "Texture", !!(value & VertexFormatData.TEXCOORD), function() {
            self.root.value &= ~VertexFormatData.TEXCOORD;
            if (self.value) self.root.value |= VertexFormatData.TEXCOORD;
            self.root.cb(self.root.value);
        }),
        new EmuCheckbox(c1x, EMU_AUTO, 256, 32, "Color", !!(value & VertexFormatData.COLOUR), function() {
            self.root.value &= ~VertexFormatData.COLOUR;
            if (self.value) self.root.value |= VertexFormatData.COLOUR;
            self.root.cb(self.root.value);
        }),
        new EmuCheckbox(c1x, EMU_AUTO, 256, 32, "Tangent", !!(value & VertexFormatData.TANGENT), function() {
            self.root.value &= ~VertexFormatData.TANGENT;
            if (self.value) self.root.value |= VertexFormatData.TANGENT;
            self.root.cb(self.root.value);
        }),
        new EmuCheckbox(c1x, EMU_AUTO, 256, 32, "Bitangent", !!(value & VertexFormatData.BITANGENT), function() {
            self.root.value &= ~VertexFormatData.BITANGENT;
            if (self.value) self.root.value |= VertexFormatData.BITANGENT;
            self.root.cb(self.root.value);
        }),
        new EmuCheckbox(c1x, EMU_AUTO, 256, 32, "Barycentric", !!(value & VertexFormatData.BARYCENTRIC), function() {
            self.root.value &= ~VertexFormatData.BARYCENTRIC;
            if (self.value) self.root.value |= VertexFormatData.BARYCENTRIC;
            self.root.cb(self.root.value);
        }),
        
        new EmuText(c2x, 32, 256, 32, "[c_aqua]Nonstandard attributes"),
        new EmuCheckbox(c2x, EMU_AUTO, 256, 32, "Small normal", !!(value & VertexFormatData.SMALL_NORMAL), function() {
            self.root.value &= ~VertexFormatData.SMALL_NORMAL;
            if (self.value) self.root.value |= VertexFormatData.SMALL_NORMAL;
            self.root.cb(self.root.value);
        }),
        new EmuCheckbox(c2x, EMU_AUTO, 256, 32, "Small tangent", !!(value & VertexFormatData.SMALL_TANGENT), function() {
            self.root.value &= ~VertexFormatData.SMALL_TANGENT;
            if (self.value) self.root.value |= VertexFormatData.SMALL_TANGENT;
            self.root.cb(self.root.value);
        }),
        new EmuCheckbox(c2x, EMU_AUTO, 256, 32, "Small bitangent", !!(value & VertexFormatData.SMALL_BITANGENT), function() {
            self.root.value &= ~VertexFormatData.SMALL_BITANGENT;
            if (self.value) self.root.value |= VertexFormatData.SMALL_BITANGENT;
            self.root.cb(self.root.value);
        }),
        new EmuCheckbox(c2x, EMU_AUTO, 256, 32, "Small texcoord", !!(value & VertexFormatData.SMALL_TEXCOORD), function() {
            self.root.value &= ~VertexFormatData.SMALL_TEXCOORD;
            if (self.value) self.root.value |= VertexFormatData.SMALL_TEXCOORD;
            self.root.cb(self.root.value);
        }),
        new EmuCheckbox(c2x, EMU_AUTO, 256, 32, "Small normal plus palette", !!(value & VertexFormatData.SMALL_NORMAL_PLUS_PALETTE), function() {
            self.root.value &= ~VertexFormatData.SMALL_NORMAL_PLUS_PALETTE;
            if (self.value) self.root.value |= VertexFormatData.SMALL_NORMAL_PLUS_PALETTE;
            self.root.cb(self.root.value);
        }),
        new EmuCheckbox(c2x, EMU_AUTO, 256, 32, "Small barycentric", !!(value & VertexFormatData.SMALL_BARYCENTIRC), function() {
            self.root.value &= ~VertexFormatData.SMALL_BARYCENTIRC;
            if (self.value) self.root.value |= VertexFormatData.SMALL_BARYCENTIRC;
            self.root.cb(self.root.value);
        }),
    ]).AddDefaultCloseButton("Done");
    
    return dialog;
}
