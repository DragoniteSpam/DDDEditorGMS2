function dialog_create_mesh_material_settings(mesh_list, selection) {
    static find_tileset_index = function(list, selected_things, accessor) {
        var target_index = -1;
        for (var i = 0, n = array_length(selected_things); i < n; i++) {
            var mesh = list[selected_things[i]];
            var mesh_texture_index = array_search(Game.graphics.tilesets, guid_get(accessor(mesh)));
            if (target_index == -1) {
                target_index = mesh_texture_index;
            } else if (target_index != mesh_texture_index) {
                return -1;
            }
        }
        return target_index;
    };
    
    static find_tileset_index_submesh = function(submesh, accessor) {
        return array_search(Game.graphics.tilesets, guid_get(accessor(submesh)));
    };
    
    // if you have multiple meshes selected or your mesh only has a single
    // submesh, skip the submesh list
    var default_mesh_tex_only = (array_length(selection) > 1) || ((array_length(selection) == 1) && array_length(mesh_list[selection[0]].submeshes) == 1) || (mesh_list == Game.mesh_terrain);
    
    var id_base = find_tileset_index(mesh_list, selection, function(thing) { return thing.tex_base; });
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
    
    var n_list_entries = 12;
    
    var tab_base = new EmuTab("Diffuse");
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
    
    var list = new EmuList(col1, EMU_AUTO, ew, eh, "Textures:", eh, n_list_entries, callback_set_map_to_selection);
    tab_base.AddContent(list);
    list.callback_set_texture = function(mesh, tex) { mesh.tex_base = tex; };
    list.SetList(Game.graphics.tilesets)
    list.SetEntryTypes(E_ListEntryTypes.STRUCTS);
    list.SelectNoCallback(id_base, true);
    list.SetRefresh(function() {
        self.DeselectNoCallback();
        var dialog = self.root/*tab*/.root/*tag group*/.root/*dialog*/;
        if (dialog.default_mesh_tex_only || (dialog.GetChild("SUBMESHES") && !dialog.GetChild("SUBMESHES").GetSelectedItem())) {
            self.SelectNoCallback(dialog.find_tileset_index(dialog.list, dialog.selection, function(thing) { return thing.tex_base; }));
        } else {
            self.SelectNoCallback(dialog.find_tileset_index_submesh(dialog.GetChild("SUBMESHES").GetSelectedItem(), function(thing) { return thing.tex_base; }));
        }
    });
    
    list = new EmuList(col1, EMU_AUTO, ew, eh, "Ambient map:", eh, n_list_entries, callback_set_map_to_selection);
    tab_ambient.AddContent(list);
    list.callback_set_texture = function(mesh, tex) { mesh.tex_ambient = tex; };
    list.SetList(Game.graphics.tilesets);
    list.SetEntryTypes(E_ListEntryTypes.STRUCTS);
    list.SelectNoCallback(id_ambient, true);
    list.SetRefresh(function() {
        self.DeselectNoCallback();
        var dialog = self.root/*tab*/.root/*tag group*/.root/*dialog*/;
        if (dialog.default_mesh_tex_only || (dialog.GetChild("SUBMESHES") && !dialog.GetChild("SUBMESHES").GetSelectedItem())) {
            self.SelectNoCallback(dialog.find_tileset_index(dialog.list, dialog.selection, function(thing) { return thing.tex_ambient; }));
        } else {
            self.SelectNoCallback(dialog.find_tileset_index_submesh(dialog.GetChild("SUBMESHES").GetSelectedItem(), function(thing) { return thing.tex_ambient; }));
        }
    });
    
    list = new EmuList(col1, EMU_AUTO, ew, eh, "Specular color:", eh, n_list_entries, callback_set_map_to_selection);
    tab_specular_color.AddContent(list);
    list.callback_set_texture = function(mesh, tex) { mesh.tex_specular_color = tex; };
    list.SetList(Game.graphics.tilesets);
    list.SetEntryTypes(E_ListEntryTypes.STRUCTS);
    list.SelectNoCallback(id_specular_color, true);
    list.SetRefresh(function() {
        self.DeselectNoCallback();
        var dialog = self.root/*tab*/.root/*tag group*/.root/*dialog*/;
        if (dialog.default_mesh_tex_only || (dialog.GetChild("SUBMESHES") && !dialog.GetChild("SUBMESHES").GetSelectedItem())) {
            self.SelectNoCallback(dialog.find_tileset_index(dialog.list, dialog.selection, function(thing) { return thing.tex_specular_color; }));
        } else {
            self.SelectNoCallback(dialog.find_tileset_index_submesh(dialog.GetChild("SUBMESHES").GetSelectedItem(), function(thing) { return thing.tex_specular_color; }));
        }
    });
    
    list = new EmuList(col1, EMU_AUTO, ew, eh, "Specular highlight map:", eh, n_list_entries, callback_set_map_to_selection);
    tab_specular.AddContent(list);
    list.callback_set_texture = function(mesh, tex) { mesh.tex_specular_highlight = tex; };
    list.SetList(Game.graphics.tilesets);
    list.SetEntryTypes(E_ListEntryTypes.STRUCTS);
    list.SelectNoCallback(id_specular_highlight, true);
    list.SetRefresh(function() {
        self.DeselectNoCallback();
        var dialog = self.root/*tab*/.root/*tag group*/.root/*dialog*/;
        if (dialog.default_mesh_tex_only || (dialog.GetChild("SUBMESHES") && !dialog.GetChild("SUBMESHES").GetSelectedItem())) {
            self.SelectNoCallback(dialog.find_tileset_index(dialog.list, dialog.selection, function(thing) { return thing.tex_specular_highlight; }));
        } else {
            self.SelectNoCallback(dialog.find_tileset_index_submesh(dialog.GetChild("SUBMESHES").GetSelectedItem(), function(thing) { return thing.tex_specular_highlight; }));
        }
    });
    
    list = new EmuList(col1, EMU_AUTO, ew, eh, "Alpha map:", eh, n_list_entries, callback_set_map_to_selection);
    tab_alpha.AddContent(list);
    list.callback_set_texture = function(mesh, tex) { mesh.tex_alpha = tex; };
    list.SetList(Game.graphics.tilesets);
    list.SetEntryTypes(E_ListEntryTypes.STRUCTS);
    list.SelectNoCallback(id_alpha, true);
    list.SetRefresh(function() {
        self.DeselectNoCallback();
        var dialog = self.root/*tab*/.root/*tag group*/.root/*dialog*/;
        if (dialog.default_mesh_tex_only || (dialog.GetChild("SUBMESHES") && !dialog.GetChild("SUBMESHES").GetSelectedItem())) {
            self.SelectNoCallback(dialog.find_tileset_index(dialog.list, dialog.selection, function(thing) { return thing.tex_alpha; }));
        } else {
            self.SelectNoCallback(dialog.find_tileset_index_submesh(dialog.GetChild("SUBMESHES").GetSelectedItem(), function(thing) { return thing.tex_alpha; }));
        }
    });
    
    list = new EmuList(col1, EMU_AUTO, ew, eh, "Bump map:", eh, n_list_entries, callback_set_map_to_selection);
    tab_bump.AddContent(list);
    list.callback_set_texture = function(mesh, tex) { mesh.tex_bump = tex; };
    list.SetList(Game.graphics.tilesets);
    list.SetEntryTypes(E_ListEntryTypes.STRUCTS);
    list.SelectNoCallback(id_bump, true);
    list.SetRefresh(function() {
        self.DeselectNoCallback();
        var dialog = self.root/*tab*/.root/*tag group*/.root/*dialog*/;
        if (dialog.default_mesh_tex_only || (dialog.GetChild("SUBMESHES") && !dialog.GetChild("SUBMESHES").GetSelectedItem())) {
            self.SelectNoCallback(dialog.find_tileset_index(dialog.list, dialog.selection, function(thing) { return thing.tex_bump; }));
        } else {
            self.SelectNoCallback(dialog.find_tileset_index_submesh(dialog.GetChild("SUBMESHES").GetSelectedItem(), function(thing) { return thing.tex_bump; }));
        }
    });
    
    list = new EmuList(col1, EMU_AUTO, ew, eh, "Displacement map:", eh, n_list_entries, callback_set_map_to_selection);
    tab_displacement.AddContent(list);
    list.callback_set_texture = function(mesh, tex) { mesh.tex_displacement = tex; };
    list.SetList(Game.graphics.tilesets);
    list.SetEntryTypes(E_ListEntryTypes.STRUCTS);
    list.SelectNoCallback(id_displacement, true);
    list.SetRefresh(function() {
        self.DeselectNoCallback();
        var dialog = self.root/*tab*/.root/*tag group*/.root/*dialog*/;
        if (dialog.default_mesh_tex_only || (dialog.GetChild("SUBMESHES") && !dialog.GetChild("SUBMESHES").GetSelectedItem())) {
            self.SelectNoCallback(dialog.find_tileset_index(dialog.list, dialog.selection, function(thing) { return thing.tex_displacement; }));
        } else {
            self.SelectNoCallback(dialog.find_tileset_index_submesh(dialog.GetChild("SUBMESHES").GetSelectedItem(), function(thing) { return thing.tex_displacement; }));
        }
    });
    
    list = new EmuList(col1, EMU_AUTO, ew, eh, "Stencil map:", eh, n_list_entries, callback_set_map_to_selection);
    tab_stencil.AddContent(list);
    list.callback_set_texture = function(mesh, tex) { mesh.tex_stencil = tex; };
    list.SetList(Game.graphics.tilesets);
    list.SetEntryTypes(E_ListEntryTypes.STRUCTS);
    list.SelectNoCallback(id_decal, true);
    list.SetRefresh(function() {
        self.DeselectNoCallback();
        var dialog = self.root/*tab*/.root/*tag group*/.root/*dialog*/;
        if (dialog.default_mesh_tex_only || (dialog.GetChild("SUBMESHES") && !dialog.GetChild("SUBMESHES").GetSelectedItem())) {
            self.SelectNoCallback(dialog.find_tileset_index(dialog.list, dialog.selection, function(thing) { return thing.tex_stencil; }));
        } else {
            self.SelectNoCallback(dialog.find_tileset_index_submesh(dialog.GetChild("SUBMESHES").GetSelectedItem(), function(thing) { return thing.tex_stencil; }));
        }
    });
    
    dg.AddDefaultCloseButton();
    
    return dg;
}