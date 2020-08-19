/// @description stdf_init()
function stdf_init() {
    vertex_format_begin();
    vertex_format_add_position_3d();
    vertex_format_add_normal();
    vertex_format_add_texcoord();
    vertex_format_add_colour();
    global.stdFormat = vertex_format_end();


}
