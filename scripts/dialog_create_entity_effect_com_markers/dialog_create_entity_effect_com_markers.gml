function dialog_create_entity_effect_com_markers() {
    var list = Stuff.map.selected_entities;
    var single = (ds_list_size(list) == 1);
    var first = list[| 0];
    var marker = single ? first.com_marker : -1;
    
    var dw = 320;
    var dh = 640;
    
    var dg = dialog_create(dw, dh, "Effect Component: Marker", dialog_default, dialog_destroy, undefined);
    
    var spacing = 16;
    var columns = 1;
    var ew = dw / columns - spacing * 2;
    var eh = 24;
    
    var col1_x = spacing;
    
    var vx1 = dw / (columns * 2) - 32;
    var vy1 = 0;
    var vx2 = vx1 + dw / (columns * 2);
    var vy2 = eh;
    
    var yy = 64;
    var yy_base = yy;
    
    var el_type = create_list(col1_x, yy, "Marker type:", "No marker types defined", ew, eh, 20, function(list) {
        var selection = ui_list_selection(list);
        var entities = Stuff.map.selected_entities;
        for (var i = 0; i < ds_list_size(entities); i++) {
            var effect = entities[| i];
            effect.com_marker = selection;
        }
    }, false, dg, Game.vars.effect_markers);
    ui_list_select(el_type, marker);
    
    yy += el_type.GetHeight() + spacing;
    
    var b_width = 128;
    var b_height = 32;
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    
    ds_list_add(dg.contents,
        el_type,
        el_confirm
    );
    
    return dg;
}