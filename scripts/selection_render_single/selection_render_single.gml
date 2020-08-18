/// @param SelectionSingle
function selection_render_single(argument0) {

	var selection = argument0;

	var xx = selection.x * TILE_WIDTH;
	var yy = selection.y * TILE_HEIGHT;
	var zz = selection.z * TILE_DEPTH;

	shader_set(shd_bounding_box);
	shader_set_uniform_f_array(shader_get_uniform(shd_bounding_box, "actual_color"), [1, 0, 0, 1]);
	shader_set_uniform_f_array(shader_get_uniform(shd_bounding_box, "offsets"), [
	    xx, yy, zz,
	    xx, yy, zz,
	    xx, yy, zz,
	    xx, yy, zz,
	    xx, yy, zz,
	    xx, yy, zz,
	    xx, yy, zz,
	    xx, yy, zz,
	]);

	vertex_submit(Stuff.graphics.indexed_cage, pr_trianglelist, -1);
	shader_reset();


}
