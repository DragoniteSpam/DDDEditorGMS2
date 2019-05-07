/// @description  void ui_render_list_event_custom_set_data(UIList, x, y);
/// @param UIList
/// @param  x
/// @param  y

var oldentries=argument0.entries;
argument0.entries=Stuff.all_event_custom;

var type=guid_get(argument0.node.custom_guid).types[| argument0.index];
var datadata=guid_get(type[EventNodeCustomData.TYPE_GUID]);

argument0.entries=datadata.instances;

// todo alphabetize lists?

ui_render_list(argument0, argument1, argument2);

// no memory leak, although the list isn't used
argument0.entries=oldentries;
