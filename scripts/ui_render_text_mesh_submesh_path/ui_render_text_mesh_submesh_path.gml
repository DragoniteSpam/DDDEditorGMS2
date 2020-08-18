/// @param UIText
/// @param x
/// @param y
function ui_render_text_mesh_submesh_path(argument0, argument1, argument2) {

	var text = argument0;
	var xx = argument1;
	var yy = argument2;
	var selection = ui_list_selection(text.root.el_list);
	var mesh_data = text.root.mesh;
	var base_text = text.text;

	if (selection + 1) {
	    if (mesh_data.submeshes[| selection].path == "") {
	        var str = "<no path saved>";
	    } else {
	        var str = mesh_data.submeshes[| selection].path;
	    }
	} else {
	    var str = "";
	}

	text.text = "";
	for (var i = string_length(str); i > 0; i--) {
	    text.text = string_char_at(str, i) + text.text;
	    if (string_width(text.text) > (text.wrap_width - string_width("...") - text.offset)) {
	        if (i < string_length(str)) {
	            text.text = "..." + text.text;
	        }
	        break;
	    }
	}
	text.tooltip = str;

	ui_render_text(text, xx, yy);
	text.text = base_text;


}
