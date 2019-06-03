/// @description void omu_mr_move_away_player(UIThing);
/// @param UIThing

if (ds_list_size(argument0.root.route.steps)<255) {
    ds_list_add(argument0.root.route.steps, [MoveRouteActions.MOVE_AWAY_PLAYER]);
}
