function serialize_save_complete() {
    language_extract();
    var untranslated = 0;
    var lang_keys = variable_struct_get_names(Stuff.all_localized_text[$ Stuff.all_languages[| 0]]);
    for (var i = 0; i < ds_list_size(Stuff.all_languages); i++) {
        var lang = Stuff.all_localized_text[$ Stuff.all_languages[| i]];
        for (var j = 0; j < array_length(lang_keys); j++) {
            untranslated += (lang[$ lang_keys[j]] == "");
        }
    }
    
    if (untranslated) {
        var dw = 560;
        var dh = 200;
        var b_width = 128;
        var b_height = 32;
        var dg = dialog_create(dw, dh, "Hey!", dialog_default, function(button) { dialog_destroy(); }, undefined);
        
        var el_text = create_text(dw / 2, 32 + (dh - 32 - b_height) / 2, "Found " + string(untranslated) + " untranslated strings. Would you like to export the data without the text, export with the default strings, or cancel?", 0, 0, fa_center, dw - 96, dg);
        var el_cancel = create_button(dw / 4 - b_width / 2, dh - 32 - b_height / 2, "Cancel export", b_width, b_height, fa_center, function(button) {
            dialog_destroy();
        }, dg);
        var el_confirm_as_is = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Export as-is", b_width, b_height, fa_center, function(button) {
            serialize_save_data();
            dialog_destroy();
        }, dg);
        var el_confirm_default = create_button(dw * 3 / 4 - b_width / 2, dh - 32 - b_height / 2, "Export defaults", b_width, b_height, fa_center, function(button) {
            var default_lang = Stuff.all_localized_text[$ Stuff.all_languages[| 0]];
            var keys = variable_struct_get_names(default_lang);
            for (var i = 1; i < ds_list_size(Stuff.all_languages); i++) {
                var lang = Stuff.all_localized_text[$ Stuff.all_languages[| i]];
                for (var j = 0; j < array_length(keys); j++) {
                    if (lang[$ keys[j]] == "") lang[$ keys[j]] = default_lang[$ keys[j]];
                }
            }
            serialize_save_data();
            dialog_destroy();
        }, dg);
        
        ds_list_add(dg.contents, el_text, el_cancel, el_confirm_as_is, el_confirm_default);
    } else {
        serialize_save_data();
    }
}