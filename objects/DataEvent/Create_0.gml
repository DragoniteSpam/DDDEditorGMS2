event_inherited();

nodes = ds_list_create();
name_map = ds_map_create();
event_create_node(id, EventNodeTypes.ENTRYPOINT, 64, 64);

ds_list_add(Stuff.all_events, id);