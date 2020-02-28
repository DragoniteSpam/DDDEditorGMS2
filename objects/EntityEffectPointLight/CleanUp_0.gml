if (Stuff.is_quitting) exit;

event_inherited();

var map = Stuff.map.active_map;
var map_contents = map.contents;

for (var i = 0; i < MAX_LIGHTS; i++) {
    if (map_contents.active_lights[i] == REFID) {
        map_contents.active_lights[i] = noone;
    }
}