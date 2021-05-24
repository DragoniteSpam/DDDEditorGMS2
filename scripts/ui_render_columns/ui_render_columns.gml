function ui_render_columns(thing, x, y) {
    for (var i = 0; i < ds_list_size(thing.contents); i++) {
        var content = thing.contents[| i];
        if (content.enabled) {
            if (is_struct(content)) {
                content.Render(thing.x + x, thing.y + y); 
            } else {
                content.render(content, thing.x + x, thing.y + y); 
            }
        }
    }
}