/// @param UIList
function ui_particle_type_sprite_assign(argument0) {

    var list = argument0;
    var type = list.root.type;
    var selection = ui_list_selection(list);

    if (selection + 1) {
        type.sprite = Game.graphics.particles[| selection].GUID;
        editor_particle_type_set_sprite(type);
    }


}
