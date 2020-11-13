function ui_init_text(mode) {
    with (instance_create_depth(0, 0, 0, UIThing)) {
        var columns = 5;
        var spacing = 16;
        
        var cw = (room_width - columns * 32) / columns;
        var ew = cw - spacing * 2;
        var eh = 24;
        
        var c1x = cw * 0 + spacing;
        // the first column is a bit wider
        var c2x = cw * 1 + spacing + spacing * 4;
        var c3x = cw * 2 + spacing + spacing * 4;
        var c4x = cw * 3 + spacing + spacing * 4;
        
        var vx1 = ew / 2;
        var vy1 = 0;
        var vx2 = ew;
        var vy2 = eh;
        
        var b_width = 128;
        var b_height = 32;
        
        var yy_header = 64;
        var yy = 64 + eh;
        var yy_base = yy;
        
        var this_column = 0;
        var xx = this_column * cw + spacing;
        
        var element = create_list(c1x, yy, "Languages:", "(default)", ew, eh, 26, function(list) {
            var selection = ui_list_selection(list);
            if (selection + 1) {
                ui_input_set_value(list.root.el_language_name, Stuff.all_languages[| selection]);
            }
        }, true, id, Stuff.all_languages);
        element.tooltip = "All of the 3D meshes currently loaded. You can drag them from Windows Explorer into the program window to add them in bulk. Middle-click the list to alphabetize the meshes.";
        ds_list_add(contents, element);
        el_language_list = element;
        yy += ui_get_list_height(element) + spacing;
        
        element = create_input(c1x, yy, "Name:", ew, eh, function(input) {
            var selection = ui_list_selection(input.root.el_language_list);
            if (selection + 1) {
                Stuff.all_languages[| selection] = input.value;
            }
        }, "", "language name", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, id);
        element.tooltip = "";
        ds_list_add(contents, element);
        el_language_name = element;
        yy += element.height + spacing;
        
        element = create_button(c1x, yy, "Add Language", ew, eh, fa_center, function() {
            if (ds_list_size(Stuff.all_languages) >= 255) return;
            var n = 0;
            for (var i = 0; i < 10000; i++) {
                if (ds_list_find_index(Stuff.all_languages, "Language" + string(i)) + 1) {
                    ds_list_add(Stuff.all_languages, "Language" + string(i));
                    break;
                }
            }
        }, id);
        element.tooltip = "Add a language.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_button(c1x, yy, "Remove Language", ew, eh, fa_center, function(button) {
            var selection = ui_list_selection(button.root.el_language_list);
            if (selection + 1) {
                ds_list_delete(Stuff.all_languages, selection);
                ui_list_deselect(button.root.el_language_list);
            }
        }, id);
        element.tooltip = "Remove a language.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        yy = yy_base;
        
        return id;
    }
}