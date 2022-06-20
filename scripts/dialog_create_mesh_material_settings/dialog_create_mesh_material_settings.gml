function dialog_create_mesh_material_settings(mesh_list, selection) {
    static find_tileset_index = function(list, selected_things, accessor) {
        var target_index = -1;
        for (var i = 0, n = array_length(selected_things); i < n; i++) {
            var mesh = list[selected_things[i]];
            var data = guid_get(accessor(mesh));
            if (!data) return -1;
            var mesh_texture_index = array_search(Game.graphics.tilesets, data);
            if (target_index == -1) {
                target_index = mesh_texture_index;
            } else if (target_index != mesh_texture_index) {
                return -1;
            }
        }
        return target_index;
    };
    
    static find_tileset_index_submesh = function(submesh, accessor) {
        var data = guid_get(accessor(submesh));
        if (!data) return -1;
        return array_search(Game.graphics.tilesets, data);
    };
    
    // if you have multiple meshes selected or your mesh only has a single
    // submesh, skip the submesh list
    var default_mesh_tex_only = (array_length(selection) > 1) || ((array_length(selection) == 1) && array_length(mesh_list[selection[0]].submeshes) == 1) || (mesh_list == Game.mesh_terrain);
    
    var id_base = find_tileset_index(mesh_list, selection, function(thing) { return thing.tex_base; });
    var id_normal = find_tileset_index(mesh_list, selection, function(thing) { return thing.tex_normal; });
    var id_ambient = find_tileset_index(mesh_list, selection, function(thing) { return thing.tex_ambient; });
    var id_specular_color = find_tileset_index(mesh_list, selection, function(thing) { return thing.tex_specular_color; });
    var id_specular_highlight = find_tileset_index(mesh_list, selection, function(thing) { return thing.tex_specular_highlight; });
    var id_alpha = find_tileset_index(mesh_list, selection, function(thing) { return thing.tex_alpha; });
    var id_bump = find_tileset_index(mesh_list, selection, function(thing) { return thing.tex_bump; });
    var id_displacement = find_tileset_index(mesh_list, selection, function(thing) { return thing.tex_displacement; });
    var id_decal = find_tileset_index(mesh_list, selection, function(thing) { return thing.tex_stencil; });
    
    var dg = new EmuDialog((default_mesh_tex_only ? 0 : (32 + 320)) + 32 + 320 + 32 + 32 + 32, 640, "Materials");
    dg.list = mesh_list;
    dg.selection = selection;
    dg.default_mesh_tex_only = default_mesh_tex_only;
    dg.active_shade = false;
    
    dg.find_tileset_index = find_tileset_index;
    dg.find_tileset_index_submesh = find_tileset_index_submesh;
    
    var ew = 320;
    var eh = 32;
    var col1 = 32;
    var col2 = 32 + 320 + 32;
    
    if (!default_mesh_tex_only) {
        dg.AddContent([
            new EmuText(col1, EMU_AUTO, ew, eh * 2,
                "Select material properties for the mesh as \n" +
                "a whole, or set [c_aqua]overrides[/c] for individual \n" +
                "submeshes."
            ),
            (new EmuList(col1, EMU_AUTO, ew, eh, "Submesh Override:", eh, 12, function() {
                if (!self.root) return;
                self.root.Refresh();
            }))
                .SetList(mesh_list[selection[0]].submeshes)
                .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                .SetID("SUBMESHES"),
            (new EmuButton(col1, EMU_AUTO, ew, eh, "Base Mesh", function() {
                self.GetSibling("SUBMESHES").Deselect();
            }))
        ]);
    }
    
    var tab_base = new EmuTab("Diffuse");
    var tab_normal = new EmuTab("Normal Map").SetInteractive(false);
    var tab_ambient = new EmuTab("Ambient Map").SetInteractive(false);
    var tab_specular_color = new EmuTab("Specular Color").SetInteractive(false);
    var tab_specular = new EmuTab("Specular Map").SetInteractive(false);
    var tab_alpha = new EmuTab("Alpha Map").SetInteractive(false);
    var tab_bump = new EmuTab("Bump Map").SetInteractive(false);
    var tab_displacement = new EmuTab("Displacement Map").SetInteractive(false);
    var tab_stencil = new EmuTab("Stencil Map").SetInteractive(false);
    
    var tabs = new EmuTabGroup(default_mesh_tex_only ? col1 : col2, EMU_BASE, ew + 32 + 32, dg.height - 96, 2, eh);
    tabs.AddTabs(0, [tab_base, tab_ambient, tab_specular_color, tab_specular]);
    tabs.AddTabs(1, [tab_alpha, tab_bump, tab_displacement, tab_stencil]);
    tabs.RequestActivateTab(tab_base);
    dg.AddContent(tabs);
    
    var callback_set_map_to_selection = function() {
        var new_tex = self.GetSelectedItem() ? self.GetSelectedItem().GUID : NULL;
        var dialog = self.root/*tab*/.root/*tag group*/.root/*dialog*/;
        if (dialog.default_mesh_tex_only || (dialog.GetChild("SUBMESHES") && !dialog.GetChild("SUBMESHES").GetSelectedItem())) {
            for (var i = 0, n = array_length(dialog.selection); i < n; i++) {
                self.callback_set_texture(dialog.list[real(dialog.selection[i])], new_tex);
            }
        } else {
            self.callback_set_texture(dialog.GetChild("SUBMESHES").GetSelectedItem(), new_tex);
        }
    };
    
    var texture_list_general = function(x, ew, eh, name, callback_set_map_to_selection, callback_set_texture, callback_get_texture, default_selection) {
        var n_list_entries = 12;
        
        var list = new EmuList(x, EMU_AUTO, ew, eh, name, eh, n_list_entries, callback_set_map_to_selection);
        list.callback_set_texture = callback_set_texture;
        list.callback_get_texture = callback_get_texture;
        list.SetList(Game.graphics.tilesets)
        list.SetEntryTypes(E_ListEntryTypes.STRUCTS);
        list.SelectNoCallback(default_selection, true);
        list.SetRefresh(function() {
            self.DeselectNoCallback();
            var dialog = self.root/*tab*/.root/*tag group*/.root/*dialog*/;
            if (dialog.default_mesh_tex_only || (dialog.GetChild("SUBMESHES") && !dialog.GetChild("SUBMESHES").GetSelectedItem())) {
                self.SelectNoCallback(dialog.find_tileset_index(dialog.list, dialog.selection, self.callback_get_texture), true);
            } else {
                self.SelectNoCallback(dialog.find_tileset_index_submesh(dialog.GetChild("SUBMESHES").GetSelectedItem(), self.callback_get_texture), true);
            }
        });
        
        return list;
    };
    
    tab_base.AddContent(texture_list_general(col1, ew, eh, "Textures:", callback_set_map_to_selection, function(mesh, tex) { mesh.tex_base = tex; }, function(thing) { return thing.tex_base; }, id_base));
    tab_normal.AddContent(texture_list_general(col1, ew, eh, "Normal map:", callback_set_map_to_selection, function(mesh, tex) { mesh.tex_normal = tex; }, function(thing) { return thing.tex_normal; }, id_normal));
    tab_ambient.AddContent(texture_list_general(col1, ew, eh, "Ambient map:", callback_set_map_to_selection, function(mesh, tex) { mesh.tex_ambient = tex; }, function(thing) { return thing.tex_ambient; }, id_specular_color));
    tab_specular_color.AddContent(texture_list_general(col1, ew, eh, "Specular color:", callback_set_map_to_selection, function(mesh, tex) { mesh.tex_specular_color = tex; }, function(thing) { return thing.tex_specular_color; }, id_specular_color));
    tab_specular.AddContent(texture_list_general(col1, ew, eh, "Specular highlight map:", callback_set_map_to_selection, function(mesh, tex) { mesh.tex_specular_highlight = tex; }, function(thing) { return thing.tex_specular_highlight; }, id_specular_highlight));
    tab_alpha.AddContent(texture_list_general(col1, ew, eh, "Alpha map:", callback_set_map_to_selection, function(mesh, tex) { mesh.tex_alpha = tex; }, function(thing) { return thing.tex_alpha; }, id_alpha));
    tab_bump.AddContent(texture_list_general(col1, ew, eh, "Bump map:", callback_set_map_to_selection, function(mesh, tex) { mesh.tex_bump = tex; }, function(thing) { return thing.tex_bump; }, id_bump));
    tab_displacement.AddContent(texture_list_general(col1, ew, eh, "Displacement map:", callback_set_map_to_selection, function(mesh, tex) { mesh.tex_displacement = tex; }, function(thing) { return thing.tex_displacement; }, id_displacement));
    tab_stencil.AddContent(texture_list_general(col1, ew, eh, "Stencil map:", callback_set_map_to_selection, function(mesh, tex) { mesh.tex_stencil = tex; }, function(thing) { return thing.tex_stencil; }, id_decal));
    
    return dg.AddDefaultCloseButton();
}