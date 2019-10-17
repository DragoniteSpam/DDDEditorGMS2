/// @param UIRadioArray

var radio = argument0;
var offset = 12;
var value = radio.value + offset;

var base_dialog = radio.root.root.root.root;
// selection is guaranteed to have a value at this point
var selection = ui_list_selection(base_dialog.el_list);
var property = base_dialog.event.types[| selection];
property[@ 1] = value;

uivc_list_event_custom_property(base_dialog.el_list);

radio.root.root.el_list_1.value = -1;