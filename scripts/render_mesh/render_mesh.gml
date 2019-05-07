/// @description  void render_mesh(EntityMesh);
/// @param EntityMesh

var mesh=argument0;

transform_set(0, 0, 0, mesh.rot_xx, mesh.rot_yy, mesh.rot_zz, 1, 1, 1);
transform_add(0, 0, 0, 0, 0, 0, mesh.scale_xx, mesh.scale_yy, mesh.scale_zz);
transform_add((mesh.xx+mesh.off_xx)*TILE_WIDTH, (mesh.yy+mesh.off_yy)*TILE_HEIGHT, (mesh.zz+mesh.off_zz)*TILE_DEPTH, 0, 0, 0, 1, 1, 1);

if (Camera.view_entities){
    if (Camera.view_texture){
        var tex=sprite_get_texture(get_active_tileset().master, 0);
    } else {
        var tex=sprite_get_texture(b_tileset_textureless, 0)
    }
    
    vertex_submit(mesh.mesh_data[@ MeshArrayData.VBUFF], pr_trianglelist, tex);
}

if (Camera.view_wireframe){
    vertex_submit(mesh.mesh_data[@ MeshArrayData.VBUFF_WIREFRAME], pr_linelist, -1);
}

transform_reset();
