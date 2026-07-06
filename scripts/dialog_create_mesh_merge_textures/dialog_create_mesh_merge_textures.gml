function dialog_create_mesh_merge_textures(list, selection) {
    var dw = 400;
    var dh = 240;
    
    var c1x = 32;
    var c2x = 416;
    
    var ew = 320;
    var eh = 32;
    
    var dialog = new EmuDialog(dw, dh, "Merge textures on meshes");
    dialog.active_shade = 0;
    dialog.list = list;
    dialog.selection = selection;
    
    dialog.AddContent([
        new EmuText(c1x, EMU_AUTO, ew, eh, "Name:"),
        new EmuInput(c1x, EMU_AUTO, ew, eh, "", "NewCombineTexture", "The name of the new texture", 50, E_InputTypes.STRING, emu_null)
            .SetInputBoxPosition(0, 0)
            .SetID("NAME"),
        new EmuText(c1x, EMU_AUTO, ew, eh, "Padding:"),
        new EmuProgressBar(c1x, EMU_AUTO, ew, eh, 8, 0, 8, true, 2, emu_null)
            .SetID("PADDING"),
        new EmuCheckbox(c1x, EMU_AUTO, ew, eh, "Force power of 2?", true, emu_null)
            .SetID("PO2")
    ]);
    
    return dialog.AddDefaultConfirmCancelButtons("Okay", function() {
        var cache_textures_base = { };
        var cache_textures_normal = { };
        var cache_textures_specular_color = { };
        var cache_textures_specular_highlight = { };
        
        var list = self.root.list;
        var selection = self.root.selection;
        
        for (var i = 0, n = array_length(selection); i < n; i++) {
            var mesh = list[selection[i]];
            if (mesh.type == MeshTypes.SMF) return;
            for (var j = 0, n2 = array_length(mesh.submeshes); j < n2; j++) {
                var submesh = mesh.submeshes[j];
                if (submesh.tex_base != NULL) cache_textures_base[$ submesh.tex_base] = true;
                if (submesh.tex_normal != NULL) cache_textures_normal[$ submesh.tex_normal] = true;
                if (submesh.tex_specular_color != NULL) cache_textures_specular_color[$ submesh.tex_specular_color] = true;
                if (submesh.tex_specular_highlight != NULL) cache_textures_specular_highlight[$ submesh.tex_specular_highlight] = true;
            }
        }
        
        var all_textures_base = array_filter(struct_get_names(cache_textures_base), function(key) {
            return key != NULL;
        });
        var remap_input = array_map(all_textures_base, function(key) {
            return guid_get(key).picture;
        });
        
        var remapped = sprite_atlas_pack_dll(remap_input, real(self.GetSibling("PADDING").value), 4, self.GetSibling("PO2").value);
        var new_diffuse_texture = tileset_create_internal(remapped.atlas, self.GetSibling("NAME").value);
        
        var new_w = sprite_get_width(remapped.atlas);
        var new_h = sprite_get_height(remapped.atlas);
        
        var mapping = { };
        for (var i = 0, n = array_length(remapped.uvs); i < n; i++) {
            for (var j = 0, n2 = array_length(all_textures_base); j < n2; j++) {
                if (remapped.uvs[i].sprite == remap_input[j]) {
                    mapping[$ sprite_get_name(remap_input[j])] = remapped.uvs[i];
                    break;
                }
            }
        }
        
        for (var i = 0, n = array_length(selection); i < n; i++) {
            var mesh = list[selection[i]];
            if (mesh.type == MeshTypes.SMF) return;
            for (var j = 0, n2 = array_length(mesh.submeshes); j < n2; j++) {
                var submesh = mesh.submeshes[j];
                
                if (submesh.tex_base != NULL) {
                    var old_map = mapping[$ sprite_get_name(guid_get(submesh.tex_base).picture)];
                    submesh.RemapUVs(old_map.x / new_w, old_map.y / new_h, (old_map.x + old_map.w) / new_w, (old_map.y + old_map.h) / new_h);
                    submesh.tex_base = new_diffuse_texture.GUID;
                }
            }
        }
        
        emu_dialog_close_auto();
    }, "Cancel", emu_dialog_close_auto);
}