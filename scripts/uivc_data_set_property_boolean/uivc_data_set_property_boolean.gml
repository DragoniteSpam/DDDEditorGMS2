/// @description  void uivc_data_set_property_boolean(UIThing);
/// @param UIThing

var data=guid_get(Camera.ui_game_data.active_type_guid);
var selection=ui_list_selection(Camera.ui_game_data.el_instances);

if (selection>=0){
    // because game maker can't handle doing all of these accessors in the same
    // line apparently
    var instance=data.instances[| selection];
    instance.values[| argument0.key]=argument0.value;
}
