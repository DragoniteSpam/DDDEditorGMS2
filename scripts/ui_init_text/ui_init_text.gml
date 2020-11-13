function ui_init_text(mode) {
    with (instance_create_depth(0, 0, 0, UIThing)) {
        var columns = 5;
        var spacing = 16;
        
        var cw = (room_width - columns * 32) / columns;
        var ew = cw - spacing * 2;
        var eh = 24;
        
        var c1x = cw * 0 + spacing;
        var c2x = cw * 1 + spacing;
        var c3x = cw * 2 + spacing;
        var c4x = cw * 3 + spacing;
        
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
        element.tooltip = "Every language which text in the game data may be translated to.";
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
            for (var i = ds_list_size(Stuff.all_languages); i < 1000; i++) {
                if (!(ds_list_find_index(Stuff.all_languages, "Language" + string(i)) + 1)) {
                    language_add("Language" + string(i));
                    break;
                }
            }
        }, id);
        element.tooltip = "Add a language.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_button(c1x, yy, "Remove Language", ew, eh, fa_center, function(button) {
            var selection = ui_list_selection(button.root.el_language_list);
            if (selection + 1 && ds_list_size(Stuff.all_languages) > 1) {
                language_remove(Stuff.all_languages[| selection]);
                ui_list_deselect(button.root.el_language_list);
            }
        }, id);
        element.tooltip = "Remove a language.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        yy = yy_base;
        
        var element = create_list(c2x, yy, "Text strings:", "(no text)", ew * 2, eh, 26, function(list) {
            
        }, true, id);
        element.tooltip = "Text strings in the game. The list is not updated automatically; you should periodically click \"Extract\" to update the list.";
        ds_list_add(contents, element);
        el_language_text = element;
        yy += ui_get_list_height(element) + spacing;
        
        element = create_button(c2x, yy, "Extract Text", ew * 2, eh, fa_center, function(button) {
            
        }, id);
        element.tooltip = "Extract all player-visible text from the game's data; this includes String types in the database, cutscene event nodes, and other such things.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_button(c2x, yy, "Set From Default", ew * 2, eh, fa_center, function(button) {
            
        }, id);
        element.tooltip = "Set each of the localized strings for this language to the default value (i.e. the text that has been entered into the editor itself).";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_button(c2x, yy, "Export Strings", ew - 16, eh, fa_center, function(button) {
            
        }, id);
        element.tooltip = "Save the extracted text strings to a file to be edited in external software.";
        ds_list_add(contents, element);
        
        element = create_button(c2x + ew + 16, yy, "Import Strings", ew - 16, eh, fa_center, function(button) {
            
        }, id);
        element.tooltip = "Import translated text strings.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        yy = yy_base;
        
        element = create_text(c4x, yy, "Default text:", ew, eh, fa_left, ew, id);
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_text(c4x, yy, "This is where the default text is shown; it may be somewhat longer than a normal text string, and may require more than one line", ew * 2, eh * 8, fa_left, ew * 2, id);
        element.valignment = fa_top;
        ds_list_add(contents, element);
        el_text_default = element;
        yy += element.height + spacing;
        
        element = create_text(c4x, yy, "Localized text:", ew, eh, fa_left, ew, id);
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_input(c4x, yy, "", ew * 2, eh * 8, function(input) {
            
        }, "", "Translated text...", validate_string, 0, 1, 1000, 0, 0, ew * 2, eh * 8, id);
        element.multi_line = true;
        ds_list_add(contents, element);
        el_text_translated = element;
        yy += element.height + spacing;
        
        return id;
    }
}