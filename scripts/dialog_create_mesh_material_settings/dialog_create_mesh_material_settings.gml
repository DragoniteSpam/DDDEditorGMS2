function dialog_create_mesh_material_settings(mesh_list, selection) {
    static find_tileset_index = function(list, selected_things, accessor) {
        var target = undefined;
        
        for (var i = 0, n = array_length(selected_things); i < n; i++) {
            var mesh = list[selected_things[i]];
            for (var j = 0, n2 = array_length(mesh.submeshes); j < n2; j++) {
                var data = guid_get(accessor(mesh.submeshes[j]));
                if (!data) return -1;
                if (target == undefined) {
                    target = data;
                } else if (target != data) {
                    return -1;
                }
            }
        }
        
        return array_search(Game.graphics.tilesets, target);
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
    
    var dg = new EmuDialog((default_mesh_tex_only ? 0 : (32 + 320)) + 32 + 320 + 32 + 32 + 32, 672, "Materials");
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
                self.GetSibling("BASE MESH BUTTON").SetInteractive(true);
                Stuff.mesh.ClearHighlightedSubmeshes();
                if (self.GetSelectedItem()) Stuff.mesh.SetHighlightedSubmesh(self.GetSelectedItem());
            }))
                .SetAllowDeselect(false)
                .SetList(mesh_list[selection[0]].submeshes)
                .Select(0)
                .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                .SetID("SUBMESHES"),
            (new EmuButton(col1, EMU_AUTO, ew, eh, "Base Mesh", function() {
                self.GetSibling("SUBMESHES").Deselect();
                self.SetInteractive(false)
            }))
                .SetInteractive(false)
                .SetID("BASE MESH BUTTON")
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
    
    var tabs = new EmuTabGroup(default_mesh_tex_only ? col1 : col2, EMU_BASE, ew + 32 + 32, dg.height - 128, (EDITOR_BASE_MODE != ModeIDs.MESH) ? 2 : 1, eh);
    if (EDITOR_BASE_MODE != ModeIDs.MESH) {
        tabs.AddTabs(0, [tab_base, tab_ambient, tab_specular_color, tab_specular]);
        tabs.AddTabs(1, [tab_alpha, tab_normal, tab_bump, tab_displacement, tab_stencil]);
    } else {
        tabs.AddTabs(0, [tab_base]);
    }
    tabs.RequestActivateTab(tab_base);
    dg.AddContent([
        tabs,
        new EmuCheckbox(default_mesh_tex_only ? col1 : col2, EMU_AUTO, ew, eh, "View texture?", false, function() {
            self.GetSibling("PREVIEW").SetEnabled(self.value);
            if (self.value) {
                self.root.width += 480 + 32;
            } else {
                self.root.width -= 480 + 32;
            }
        })
    ]);
    
    var preview = (new EmuRenderSurface(tabs.x + tabs.width + 32, EMU_BASE, 480, 480, function() {
        self.drawCheckerbox();
        var tex = guid_get(self.sprite);
        if (!tex) return;
        
        var shortest_dimension = min(1, self.width / sprite_get_width(tex.picture), self.height / sprite_get_height(tex.picture));
        draw_sprite_ext(tex.picture, 0, 0, 0, shortest_dimension, shortest_dimension, 0, c_white, 1);
        
        var ww = shortest_dimension * sprite_get_width(tex.picture);
        var hh = shortest_dimension * sprite_get_height(tex.picture);
        
        var highlighted = Stuff.mesh.GetAllHighlightedSubmeshes();
        shader_set(shd_texture_mapping);
        matrix_set(matrix_world, matrix_build(0, 0, 0, 0, 0, 0, ww, hh, shortest_dimension));
        wireframe_enable(1, 10000, c_aqua, 1);
        for (var i = 0, n = array_length(highlighted); i < n; i++) {
            vertex_submit(highlighted[i], pr_trianglelist, -1);
        }
        wireframe_disable();
        for (var i = 0, n = array_length(highlighted); i < n; i++) {
            vertex_submit(highlighted[i], pr_pointlist, -1);
        }
        matrix_set(matrix_world, matrix_build_identity());
        shader_reset();
    }, emu_null))
        .SetEnabled(false)
        .SetID("PREVIEW");
    preview.sprite = NULL;
    
    dg.AddContent(preview);
    
    // we really don't want to have to call this code like nine different times
    var texture_list_general = function(x, ew, eh, name, callback_set_texture, callback_get_texture, default_selection) {
        var n_list_entries = 12;
        
        var list = new EmuList(x, EMU_AUTO, ew, eh, name, eh, n_list_entries, function() {
            var new_tex = self.GetSelectedItem() ? self.GetSelectedItem().GUID : NULL;
            var dialog = self.root/*tab*/.root/*tag group*/.root/*dialog*/;
            dialog.GetChild("PREVIEW").sprite = new_tex;
            if (dialog.default_mesh_tex_only) {
                for (var i = 0, n = array_length(dialog.selection); i < n; i++) {
                    var mesh = dialog.list[real(dialog.selection[i])];
                    for (var j = 0, n2 = array_length(mesh.submeshes); j < n2; j++) {
                        self.callback_set_texture(mesh.submeshes[j], new_tex);
                    }
                }
            } else {
                self.callback_set_texture(dialog.GetChild("SUBMESHES").GetSelectedItem(), new_tex);
            }
        });
        list.callback_set_texture = callback_set_texture;
        list.callback_get_texture = callback_get_texture;
        list.SetList(Game.graphics.tilesets)
        list.SetEntryTypes(E_ListEntryTypes.STRUCTS);
        list.SelectNoCallback(default_selection, true);
        list.SetRefresh(function() {
            self.DeselectNoCallback();
            var dialog = self.root/*tab*/.root/*tag group*/.root/*dialog*/;
            if (dialog.default_mesh_tex_only || (dialog.GetChild("SUBMESHES") && !dialog.GetChild("SUBMESHES").GetSelectedItem())) {
                var index = dialog.find_tileset_index(dialog.list, dialog.selection, self.callback_get_texture);
                self.SelectNoCallback(index, true);
                if (self.root.isActiveTab()) {
                    dialog.GetChild("PREVIEW").sprite = (index == -1) ? NULL : Game.graphics.tilesets[index].GUID;
                }
            } else {
                var index = dialog.find_tileset_index_submesh(dialog.GetChild("SUBMESHES").GetSelectedItem(), self.callback_get_texture);
                self.SelectNoCallback(index, true);
                if (self.root.isActiveTab()) {
                    dialog.GetChild("PREVIEW").sprite = (index == -1) ? NULL : Game.graphics.tilesets[index].GUID;
                }
            }
        });
        
        return list;
    };
    
    tab_base.AddContent(texture_list_general(col1, ew, eh, "Textures:", function(submesh, tex) { submesh.tex_base = tex; }, function(submesh) { return submesh.tex_base; }, id_base));
    tab_normal.AddContent(texture_list_general(col1, ew, eh, "Normal map:", function(submesh, tex) { submesh.tex_normal = tex; }, function(submesh) { return submesh.tex_normal; }, id_normal));
    tab_ambient.AddContent(texture_list_general(col1, ew, eh, "Ambient map:", function(submesh, tex) { submesh.tex_ambient = tex; }, function(submesh) { return submesh.tex_ambient; }, id_specular_color));
    tab_specular_color.AddContent(texture_list_general(col1, ew, eh, "Specular color:", function(submesh, tex) { submesh.tex_specular_color = tex; }, function(submesh) { return submesh.tex_specular_color; }, id_specular_color));
    tab_specular.AddContent(texture_list_general(col1, ew, eh, "Specular highlight map:", function(submesh, tex) { submesh.tex_specular_highlight = tex; }, function(submesh) { return submesh.tex_specular_highlight; }, id_specular_highlight));
    tab_alpha.AddContent(texture_list_general(col1, ew, eh, "Alpha map:", function(submesh, tex) { submesh.tex_alpha = tex; }, function(submesh) { return submesh.tex_alpha; }, id_alpha));
    tab_bump.AddContent(texture_list_general(col1, ew, eh, "Bump map:", function(submesh, tex) { submesh.tex_bump = tex; }, function(submesh) { return submesh.tex_bump; }, id_bump));
    tab_displacement.AddContent(texture_list_general(col1, ew, eh, "Displacement map:", function(submesh, tex) { submesh.tex_displacement = tex; }, function(submesh) { return submesh.tex_displacement; }, id_displacement));
    tab_stencil.AddContent(texture_list_general(col1, ew, eh, "Stencil map:", function(submesh, tex) { submesh.tex_stencil = tex; }, function(submesh) { return submesh.tex_stencil; }, id_decal));
    
    return dg.AddDefaultCloseButton("Close", function() {
        Stuff.mesh.ClearHighlightedSubmeshes();
        self.root.Dispose();
    });
}