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
        
        map.Add(new EntityMesh("Mesh", guid_get(choice.mesh)), xx * xs, yy * ys, height * zs);
        
        placed++;
    }
    
    Stuff.AddStatusMessage("Placing " + string(placed) + " entities took " + debug_timer_finish());
}