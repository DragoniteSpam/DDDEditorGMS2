/// @description  void omu_entity_remove_move_route(UIThing);
/// @param UIThing

var index=ui_list_selection(argument0.root.el_move_routes);
var list=argument0.root.entity.movement_routes;

if (index>-1&&show_question("Do you really want to delete "+list[| index].name+"?")){
    var route=list[| index];
    move_route_make_invisible(argument0.root.entity, route);
    instance_activate_object(route);
    instance_destroy(route);
    ds_list_delete(list, index);
    ui_list_deselect(argument0.root.el_move_routes);
}
