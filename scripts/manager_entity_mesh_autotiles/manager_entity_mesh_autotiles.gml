function dialog_create_entity_mesh_autotile_properties() {
    var dialog = new EmuDialog(32 + 320 + 32, 480, "Mesh Autotile Properties");
    dialog.list = ds_list_to_array(Stuff.map.selected_entities);
    var element_width = 320;
    var element_height = 32;
    
    var col1 = 32;
    
    return dialog.AddContent([
        (new EmuCheckbox(col1, EMU_BASE, element_width, element_height, "Slope?", function() {
            for (var i = 0, n = array_length(self.root.list); i < n; i++) {
                var entity = self.root.list[i];
                entity.terrain_type = self.value ? MeshAutotileLayers.SLOPE : MeshAutotileLayers.BASE;
                editor_map_mark_changed(entity);
            }
            selection_update_autotiles();
        }))
            .SetTooltip("Is the selected autotile(s) a slope?"),
        (new EmuList(col1, EMU_AUTO, element_width, element_height, "Autotile Type", element_height, 8, function() {
            var selection = self.GetSelection();
            if (!self.root || selection == -1) return;
            var autotile_id = self.GetSelectedItem().GUID;
            for (var i = 0, n = array_length(self.root.list); i < n; i++) {
                var entity = self.root.list[i];
                entity.autotile_id = autotile_id;
                entity.terrain_id = -1;
                editor_map_mark_changed(entity);
            }
            selection_update_autotiles();
        }))
            .SetList(Game.mesh_autotiles)
            .SetAllowDeselect(false)
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetVacantText("<no mesh autotile types>")
            .SetTooltip("The set of autotile meshes this entity will use")
    ]).AddDefaultCloseButton();
}