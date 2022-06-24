function map_generate_contents(total, choices) {
    debug_timer_start();
    
    static to_place = ds_list_create();
    ds_list_clear(to_place);
    
    var map = Stuff.map.active_map;
    var terrain = guid_get(map.terrain.id).terrain_data;
    var w = terrain.w;
    var h = terrain.h;
    var total_weights = 0;
    
    // idk if you'll need these values or not
    var min_height = terrain.min_height * map.terrain.scale;
    var max_height = terrain.max_height * map.terrain.scale;
    
    var gen_data = Game.nosave.map_terrain_gen;
    var terrain_noise = sprite_add_from_channels(
        gen_data.tex_r, gen_data.tex_g, gen_data.tex_b, gen_data.tex_size, gen_data.tex_size,
        Game.nosave.map_terrain_gen.bands_r, Game.nosave.map_terrain_gen.bands_g, Game.nosave.map_terrain_gen.bands_b
    );
    
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
    static placement_attempts = 25;
    
    // get the spawn odds, accounting for clustering settings
    static get_spawn_odds = function(choice, x, y, w, h, heightmap, scale, noisemap) {
        var noise = sprite_sample(noisemap, 0, x / w, y / h);
        var param_temperature = colour_get_red(noise) / 0xff;
        var param_precipitation = colour_get_green(noise) / 0xff;
        var param_misc = colour_get_blue(noise) / 0xff;
        // transpose the x and y
        var param_elevation = buffer_sample_pixel(heightmap, y, x, w, h, buffer_f32) * scale;
        
        static get_cluster_value = function(cluster_data, param) {
            if (!cluster_data.enabled) return 1;
            var dist = abs(param - cluster_data.cluster);
            return cos(min(dist, cluster_data.falloff) / cluster_data.falloff * pi / 2);
        };
        
        var cluster_temperature = get_cluster_value(choice.temperature, param_temperature);
        var cluster_precipitation = get_cluster_value(choice.precipitation, param_precipitation);
        var cluster_misc = get_cluster_value(choice.misc, param_misc);
        var cluster_elevation = get_cluster_value(choice.elevation, param_elevation);
        
        return cluster_temperature * cluster_precipitation * cluster_misc * cluster_elevation;
    };
    
    // for each choice, attempt to place it somewhere
    for (var i = 0, n = ds_list_size(to_place); i < n; i++) {
        var choice = to_place[| i];
        
        repeat (placement_attempts) {
            var xx = random(w);
            var yy = random(h);
            
            if (random(1) < get_spawn_odds(choice, xx, yy, w, h, terrain.heightmap, map.terrain.scale, terrain_noise)) {
                // transpose the x and y - the heightmaps are laid out in the reverse
                // order of sprite pixel grids, which i guess i could change, but i
                // dont feel like it right now
                var height = buffer_sample_pixel(terrain.heightmap, yy, xx, w, h, buffer_f32);
            
                var xoff = random_range(choice.spawn.offset.min_x, choice.spawn.offset.max_x);
                var yoff = random_range(choice.spawn.offset.min_y, choice.spawn.offset.max_y);
                var zoff = random_range(choice.spawn.offset.min_z, choice.spawn.offset.max_z);
            
                var mesh = new EntityMesh("Mesh", guid_get(choice.mesh));
                mesh.is_static = true;
                mesh.rot_xx = random_range(choice.spawn.rotation.min_x, choice.spawn.rotation.max_x);
                mesh.rot_yy = random_range(choice.spawn.rotation.min_y, choice.spawn.rotation.max_y);
                mesh.rot_zz = random_range(choice.spawn.rotation.min_z, choice.spawn.rotation.max_z);
                mesh.scale_xx = random_range(choice.spawn.scale.min_scale, choice.spawn.scale.max_scale);
                mesh.scale_yy = mesh.scale_xx;
                mesh.scale_zz = mesh.scale_zz;
                mesh.texture = random_element_from_array(choice.spawn.textures) ?? NULL;
                map.Add(mesh, xx * xs + xoff, yy * ys + yoff, height * zs + zoff);
                
                placed++;
                break;
            }
        }
    }
    
    sprite_sample_remove_from_cache(terrain_noise, 0);
    sprite_delete(terrain_noise);
    
    Stuff.AddStatusMessage("Placing " + string(placed) + " entities took " + debug_timer_finish());
}