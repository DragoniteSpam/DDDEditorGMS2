/// @description  void select_tile(EntityTile);
/// @param EntityTile

var ns=instance_create(0, 0, SelectionSingle);
ns.who=argument0;

ds_list_add(selection, ns);
