/// @param UIList

var list = argument0;
var selection = ui_list_selection(list);

if (selection >= 0) {
    ui_input_set_value(list.root.el_name, Stuff.all_se[| selection].name);
    ui_input_set_value(list.root.el_name_internal, Stuff.all_se[| selection].internal_name);
    
    FMODGMS_Chan_StopChannel(Stuff.fmod_channel);
}