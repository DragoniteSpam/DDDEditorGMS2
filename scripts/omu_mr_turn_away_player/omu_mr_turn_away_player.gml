/// @description void omu_mr_turn_away_player(UIThing);
/// @param UIThing
function omu_mr_turn_away_player(argument0) {

    if (ds_list_size(argument0.root.route.steps)<255) {
        ds_list_add(argument0.root.route.steps, [MoveRouteActions.TURN_AWAY_PLAYER]);
    }



}
