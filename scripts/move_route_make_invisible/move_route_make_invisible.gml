/// @param Entity
/// @param DataMoveRoute

var entity = argument0;
var route = argument1;

var n = array_length_1d(entity.visible_routes);

// are you already visible?
for (var i = 0; i < n; i++) {
    if (entity.visible_routes[i] == route.GUID) {
        entity.visible_routes[i] = 0;
        return;
    }
}