/// @param EntityMesh

var entity = argument0;
var mesh = guid_get(entity.mesh);

transform_set(0, 0, 0, entity.rot_xx, entity.rot_yy, entity.rot_zz, 1, 1, 1);
transform_add(0, 0, 0, 0, 0, 0, entity.scale_xx, entity.scale_yy, entity.scale_zz);
transform_add((entity.xx + entity.off_xx) * TILE_WIDTH, (entity.yy + entity.off_yy) * TILE_HEIGHT, (entity.zz + entity.off_zz) * TILE_DEPTH, 0, 0, 0, 1, 1, 1);

if (Camera.view_entities) {
    if (entity.animated || true) {
        var animation_index = 0;
        var animation_type = 0;
        var sample = smf_sample_create(mesh.vbuffer, animation_index, animation_type, current_time / 1000);
        smf_model_draw(mesh.vbuffer, sample);
    } else {
        smf_model_draw(mesh.vbuffer);
    }
    shader_set(shd_default);
}

transform_reset();

/*Some obvious things to do next:
 - Lights can be added
    o as such, the terrain and NPCs and normally drawn stuff should have the smf light code reflectd (lol)
        in their shader, and they should be able to use the smf lights, so that it looks consistent
 - SMF meshes still can't be saved properly; be sure to save both the buffer (which is just a buffer),
    the type (which is probably a u8 and should be saved before everything else so the program knows what
    it needs to load) and the animation parameter - there will probably be more of these in the future,
    but the boolean is fine for now*/