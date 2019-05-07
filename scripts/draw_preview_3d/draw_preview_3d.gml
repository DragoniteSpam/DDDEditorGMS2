control_3d_preview();

d3d_start();
d3d_set_culling(!view_backface);
d3d_set_hidden(true);
draw_set_color(c_white);

var s=128;

d3d_set_projection_ext(0, s, s/2, 0, 0, 0, 0, 0, 1,
    fov, __view_get( e__VW.WView, view_3d_preview )/__view_get( e__VW.HView, view_3d_preview ), 1, s*s);

// draw the grid, and any other reference points
vertex_submit(mesh_preview_grid, pr_linelist, -1);

// draw the mesh
var tex=sprite_get_texture(get_active_tileset().master, 0);
matrix_set(matrix_world, matrix_build(mesh_x, mesh_y, mesh_z, mesh_xrot, mesh_yrot, mesh_zrot, mesh_scale, mesh_scale, mesh_scale));
vertex_submit(mesh_preview[MeshArrayData.VBUFF], pr_trianglelist, tex);

// draw the wireframe
d3d_set_depth(1);
vertex_submit(mesh_preview[MeshArrayData.VBUFF_WIREFRAME], pr_linelist, tex);

// clean up
d3d_set_depth(0);
matrix_set(matrix_world, matrix_build(0, 0, 0, 0, 0, 0, 1, 1, 1));
