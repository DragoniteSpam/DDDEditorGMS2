function dialog_create_game_data_asset_flags(root, index) {
    var dw = 960;
    var dh = 800;
    
    var dg = dialog_create(dw, dh, "Asset Flags", dialog_default, dc_close_no_questions_asked, root);
    var data = guid_get(Stuff.data.ui.active_type_guid);
    var selection = ui_list_selection(Stuff.data.ui.el_instances);
    dg.inst = data.instances[| selection];
    dg.index = index;
    
    var columns = 3;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;
    
    var c1 = dw * 0 / columns + spacing;
    var c2 = dw * 1 / columns + spacing;
    var c3 = dw * 2 / columns + spacing;
    
    var yy = 64;
    var yy_base = yy;
    
    var color_active = c_ui_select;
    var color_inactive = c_white;
    
    var el_numerical = create_text(c1, yy, "Numerical value: <>", ew, eh, fa_left, dw - spacing * 2, dg);
    el_numerical.render = function(text, x, y) {
        text.text = "Numerical value: 0x" + string_hex(text.root.el_flags.value) + " (" + string(text.root.el_flags.value) + ")";
        ui_render_text(text, x, y);
    };
    yy += el_numerical.height + spacing;
    
    // use this if you later open this up to a list of properties
    // for asset indices
    dg.multi_index = 0;
    var default_value = dg.inst.values[| index][| dg.multi_index];
    var el_flags = create_bitfield(c1, yy, "Asset Flags", ew, eh, default_value, dg);
    dg.el_flags = el_flags;
    
    var rows = 24;
    for (var i = 0; i < FLAG_COUNT; i++) {
        var label = (Stuff.all_asset_flags[| i] == "") ? "<" + string(i) + ">" : Stuff.all_asset_flags[| i];
        create_bitfield_options_vertical(el_flags, [create_bitfield_option_data(i, function(option, x, y) {
            option.state = option.root.value & (1 << option.value);
            ui_render_bitfield_option_text(option, x, y);
        }, function(option) {
            option.root.value ^= (1 << option.value);
            option.root.root.inst.values[| option.root.root.index][| option.root.root.multi_index] = option.root.value;
        }, label, -1, 0, ew / 2, spacing / 2, 0, 0, color_active, color_inactive)]);
        var option = el_flags.contents[| ds_list_size(el_flags.contents) - 1];
        option.x = ew * (i div rows);
        option.y = eh * (i % rows);
    }
    
    create_bitfield_options_vertical(el_flags, [
        create_bitfield_option_data(i, function(option, x, y) {
            option.state = (option.root.value == FLAG_MAX_VALUE);
            ui_render_bitfield_option_text(option, x, y);
        }, function(option) {
            option.root.value = FLAG_MAX_VALUE;
            option.root.root.inst.values[| option.root.root.index][| option.root.root.multi_index] = FLAG_MAX_VALUE;
        }, "All", -1, 0, ew / 2, spacing / 2, ew * (i div rows), 0, color_active, color_inactive),
        create_bitfield_option_data(i, function(option, x, y) {
            option.state = !option.root.value;
            ui_render_bitfield_option_text(option, x, y);
        }, function(option) {
            option.root.value = 0;
            option.root.root.inst.values[| option.root.root.index][| option.root.root.multi_index] = 0;
        }, "None", -1, 0, ew / 2, spacing / 2, ew * (i div rows), 0, color_active, color_inactive),
    ]);
    
    el_flags.tooltip = "Asset flags can be toggled on or off. Shaded cells are on, while unshaded cells are off.";
    
    var b_width = 128;
    var b_height = 32;
    var el_close = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    
    ds_list_add(dg.contents,
        el_numerical,
        el_flags,
        el_close
    );

    return dg;
}