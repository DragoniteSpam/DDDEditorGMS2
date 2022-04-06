function dialog_create_entity_effect_com_markers() {
    var list = Stuff.map.selected_entities;
    var single = (ds_list_size(list) == 1);
    var first = list[| 0];
    var marker = single ? first.com_marker : -1;
    
    var element_width = 400 - 64;
    var element_height = 32;
    
    var dialog = new EmuDialog(400, 576, "Effect Component: Marker");
    dialog.first = first;
    
    return dialog.AddContent([
        (new EmuList(32, EMU_AUTO, element_width, element_height, "Type", element_height, 14, function() {
            var selection = self.GetSelection();
            if (selection == -1) return;
            
            map_foreach_selected(function(entity, selection) {
                entity.com_marker = selection;
            }, selection);
        }))
            .SetVacantText("No marker types defined")
            .SetID("LIST")
            .Select(marker)
    ])
        .AddDefaultCloseButton();
}