function dialog_create_mesh_material_settings(mesh_list, selection) {
    var dw = 560;
    var dh = 640;
    
    var columns = 1;
    var ew = dw / columns - 64 - 64;
    var eh = 24;
    var n_list_entries = 16;
    
    var find_tileset_index = function(list, selected_things, accessor) {
        var target_index = -1;
        for (var i = 0; i < array_length(selected_things); i++) {
            var thing = list[selected_things[i]];
            for (var j = 0; j < array_length(Game.graphics.tilesets); j++) {
                if (Game.graphics.tilesets[j].GUID == accessor(thing)) {
                    if (target_index != -1) {
                        return -1;
                    }
                    target_index = j;
                }
            }
        }
        return target_index;
    };
    
    var id_base = find_tileset_index(mesh_list, selection, function(thing) { return thing.tex_base; });
    var id_ambient = find_tileset_index(mesh_list, selection, function(thing) { return thing.tex_ambient; });
    var id_specular_color = find_tileset_index(mesh_list, selection, function(thing) { return thing.tex_specular_color; });
    var id_specular_highlight = find_tileset_index(mesh_list, selection, function(thing) { return thing.tex_specular_highlight; });
    var id_alpha = find_tileset_index(mesh_list, selection, function(thing) { return thing.tex_alpha; });
    var id_bump = find_tileset_index(mesh_list, selection, function(thing) { return thing.tex_bump; });
    var id_displacement = find_tileset_index(mesh_list, selection, function(thing) { return thing.tex_displacement; });
    var id_decal = find_tileset_index(mesh_list, selection, function(thing) { return thing.tex_stencil; });
    
    var dg = new EmuDialog(dw, dh, "Materials");
    dg.list = mesh_list;
    dg.selection = selection;
    dg.active_shade = false;
    
    var tab_base = new EmuTab("Base Texture");
    var tab_ambient = new EmuTab("Ambient Map").SetInteractive(false);
    var tab_specular_color = new EmuTab("Specular Color").SetInteractive(false);
    var tab_specular = new EmuTab("Specular Map").SetInteractive(false);
    var tab_alpha = new EmuTab("Alpha Map").SetInteractive(false);
    var tab_bump = new EmuTab("Bump Map").SetInteractive(false);
    var tab_displacement = new EmuTab("Displacement Map").SetInteractive(false);
    var tab_stencil = new EmuTab("Stencil Map").SetInteractive(false);
    
    var tabs = new EmuTabGroup(32, 32, dw - 64, dh - 96, 2, 32);
    tabs.AddTabs(0, [tab_base, tab_ambient, tab_specular_color, tab_specular]);
    tabs.AddTabs(1, [tab_alpha, tab_bump, tab_displacement, tab_stencil]);
    tabs.RequestActivateTab(tab_base);
    dg.AddContent(tabs);
    
    var callback_set_map_to_selection = function() {
        var selection = GetSelection();
        var new_tex = (selection + 1) ? Game.graphics.tilesets[selection].GUID : NULL;
        var mesh_selection = self.root.root.root.selection;
        for (var i = 0, n = array_length(mesh_selection); i < n; i++) {
            self.callback_set_texture(Game.meshes[real(mesh_selection[i])], new_tex);
        }
    };
    
    var list = new EmuList(32, 32, ew, eh, "Textures:", eh, n_list_entries, callback_set_map_to_selection);
    tab_base.AddContent(list);
    list.callback_set_texture = function(mesh, tex) { mesh.tex_base = tex; };
    list.SetList(Game.graphics.tilesets);
    list.SetEntryTypes(E_ListEntryTypes.STRUCTS);
    list.Select(id_base, true);
    
    list = new EmuList(32, 32, ew, eh, "Ambient map:", eh, n_list_entries, callback_set_map_to_selection);
    tab_ambient.AddContent(list);
    list.callback_set_texture = function(mesh, tex) { mesh.tex_ambient = tex; };
    list.SetList(Game.graphics.tilesets);
    list.SetEntryTypes(E_ListEntryTypes.STRUCTS);
    list.Select(id_ambient, true);
    
    list = new EmuList(32, 32, ew, eh, "Specular color:", eh, n_list_entries, callback_set_map_to_selection);
    tab_specular_color.AddContent(list);
    list.callback_set_texture = function(mesh, tex) { mesh.tex_specular_color = tex; };
    list.SetList(Game.graphics.tilesets);
    list.SetEntryTypes(E_ListEntryTypes.STRUCTS);
    list.Select(id_specular_color, true);
    
    list = new EmuList(32, 32, ew, eh, "Specular highlight map:", eh, n_list_entries, callback_set_map_to_selection);
    tab_specular.AddContent(list);
    list.callback_set_texture = function(mesh, tex) { mesh.tex_specular_highlight = tex; };
    list.SetList(Game.graphics.tilesets);
    list.SetEntryTypes(E_ListEntryTypes.STRUCTS);
    list.Select(id_specular_highlight, true);
    
    list = new EmuList(32, 32, ew, eh, "Alpha map:", eh, n_list_entries, callback_set_map_to_selection);
    tab_alpha.AddContent(list);
    list.callback_set_texture = function(mesh, tex) { mesh.tex_alpha = tex; };
    list.SetList(Game.graphics.tilesets);
    list.SetEntryTypes(E_ListEntryTypes.STRUCTS);
    list.Select(id_alpha, true);
    
    list = new EmuList(32, 32, ew, eh, "Bump map:", eh, n_list_entries, callback_set_map_to_selection);
    tab_bump.AddContent(list);
    list.callback_set_texture = function(mesh, tex) { mesh.tex_bump = tex; };
    list.SetList(Game.graphics.tilesets);
    list.SetEntryTypes(E_ListEntryTypes.STRUCTS);
    list.Select(id_bump, true);
    
    list = new EmuList(32, 32, ew, eh, "Displacement map:", eh, n_list_entries, callback_set_map_to_selection);
    tab_displacement.AddContent(list);
    list.callback_set_texture = function(mesh, tex) { mesh.tex_displacement = tex; };
    list.SetList(Game.graphics.tilesets);
    list.SetEntryTypes(E_ListEntryTypes.STRUCTS);
    list.Select(id_displacement, true);
    
    list = new EmuList(32, 32, ew, eh, "Stencil map:", eh, n_list_entries, callback_set_map_to_selection);
    tab_stencil.AddContent(list);
    list.callback_set_texture = function(mesh, tex) { mesh.tex_stencil = tex; };
    list.SetList(Game.graphics.tilesets);
    list.SetEntryTypes(E_ListEntryTypes.STRUCTS);
    list.Select(id_decal, true);
    
    dg.AddDefaultCloseButton();
    
    return dg;
}