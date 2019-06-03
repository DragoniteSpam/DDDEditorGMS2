/// @description void ui_render_list_event_custom_properties(List);
/// @param List

var otext=argument0.text;

argument0.text=argument0.text+" ("+string(ds_list_size(argument0.root.event.types))+")";
ds_list_clear(argument0.entries);

// since these are just arrays and not instances we have to do this the hard way
for (var i=0; i<ds_list_size(argument0.root.event.types); i++) {
    // don't alphabetize these
    var property=argument0.root.event.types[| i];
    ds_list_add(argument0.entries, property[EventNodeCustomData.NAME]);
}

ui_render_list(argument0, argument1, argument2);

argument0.text=otext;
