/// @param UIInput
function uivc_input_map_zone_z2(argument0) {

    var input = argument0;

    Stuff.map.selected_zone.z2 = real(input.value);
    map_zone_collision(Stuff.map.selected_zone);


}
