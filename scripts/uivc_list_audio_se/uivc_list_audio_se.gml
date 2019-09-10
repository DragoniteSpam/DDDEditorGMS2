/// @param UIList

var list = argument0;
var selection = ui_list_selection(list);

if (selection >= 0) {
    list.root.el_name.value = Stuff.all_se[| selection].name;
    list.root.el_name_internal.value = Stuff.all_se[| selection].internal_name;
    
    FMODGMS_Chan_StopChannel(Stuff.fmod_channel);
}