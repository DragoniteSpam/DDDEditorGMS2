/// @param Entity
/// @param DataMoveRoute

var entity = argument0;
var route = argument1;

var n = array_length_1d(entity.visible_routes);

// are you already visible?
for (var i = 0; i < n; i++) {
    if (entity.visible_routes[i] == route.GUID) {
        return;
    }
}

// are there any open slots?
for (var i = 0; i < n; i++) {
    if (!guid_get(entity.visible_routes[i])) {
        entity.visible_routes[i] = route.GUID;
        return;
    }
}

// shift everything down
for (var i = 0; i < n - 1; i++) {
    entity.visible_routes[i] = entity.visible_routes[i + 1];
}

entity.visible_routes[n - 1] = route.GUID;