/// @param UIButton

var button = argument0;
var entity = button.root.entity;
var index = ui_list_selection(button.root.el_move_routes);

if (index + 1) {
    dialog_create_move_route_delete(entity, entity.movement_routes[| index], button.root);
}