function sa_fill() {
    static fill_types = [
        function(x, y, z) {
            if (!Stuff.map.active_map.Get(x, y, z)[@ MapCellContents.TILE]) {
                Stuff.map.active_map.Add(new EntityTile("Tile", Stuff.map.selection_fill_tile_x, Stuff.map.selection_fill_tile_y), x, y, z);
            }
        },
        function(x, y, z) {
            emu_dialog_notice("this is wip");
            return;
            if (!Stuff.map.active_map.Get(x, y, z)[@ MapCellContents.TILE]) {
                Stuff.map.active_map.Add(new EntityTileAnimated("Animated Tile"), x, y, z);
            }
        },
        function(x, y, z) {
            if (!Stuff.map.active_map.Get(x, y, z)[@ MapCellContents.MESH]) {
                var index = Stuff.map.ui.SearchID("MESH LIST").GetSelection();
                if (index == -1) return;
                Stuff.map.active_map.Add(new EntityMesh("Mesh", Game.meshes[index]), x, y, z);
            }
        },
        function(x, y, z) {
            if (!Stuff.map.active_map.Get(x, y, z)[@ MapCellContents.PAWN]) {
                Stuff.map.active_map.Add(new EntityPawn("Pawn"), x, y, z);
            }
        },
        function(x, y, z) {
            if (!Stuff.map.active_map.Get(x, y, z)[@ MapCellContents.EFFECT]) {
                Stuff.map.active_map.Add(new EntityEffect("Effect"), x, y, z);
            }
        },
        function(x, y, z) {
            if (!Stuff.map.active_map.Get(x, y, z)[@ MapCellContents.MESH]) {
                Stuff.map.active_map.Add(new EntityMeshAutotile("Mesh Autotile"), x, y, z);
            }
        },
    ];
    
    if (Settings.selection.fill_type == FillTypes.ZONE) {
        safc_fill_zone();
        return;
    }
    
    // processes each cell in the selection, but only once
    var processed = { };
    for (var s = 0; s < array_length(Stuff.map.selection); s++) {
        Stuff.map.selection[s].foreach_cell(processed, fill_types[Settings.selection.fill_type]);
    }
    
    selection_update_autotiles();
    sa_process_selection();
}

function safc_fill_zone() {
    // not technically a Selection Fill script, but it's used in a similar way
    var button = Stuff.map.ui.SearchID("ZONE DATA");
    var type = Stuff.map.ui.SearchID("ZONE TYPE").GetSelection();
    
    for (var i = 0; i < array_length(Stuff.map.selection); i++) {
        var selection = Stuff.map.selection[i];
        // Only going to do this with rectangle zones. I'm not currently planning on
        // supporting spherical zones, and size-one zones are kinda pointless.
        if (instanceof(selection) == "SelectionRectangle") {
            var zone = new global.map_zone_type_objects[type](undefined, selection.x, selection.y, selection.z, selection.x2, selection.y2, selection.z2);
            zone.name = instanceof(zone) + " " + string(array_length(Stuff.map.active_map.contents.all_zones));
            array_push(Stuff.map.active_map.contents.all_zones, zone);
            
            zone.SetBounds();
            Stuff.map.selected_zone = zone;
            button.Refresh();
        }
    }
    
    selection_clear();
    
    if (!Settings.view.zones) {
        emu_dialog_notice("Zones are currently set to be invisible. It is recommended that you turn on Zone Visibility in the General tab.");
    }
}

function sa_delete() {
    if (Stuff.map.selected_zone) Stuff.map.selected_zone.Destroy();
    
    for (var i = ds_list_size(Stuff.map.active_map.contents.all_entities) - 1; i >= 0; i--) {
        var thing = Stuff.map.active_map.contents.all_entities[| i];
        if (selected(thing)) {
            selection_delete(thing);
        }
    }
    
    selection_update_autotiles();
    selection_clear();
    Stuff.map.ui.SearchID("ALL ENTITIES").Deselect();
}