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
    var dh = 512;
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
            self.root.Refresh();
        })).SetInteractive(false),
        new EmuCheckbox(c1x, EMU_AUTO, 256, 32, "Normal", !!(value & VertexFormatData.NORMAL), function() {
            self.root.value &= ~VertexFormatData.NORMAL;
            if (self.value) self.root.value |= VertexFormatData.NORMAL;
            self.root.cb(self.root.value);
            self.root.Refresh();
        }),
        new EmuCheckbox(c1x, EMU_AUTO, 256, 32, "Texture", !!(value & VertexFormatData.TEXCOORD), function() {
            self.root.value &= ~VertexFormatData.TEXCOORD;
            if (self.value) self.root.value |= VertexFormatData.TEXCOORD;
            self.root.cb(self.root.value);
            self.root.Refresh();
        }),
        new EmuCheckbox(c1x, EMU_AUTO, 256, 32, "Color", !!(value & VertexFormatData.COLOUR), function() {
            self.root.value &= ~VertexFormatData.COLOUR;
            if (self.value) self.root.value |= VertexFormatData.COLOUR;
            self.root.cb(self.root.value);
            self.root.Refresh();
        }),
        new EmuCheckbox(c1x, EMU_AUTO, 256, 32, "Tangent", !!(value & VertexFormatData.TANGENT), function() {
            self.root.value &= ~VertexFormatData.TANGENT;
            if (self.value) self.root.value |= VertexFormatData.TANGENT;
            self.root.cb(self.root.value);
            self.root.Refresh();
        }),
        new EmuCheckbox(c1x, EMU_AUTO, 256, 32, "Bitangent", !!(value & VertexFormatData.BITANGENT), function() {
            self.root.value &= ~VertexFormatData.BITANGENT;
            if (self.value) self.root.value |= VertexFormatData.BITANGENT;
            self.root.cb(self.root.value);
            self.root.Refresh();
        }),
        new EmuCheckbox(c1x, EMU_AUTO, 256, 32, "Barycentric", !!(value & VertexFormatData.BARYCENTRIC), function() {
            self.root.value &= ~VertexFormatData.BARYCENTRIC;
            if (self.value) self.root.value |= VertexFormatData.BARYCENTRIC;
            self.root.cb(self.root.value);
            self.root.Refresh();
        }),
        
        new EmuText(c2x, 32, 256, 32, "[c_aqua]Nonstandard attributes"),
        new EmuCheckbox(c2x, EMU_AUTO, 256, 32, "Small normal", !!(value & VertexFormatData.SMALL_NORMAL), function() {
            self.root.value &= ~VertexFormatData.SMALL_NORMAL;
            if (self.value) self.root.value |= VertexFormatData.SMALL_NORMAL;
            self.root.cb(self.root.value);
            self.root.Refresh();
        }),
        new EmuCheckbox(c2x, EMU_AUTO, 256, 32, "Small tangent", !!(value & VertexFormatData.SMALL_TANGENT), function() {
            self.root.value &= ~VertexFormatData.SMALL_TANGENT;
            if (self.value) self.root.value |= VertexFormatData.SMALL_TANGENT;
            self.root.cb(self.root.value);
            self.root.Refresh();
        }),
        new EmuCheckbox(c2x, EMU_AUTO, 256, 32, "Small bitangent", !!(value & VertexFormatData.SMALL_BITANGENT), function() {
            self.root.value &= ~VertexFormatData.SMALL_BITANGENT;
            if (self.value) self.root.value |= VertexFormatData.SMALL_BITANGENT;
            self.root.cb(self.root.value);
            self.root.Refresh();
        }),
        new EmuCheckbox(c2x, EMU_AUTO, 256, 32, "Small texcoord", !!(value & VertexFormatData.SMALL_TEXCOORD), function() {
            self.root.value &= ~VertexFormatData.SMALL_TEXCOORD;
            if (self.value) self.root.value |= VertexFormatData.SMALL_TEXCOORD;
            self.root.cb(self.root.value);
            self.root.Refresh();
        }),
        new EmuCheckbox(c2x, EMU_AUTO, 256, 32, "Small normal plus palette", !!(value & VertexFormatData.SMALL_NORMAL_PLUS_PALETTE), function() {
            self.root.value &= ~VertexFormatData.SMALL_NORMAL_PLUS_PALETTE;
            if (self.value) self.root.value |= VertexFormatData.SMALL_NORMAL_PLUS_PALETTE;
            self.root.cb(self.root.value);
            self.root.Refresh();
        }),
        new EmuCheckbox(c2x, EMU_AUTO, 256, 32, "Small barycentric", !!(value & VertexFormatData.SMALL_BARYCENTIRC), function() {
            self.root.value &= ~VertexFormatData.SMALL_BARYCENTIRC;
            if (self.value) self.root.value |= VertexFormatData.SMALL_BARYCENTIRC;
            self.root.cb(self.root.value);
            self.root.Refresh();
        }),
        (new EmuText(c2x, EMU_AUTO, 256, 32, "Mask:"))
            .SetRefresh(function() {
                self.text = "Mask: " + string(ptr(self.root.value));
            }),
        (new EmuText(c2x, EMU_AUTO, 256, 32, "Vertex size:"))
            .SetRefresh(function() {
                var bytes = 0;
                var value = self.root.value;
                if (!!(value & VertexFormatData.POSITION_3D)) bytes += 12;
                if (!!(value & VertexFormatData.POSITION_2D)) bytes += 8;
                if (!!(value & VertexFormatData.NORMAL)) bytes += 12;
                if (!!(value & VertexFormatData.TEXCOORD)) bytes += 8;
                if (!!(value & VertexFormatData.COLOUR)) bytes += 4;
                if (!!(value & VertexFormatData.TANGENT)) bytes += 8;
                if (!!(value & VertexFormatData.BITANGENT)) bytes += 8;
                if (!!(value & VertexFormatData.BARYCENTRIC)) bytes += 8;
                if (!!(value & VertexFormatData.SMALL_NORMAL)) bytes += 4;
                if (!!(value & VertexFormatData.SMALL_TANGENT)) bytes += 4;
                if (!!(value & VertexFormatData.SMALL_BITANGENT)) bytes += 4;
                if (!!(value & VertexFormatData.SMALL_NORMAL_PLUS_PALETTE)) bytes += 4;
                if (!!(value & VertexFormatData.SMALL_BARYCENTIRC)) bytes += 4;
                
                self.text = "Vertex size: " + string(bytes) + " bytes";
            }),
    ]).AddDefaultCloseButton("Done").Refresh();
    
    return dialog;
}

function emu_dialog_get_event(default_entrypoint, callback, data) {
    var col1 = 32;
    var col2 = 32 + 320 + 32;
            
    var dialog = (new EmuDialog(32 + 320 + 32 + 320 + 32, 640, "Select an event graph...")).AddContent([
        (new EmuList(col1, EMU_BASE, 320, 32, "Events:", 32, 16, function() {
            if (self.root) self.root.Refresh(self.GetSelectedItem());
        }))
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetList(Game.events.events)
            .Select(array_search(Game.events.events, default_entrypoint ? default_entrypoint.event : undefined))
            .SetID("LIST")
            .SetTooltip("Select an event graph."),
        (new EmuList(col2, EMU_BASE, 320, 32, "Entrypoint:", 32, 16, function() {
            var selection = self.GetSelectedItem();
                    
            // ...
        }))
            .SetList(default_entrypoint ? default_entrypoint.event.nodes : [])
            .Select(default_entrypoint ? array_search(default_entrypoint.event.nodes, default_entrypoint) : -1)
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetRefresh(function(data) {
                self.Deselect();
                if (!data) {
                    self.SetList([]);
                    return;
                }
                var entrypoints = [];
                for (var i = 0, n = array_length(data.nodes); i < n; i++) {
                    if (data.nodes[i].type == EventNodeTypes.ENTRYPOINT) {
                        array_push(entrypoints, data.nodes[i]);
                    }
                }
                self.SetList(entrypoints);
            })
            .SetTooltip("Select an entrypoint within the event graph.")
            .SetID("ENTRYPOINTS"),
    ]).AddDefaultConfirmCancelButtons("Done", function() {
        method(self, self.root.cb)();
        emu_dialog_close_auto();
    }, "Cancel", emu_dialog_close_auto);
    dialog.data = data;
    dialog.cb = callback;
}
