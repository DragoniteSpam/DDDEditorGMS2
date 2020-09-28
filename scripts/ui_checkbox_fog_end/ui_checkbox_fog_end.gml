/// @param UIInput
function ui_checkbox_fog_end(argument0) {

    var input = argument0;

    Stuff.terrain.terrain_fog_end = real(input.value);
    setting_set("Terrain", "fog-end", Stuff.terrain.terrain_fog_end);


}
