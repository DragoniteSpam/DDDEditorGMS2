/// @param UIButton

var button = argument0;

// if you can click on the button to spawn this dialog, selection is guaranteed to have a value
var selection = ui_list_selection(button.root.el_list);
var property = button.root.event.types[| selection];
var offset = DataTypes.AUDIO_BGM;

dialog_create_select_data_types_ext(button, property[1], uivc_input_event_node_custom_data_ext);