/// @description  void omu_entity_set_auto_move_route(UIThing);
/// @param UIThing

var index=ui_list_selection(argument0.root.el_move_routes);

if (index>-1){
    argument0.root.entity.autonomous_movement_route=argument0.root.entity.movement_routes[| index].GUID;
}
