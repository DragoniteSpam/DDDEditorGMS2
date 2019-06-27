/// @param UIList

var selection = ui_list_selection(argument0);

if (selection >= 0) {
    // These lists aren't alphabetized - they much trouble is caused when remaing them
    argument0.root.el_name.value = Stuff.all_se[| selection].name;
    argument0.root.el_name_internal.value = Stuff.all_se[| selection].internal_name;
    
    FMODGMS_Chan_StopChannel(Stuff.fmod_channel);
}