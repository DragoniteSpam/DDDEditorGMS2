/// @param Entity
/// @param DataMoveRoute

var n = array_length_1d(argument0.visible_routes);

// are you already visible?
for (var i = 0; i < n; i++) {
    if (argument0.visible_routes[i] == argument1.GUID) {
        return 0;
    }
}

// are there any open slots?
for (var i = 0; i < n; i++) {
    if (!guid_get(argument0.visible_routes[i])) {
        argument0.visible_routes[i] = argument1.GUID;
        return 0;
    }
}

// shift everything down
for (var i = 0; i < n - 1; i++) {
    argument0.visible_routes[i] = argument0.visible_routes[i + 1];
}

argument0.visible_routes[n - 1] = argument1.GUID;