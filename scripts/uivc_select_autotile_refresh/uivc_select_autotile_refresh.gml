var ts = get_active_tileset();

// refresh values that don't like to do it on their own
ui_input_set_value(Stuff.map.ui.t_p_autotile_editor.element_priority, string(ts.at_priority[Stuff.map.selection_fill_autotile]));
ui_input_set_value(Stuff.map.ui.t_p_autotile_editor.element_tag, string(ts.at_tags[Stuff.map.selection_fill_autotile]));

var list = Stuff.map.ui.t_p_autotile_editor.element_list.entries;
for (var i = 0; i < AUTOTILE_MAX; i++) {
    var data = guid_get(ts.autotiles[i]);
    if (data) {
        list[| i] = data.name;
    } else {
        list[| i] = "<none set>";
    }
}