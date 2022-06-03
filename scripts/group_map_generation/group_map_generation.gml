function map_generate_contents(total, choices) {
    debug_timer_start();
    
    static to_place = ds_list_create();
    ds_list_clear(to_place);
    
    var map = Stuff.map.active_map;
    var terrain = guid_get(map.terrain.id).terrain_data;
    var w = terrain.w;
    var h = terrain.h;
    var total_weights = 0;
    
    var xs = map.terrain.scale / TILE_WIDTH;
    var ys = map.terrain.scale / TILE_HEIGHT;
    var zs = map.terrain.scale / TILE_DEPTH;
    
    // total weights of everything that you want to place
    for (var i = 0, n = array_length(choices); i < n; i++) {
        total_weights += choices[i].weight;
    }
    
    // populate a list of every mesh choice to place
    for (var i = 0, n = array_length(choices); i < n; i++) {
        repeat (floor(choices[i].weight / total_weights * total)) {
            ds_list_add(to_place, choices[i]);
        }
    }
    
    var placed = 0;
    
    // for each choice, attempt to place it somewhere
    for (var i = 0, n = ds_list_size(to_place); i < n; i++) {
        var choice = to_place[| i];
        var xx = random(w);
        var yy = random(h);
        
        // transpose the x and y - the heightmaps are laid out in the reverse
        // order of sprite pixel grids, which i guess i could change, but i
        // dont feel like it right now
        var height = buffer_sample_pixel(terrain.heightmap, yy, xx, w, h, buffer_f32);
        
        var xoff = random_range(choice.spawn.offset.min_x, choice.spawn.offset.max_x);
        var yoff = random_range(choice.spawn.offset.min_y, choice.spawn.offset.max_y);
        var zoff = random_range(choice.spawn.offset.min_z, choice.spawn.offset.max_z);
        
        var mesh = new EntityMesh("Mesh", guid_get(choice.mesh));
        mesh.rot_xx = random_range(choice.spawn.rotation.min_x, choice.spawn.rotation.max_x);
        mesh.rot_yy = random_range(choice.spawn.rotation.min_y, choice.spawn.rotation.max_y);
        mesh.rot_zz = random_range(choice.spawn.rotation.min_z, choice.spawn.rotation.max_z);
        mesh.scale_xx = random_range(choice.spawn.scale.min_scale, choice.spawn.scale.max_scale);
        mesh.scale_yy = mesh.scale_xx;
        mesh.scale_zz = mesh.scale_zz;
        map.Add(mesh, xx * xs + xoff, yy * ys + yoff, height * zs + zoff);
        
        placed++;
    }
    
    Stuff.AddStatusMessage("Placing " + string(placed) + " entities took " + debug_timer_finish());
}