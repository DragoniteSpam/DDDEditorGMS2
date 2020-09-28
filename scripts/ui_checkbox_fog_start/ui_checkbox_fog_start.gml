/// @param UIInput
function ui_checkbox_fog_start(argument0) {

    var input = argument0;

    Stuff.terrain.terrain_fog_start = real(input.value);
    setting_set("Terrain", "fog-start", Stuff.terrain.terrain_fog_start);


}
