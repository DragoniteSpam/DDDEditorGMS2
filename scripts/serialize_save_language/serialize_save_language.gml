function serialize_save_language(buffer) {
    buffer_write(buffer, buffer_u32, SerializeThings.LANGUAGE_TEXT);
    var addr_next = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    
    buffer_write(buffer, buffer_u8, ds_list_size(Stuff.all_languages));
    for (var i = 0; i < ds_list_size(Stuff.all_languages); i++) {
        buffer_write(buffer, buffer_string, Stuff.all_languages[| i]);
    }
    
    for (var i = 0; i < ds_list_size(Stuff.all_languages); i++) {
        var lang = Stuff.all_localized_text[$ Stuff.all_languages[| i]];
        var keys = variable_struct_get_names(lang);
        buffer_write(buffer, buffer_u32, array_length(lang));
        for (var j = 0; j < array_length(lang); j++) {
            buffer_write(buffer, buffer_string, lang[$ keys[i]]);
        }
    }
    
    buffer_poke(buffer, addr_next, buffer_u64, buffer_tell(buffer));
    
    return buffer_tell(buffer);
}

/*
___________________________________________
############################################################################################
ERROR in
action number 1
of Draw Event
for object Stuff:

variable_struct_get argument 1 incorrect type (undefined) expecting a Number (YYGI32)
 at gml_Script_anon_ui_init_text_gml_GlobalScript_ui_init_text_4458_ui_init_text_gml_GlobalScript_ui_init_text (line 105) -                 return (Stuff.all_localized_text[$ Stuff.all_languages[| lang_selection]][$ list.entries[| index]] == "") ? c_red : c_black;
############################################################################################
gml_Script_anon_ui_init_text_gml_GlobalScript_ui_init_text_4458_ui_init_text_gml_GlobalScript_ui_init_text (line 105)
gml_Script_ui_render_list (line 63) -             var c = list.colorize ? list.render_colors(list, index) : c_black;
gml_Script_ui_render (line 13)
gml_Script_draw_editor_fullscreen (line 10) -     if (ui) ui.render(ui, 0, 0);
gml_Script_anon_EditorModeText_gml_GlobalScript_Group_Mode_Text_Main_106_EditorModeText_gml_GlobalScript_Group_Mode_Text_Main (line 6) -             case view_fullscreen: draw_editor_fullscreen(mode); break;
gml_Object_Stuff_Draw_0 (line 1) - mode.render(mode);
