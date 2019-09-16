/// @param UIList

var list = argument0;

if (Camera.event_map != Stuff.all_maps[| ui_list_selection(list)]) {
	var visible_map = Stuff.all_maps[| ui_list_selection(list)];
	
	if (Camera.event_map) {
		vertex_delete_buffer(Camera.event_map.preview);
		vertex_delete_buffer(Camera.event_map.wpreview);
		c_world_destroy_object(Camera.event_map.cpreview);
		c_shape_destroy(Camera.event_map.cspreview);
	}
	
	var data = list.root.node.custom_data[| 0];
	data[| 0] = visible_map.GUID;
	
	if (visible_map.preview) {
		vertex_delete_buffer(visible_map.preview);
		vertex_delete_buffer(visible_map.wpreview);
	}
	
	batch_all_preview(visible_map);
	
	Camera.event_map = visible_map;
}