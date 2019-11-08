/// @param EntityTile

var tile = argument0;

var ns = instance_create_depth(0, 0, 0, SelectionSingle);
ns.who = tile;

ds_list_add(Stuff.map.selection, ns);