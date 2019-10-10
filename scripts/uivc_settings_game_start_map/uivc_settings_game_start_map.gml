/// @param UIThing

var thing = argument0;
var map = Stuff.all_maps[| thing.value];

Stuff.game_starting_map = map.GUID;

thing.root.el_x.value_upper = map.xx;
thing.root.el_y.value_upper = map.yy;
thing.root.el_z.value_upper = map.zz;

Stuff.game_starting_x = min(map.xx - 1, Stuff.game_starting_x);
Stuff.game_starting_y = min(map.yy - 1, Stuff.game_starting_y);
Stuff.game_starting_z = min(map.zz - 1, Stuff.game_starting_z);

thing.root.el_x.value = string(Stuff.game_starting_x);
thing.root.el_y.value = string(Stuff.game_starting_y);
thing.root.el_z.value = string(Stuff.game_starting_z);