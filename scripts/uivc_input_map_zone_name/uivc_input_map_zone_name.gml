/// @param UIInput
function uivc_input_map_zone_name(argument0) {

    var input = argument0;

    Stuff.map.selected_zone.name = input.value;
    input.root.text = "Zone Settings: " + input.value;
    input.root.root.text = "Data: " + input.value;


}
