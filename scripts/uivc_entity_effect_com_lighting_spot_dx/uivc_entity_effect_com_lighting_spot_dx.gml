/// @param UIInput
function uivc_entity_effect_com_lighting_spot_dx(argument0) {

    var input = argument0;
    var list = Stuff.map.selected_entities;

    for (var i = 0; i < ds_list_size(list); i++) {
        var effect = list[| i];
        effect.com_light.light_dx = real(input.value);
    }


}
