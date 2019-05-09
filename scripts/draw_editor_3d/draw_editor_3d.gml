if (mouse_within_view(view_3d)&&!dialog_exists()){
    control_3d();
}

d3d_start();
gpu_set_cullmode(view_backface ? cull_noculling : cull_counterclockwise);
gpu_set_ztestenable(ActiveMap.is_3d);        // this will make things rather odd with the wrong setting

// todo GMS2 requires smooth shading to be handled by the shader(s) now,
// so to make porting this to GMS2 as pain-free as possible I'd like to
// do it that way here at some point in the future too

draw_set_color(c_white);

if (ActiveMap.is_3d){
    d3d_set_projection_ext(x, y, z, xto, yto, zto, xup, yup, zup, fov, CW/CH, 1, 32000);
} else {
    var cwidth=__view_get( e__VW.WView, view_3d );
    var cheight=__view_get( e__VW.HView, view_3d );
    d3d_set_projection_ortho(x-cwidth/2, y-cheight/2, cwidth, cheight, 0);
}

// anything in the world

// the autotile shader doesn't work yet and it's annoying
//shader_set(shd_default_autotile);
//shader_set_uniform_f_array(shd_uniform_at_tex_offset, shd_value_at_tex_offset);

shader_set(shd_default);
//shader_reset();

// this will need to be dynamic at some point
if (view_texture){
    var tex=sprite_get_texture(get_active_tileset().master, 0);
} else {
    var tex=sprite_get_texture(b_tileset_textureless, 0);
}
// todo separate batches for Tiles (including autotiles) and Meshes so that they can
// be masked correctly
for (var i=0; i<ds_list_size(ActiveMap.batches); i++){
    if (view_entities){
        vertex_submit(ActiveMap.batches[| i], pr_trianglelist, tex);
    }
    if (view_wireframe){
        vertex_submit(ActiveMap.batches_wire[| i], pr_linelist, -1);
    }
}
for (var i=0; i<ds_list_size(ActiveMap.batch_in_the_future); i++){
    var ent=ActiveMap.batch_in_the_future[| i];
    script_execute(ent.render, ent);
    // batchable entities don't make use of move routes, so don't bother
}

var list_routes=ds_list_create();       // [buffer, x, y, z, extra?, extra x, extra y, extra z], positions are absolute

for (var i=0; i<ds_list_size(ActiveMap.dynamic); i++){
    var ent=ActiveMap.dynamic[| i];
    script_execute(ent.render, ent);
    for (var j=0; j<MAX_VISIBLE_MOVE_ROUTES; j++){
        var route=guid_get(ent.visible_routes[j]);
        if (route!=noone&&route.buffer!=noone){
            ds_list_add(list_routes, [route.buffer, (ent.xx+0.5)*TILE_WIDTH, (ent.yy+0.5)*TILE_HEIGHT, (ent.zz+0.5)*TILE_DEPTH,
                route.extra, route.extra_xx, route.extra_yy, route.extra_zz]);
        }
    }
}

shader_reset();
gpu_set_cullmode(cull_noculling);

// because apparently you can't do color with a passthrough shader even though it has a color attribute
for (var i=0; i<ds_list_size(list_routes); i++){
    var data=list_routes[| i];
    transform_set(data[@ 1], data[@ 2], data[@ 3], 0, 0, 0, 1, 1, 1);
    vertex_submit(data[@ 0], pr_linestrip, -1);
    if (data[@ 4]){
        transform_set(0, 0, 0, 90, 0, point_direction(x, y, data[@ 1]+data[@ 5], data[@ 2]+data[@ 6])-90, 1, 1, 1);
        transform_add(data[@ 1]+data[@ 5], data[@ 2]+data[@ 6], data[@ 3]+data[@ 7], 0, 0, 0, 1, 1, 1);
        draw_sprite_ext(spr_plus_minus, 0, 0, 0, 0.25, 0.25, 0, c_lime, 1);
    }
}

// "set" overwrites the previous transform anyway
transform_set(0, 0, 0.5, 0, 0, 0, 1, 1, 1);

// the grid, which you may want an option to turn this off if it gets annoying
if (view_grid){
    vertex_submit(grid, pr_linelist, -1);
}

// tried using ztestenable for this - didn't look good. at all.
for (var i=0; i<ds_list_size(selection); i++){
    var sel=selection[| i];
    script_execute(sel.render, sel);
}

transform_reset();

ds_list_destroy(list_routes);
