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
        
        list_selection_action = function(element) {
            var selection = ui_list_selection(element.root.el_language_text);
            var lang_selection = ui_list_selection(element.root.el_language_list);
            if ((selection + 1) && (lang_selection + 1)) {
                var key_name = element.root.el_language_text.entries[| selection];
                var lang_name = Stuff.all_languages[| lang_selection];
                element.root.el_text_default.text = key_name + "\n" + Stuff.all_localized_text[$ Stuff.all_languages[| 0]][$ key_name];
                ui_input_set_value(element.root.el_text_translated, Stuff.all_localized_text[$ lang_name][$ key_name]);
            } else {
                element.root.el_text_default.text = "";
            }
            element.root.el_text_translated.interactive = (ui_list_selection(element.root.el_language_list) > 0);
        };
        
        var element = create_list(c1x, yy, "Languages:", "(default)", ew, eh, 26, function(list) {
            var selection = ui_list_selection(list);
            if (selection + 1) {
                ui_input_set_value(list.root.el_language_name, Stuff.all_languages[| selection]);
            }
            list.root.list_selection_action(list);
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
            list.root.list_selection_action(list);
        }, true, id);
        element.tooltip = "Text strings in the game. The list is not updated automatically; you should periodically click \"Extract\" to update the list.";
        ds_list_add(contents, element);
        el_language_text = element;
        yy += ui_get_list_height(element) + spacing;
        
        element = create_button(c2x, yy, "Extract Text", ew * 2, eh, fa_center, function(button) {
            language_extract();
            var lang_json = "{\n";
            ui_list_clear(button.root.el_language_text);
            for (var lang_index = 0; lang_index < ds_list_size(Stuff.all_languages); lang_index++) {
                var lang = Stuff.all_localized_text[$ Stuff.all_languages[| lang_index]];
                lang_json += "    \"" + Stuff.all_languages[| lang_index] + "\": {\n";
                var all_keys = variable_struct_get_names(lang);
                array_sort(all_keys, true);
                for (var i = 0; i < array_length(all_keys); i++) {
                    var base_text = lang[$ all_keys[i]];
                    var base_json_text = base_text;
                    base_json_text = string_replace_all(base_json_text, "\\", "\\\\");
                    base_json_text = string_replace_all(base_json_text, "\"", "\\\"");
                    lang_json += "        \"" + all_keys[i] + "\": \"" + base_json_text + "\"" + ((i < array_length(all_keys) - 1) ? "," : "") + "\n";
                    if (lang_index == 0) {
                        ds_list_add(button.root.el_language_text.entries, all_keys[i]);
                    }
                }
                lang_json += "    }" + ((lang_index < ds_list_size(Stuff.all_languages) - 1) ? "," : "") + "\n";
            }
            lang_json += "}";
        }, id);
        element.tooltip = "Extract all player-visible text from the game's data; this includes String types in the database, cutscene event nodes, and other such things.";
        ds_list_add(contents, element);
        yy += element.height + spacing;
        
        element = create_button(c2x, yy, "Set From Default", ew * 2, eh, fa_center, function(button) {
            var selection = ui_list_selection(button.root.el_language_list);
            if (selection + 1) {
                var lang_name = Stuff.all_languages[| selection];
                var base_lang = Stuff.all_languages[| 0];
                var keys = variable_struct_get_names(Stuff.all_localized_text[$ lang_name]);
                for (var i = 0; i < array_length(keys); i++) {
                    Stuff.all_localized_text[$ lang_name][$ keys[i]] = Stuff.all_localized_text[$ base_lang][$ keys[i]];
                }
                button.root.list_selection_action(button);
            }
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
            var selection = ui_list_selection(input.root.el_language_text);
            var lang_selection = ui_list_selection(input.root.el_language_list);
            if ((selection + 1) && (lang_selection + 1)) {
                var key_name = input.root.el_language_text.entries[| selection];
                var lang_name = Stuff.all_languages[| lang_selection];
                Stuff.all_localized_text[$ lang_name][$ key_name] = input.value;
            }
        }, "", "Translated text...", validate_string, 0, 1, 1000, 0, 0, ew * 2, eh * 8, id);
        element.multi_line = true;
        ds_list_add(contents, element);
        el_text_translated = element;
        yy += element.height + spacing;
        
        return id;
    }
}