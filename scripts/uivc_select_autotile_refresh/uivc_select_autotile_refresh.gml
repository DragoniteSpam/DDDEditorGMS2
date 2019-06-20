/// @param index

var ts = get_active_tileset();

// refresh values that don't like to do it on their own
Camera.ui.t_p_autotile_editor.element_priority.value = string(ts.at_priority[Camera.selection_fill_autotile]);
Camera.ui.t_p_autotile_editor.element_tag.value = string(ts.at_tags[Camera.selection_fill_autotile]);

var list = Camera.ui.t_p_autotile_editor.element_list.entries;
for (var i = 0; i < AUTOTILE_MAX; i++) {
    if (ts.autotiles[i] != noone) {
        var data = Stuff.available_autotiles[ts.autotiles[i]];
        // this can happen if an autotile graphic is removed while it's still being referenced by the game
        // todo some way to inform the user that this has happened
        if (is_array(data)) {
            list[| i] = string(i) + "."+data[AvailableAutotileProperties.NAME];
        } else {
            list[| i] = string(i) + ". <none set>";
        }
    }
}
