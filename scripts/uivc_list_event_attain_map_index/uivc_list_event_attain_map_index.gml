/// @param UIList

var list = argument0;
var visible_map = Stuff.all_maps[| ui_list_selection(list)];

vertex_delete_buffer(Camera.event_map.preview);
vertex_delete_buffer(Camera.event_map.wpreview);

var data = list.root.node.custom_data[| 0];
data[| 0] = visible_map.GUID;

if (visible_map.preview) {
	vertex_delete_buffer(visible_map.preview);
	vertex_delete_buffer(visible_map.wpreview);
}
batch_all_preview(visible_map);
Camera.event_map = visible_map;