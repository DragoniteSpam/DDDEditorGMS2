/// @description void move_route_make_invisible(Entity, DataMoveRoute);
/// @param Entity
/// @param DataMoveRoute

var n=array_length_1d(argument0.visible_routes);

// are you already visible?
for (var i=0; i<n; i++) {
    if (argument0.visible_routes[i]==argument1.GUID) {
        argument0.visible_routes[i]=0;
        return 0;
    }
}
