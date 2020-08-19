/// @param UIThing
function omu_manager_tileset_selector(argument0) {

    var thing = argument0;

    var dialog = omu_manager_tileset(thing);
    dialog.el_confirm.select_tileset = true;


}
