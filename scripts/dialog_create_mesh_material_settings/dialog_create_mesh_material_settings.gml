function dialog_create_mesh_material_settings(dialog, selection) {
    var mode = Stuff.mesh_ed;
    
    var dw = 560;
    var dh = 480;
    
    var columns = 1;
    var ew = dw / columns - 64 - 64;
    var eh = 24;
    
    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;
    
    var spacing = 16;
    
    var yy = 64;
    var yy_base = 64;
    
    var selected_things = ds_map_to_array(selection);
    
    var find_tileset_index = function(selected_things, accessor) {
        var target_index = -1;
        for (var i = 0; i < array_length(selected_things); i++) {
            var thing = Stuff.all_meshes[| selected_things[i]];
            for (var j = 0; j < ds_list_size(Stuff.all_graphic_tilesets); j++) {
                if (Stuff.all_graphic_tilesets[| j].GUID == accessor(thing)) {
                    if (target_index != -1) {
                        return -1;
                    }
                    target_index = j;
                }
            }
        }
        return target_index;
    };
    
    var id_base = find_tileset_index(selected_things, function(thing) { return thing.tex_base; });
    var id_ambient = find_tileset_index(selected_things, function(thing) { return thing.tex_ambient; });
    var id_specular_color = find_tileset_index(selected_things, function(thing) { return thing.tex_specular_color; });
    var id_specular_highlight = find_tileset_index(selected_things, function(thing) { return thing.tex_specular_highlight; });
    var id_alpha = find_tileset_index(selected_things, function(thing) { return thing.tex_alpha; });
    var id_bump = find_tileset_index(selected_things, function(thing) { return thing.tex_bump; });
    var id_displacement = find_tileset_index(selected_things, function(thing) { return thing.tex_displacement; });
    var id_decal = find_tileset_index(selected_things, function(thing) { return thing.tex_stencil; });
    
    var dg = new EmuDialog(dw, dh, "Materials");
    dg.selection = selection;
    dg.active_shade = false;
    
    var tab_base = new EmuTab("Base Texture");
    var tab_ambient = new EmuTab("Ambient Map");
    var tab_specular_color = new EmuTab("Specular Color");
    var tab_specular = new EmuTab("Specular Map");
    var tab_alpha = new EmuTab("Alpha Map");
    var tab_bump = new EmuTab("Bump Map");
    var tab_displacement = new EmuTab("Displacement Map");
    var tab_stencil = new EmuTab("Stencil Map");
    
    var tabs = new EmuTabGroup(32, 32, dw - 64, dh - 96, 2, 32);
    tabs.AddTabs(0, [tab_base, tab_ambient, tab_specular_color, tab_specular]);
    tabs.AddTabs(1, [tab_alpha, tab_bump, tab_displacement, tab_stencil]);
    tabs.RequestActivateTab(tab_base);
    dg.AddContent(tabs);
    
    var callback_set_map_to_selection = function() {
        var selection = GetSelection();
        var new_tex = (selection + 1) ? Stuff.all_graphic_tilesets[| selection].GUID : NULL;;
        var mesh_selection = self.root.root.root.selection;
        for (var i = ds_map_find_first(mesh_selection); i != undefined; i = ds_map_find_next(mesh_selection, i)) {
            self.callback_set_texture(Stuff.all_meshes[| i], new_tex);
        }
    };
    
    var list = new EmuList(32, 32, ew, eh, "Textures:", eh, 9, callback_set_map_to_selection);
    tab_base.AddContent(list);
    list.callback_set_texture = function(mesh, tex) { mesh.tex_base = tex; };
    list.SetList(Stuff.all_graphic_tilesets);
    list.SetEntryTypes(E_ListEntryTypes.STRUCTS);
    list.Select(id_base, true);
    
    var list = new EmuList(32, 32, ew, eh, "Ambient map:", eh, 9, callback_set_map_to_selection);
    tab_ambient.AddContent(list);
    list.callback_set_texture = function(mesh, tex) { mesh.tex_ambient = tex; };
    list.SetList(Stuff.all_graphic_tilesets);
    list.SetEntryTypes(E_ListEntryTypes.STRUCTS);
    list.Select(id_ambient, true);
    
    var list = new EmuList(32, 32, ew, eh, "Specular color:", eh, 9, callback_set_map_to_selection);
    tab_specular_color.AddContent(list);
    list.callback_set_texture = function(mesh, tex) { mesh.tex_specular_color = tex; };
    list.SetList(Stuff.all_graphic_tilesets);
    list.SetEntryTypes(E_ListEntryTypes.STRUCTS);
    list.Select(id_specular_color, true);
    
    var list = new EmuList(32, 32, ew, eh, "Specular highlight map:", eh, 9, callback_set_map_to_selection);
    tab_specular.AddContent(list);
    list.callback_set_texture = function(mesh, tex) { mesh.tex_specular_highlight = tex; };
    list.SetList(Stuff.all_graphic_tilesets);
    list.SetEntryTypes(E_ListEntryTypes.STRUCTS);
    list.Select(id_specular_highlight, true);
    
    var list = new EmuList(32, 32, ew, eh, "Alpha map:", eh, 9, callback_set_map_to_selection);
    tab_alpha.AddContent(list);
    list.callback_set_texture = function(mesh, tex) { mesh.tex_alpha = tex; };
    list.SetList(Stuff.all_graphic_tilesets);
    list.SetEntryTypes(E_ListEntryTypes.STRUCTS);
    list.Select(id_alpha, true);
    
    var list = new EmuList(32, 32, ew, eh, "Bump map:", eh, 9, callback_set_map_to_selection);
    tab_bump.AddContent(list);
    list.callback_set_texture = function(mesh, tex) { mesh.tex_bump = tex; };
    list.SetList(Stuff.all_graphic_tilesets);
    list.SetEntryTypes(E_ListEntryTypes.STRUCTS);
    list.Select(id_bump, true);
    
    var list = new EmuList(32, 32, ew, eh, "Displacement map:", eh, 9, callback_set_map_to_selection);
    tab_displacement.AddContent(list);
    list.callback_set_texture = function(mesh, tex) { mesh.tex_displacement = tex; };
    list.SetList(Stuff.all_graphic_tilesets);
    list.SetEntryTypes(E_ListEntryTypes.STRUCTS);
    list.Select(id_displacement, true);
    
    var list = new EmuList(32, 32, ew, eh, "Stencil map:", eh, 9, callback_set_map_to_selection);
    tab_stencil.AddContent(list);
    list.callback_set_texture = function(mesh, tex) { mesh.tex_stencil = tex; };
    list.SetList(Stuff.all_graphic_tilesets);
    list.SetEntryTypes(E_ListEntryTypes.STRUCTS);
    list.Select(id_decal, true);
    
    var b_width = 128;
    var b_height = 32;
    dg.AddContent(new EmuButton(dw / 2 - b_width / 2, dh - 32 - b_height / 2, b_width, b_height, "Done", emu_dialog_close_auto));
    
    return dg;
}