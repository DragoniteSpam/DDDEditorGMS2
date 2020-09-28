/// @param UIButton
function uivc_move_route_delete(argument0) {

    var button = argument0;
    var entity = button.root.entity;
    var route = button.root.route;
    var index = ds_list_find_index(entity.movement_routes, route);

    move_route_make_invisible(entity, route);
    ds_list_delete(entity.movement_routes, index);
    ui_list_deselect(button.root.root.el_move_routes);
    instance_activate_object(route);
    instance_destroy(route);

    dc_default(button);


}
