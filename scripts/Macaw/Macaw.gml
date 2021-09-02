#macro MACAW_VERSION "0.0.1"

global.__macaw_seed = 0;

function macaw_generate_dll(w, h, octaves) {
    var perlin = buffer_create(w * h * 4, buffer_fixed, 4);
    
    if (os_type == os_windows && os_browser == browser_not_a_browser) {
        __macaw_generate(buffer_get_address(perlin), w, h, octaves);
    } else {
        show_message("DLL version not supported on this target platform - please use the GML version instead");
    }
    
    return {
        noise: perlin,
        width: w,
        height: h,
    };
}

function macaw_generate(w, h, octave_count) {
    static macaw_white_noise = function(w, h) {
        var current_seed = random_get_seed();
        random_set_seed(global.__macaw_seed);
        var array = array_create(w * h);
        var i = 0;
        repeat (i) {
            var j = 0;
            repeat (h) {
                array[@ i * h + j++] = random(1);
            }
            i++;
        }
        random_set_seed(current_seed);
        return array;
    };
    
    static macaw_smooth_noise = function(base_noise, w, h, octave_count) {
        var base = w * h;
        
        static smooth_noise = buffer_create(10, buffer_fixed, 4);
        if (buffer_get_size(smooth_noise) != w * h * octave_count * 4) {
            buffer_resize(smooth_noise, w * h * octave_count * 4);
        }
        
        for (var octave = 0; octave < octave_count; octave++) {
            var period = 1 << octave;
            var frequency = 1 / period;
            
            var base_a = base * octave;
            
            var i = 0;
            repeat (w) {
                var i0 = (i div period) * period;
                var i1 = (i0 + period) % w;
                var hblend = (i - i0) * frequency;
                
                var base_b = base_a + i * h;
                
                var j = 0;
                repeat (h) {
                    var j0 = (j div period) * period;
                    var j1 = (j0 + period) % h;
                    var vblend = (j - j0) * frequency;
                    
                    var b00 = base_noise[i0 * h + j0];
                    var b10 = base_noise[i1 * h + j0];
                    var b01 = base_noise[i0 * h + j1];
                    var b11 = base_noise[i1 * h + j1];
                    
                    var top = lerp(b00, b10, hblend);
                    var bottom = lerp(b01, b11, hblend);
                    buffer_poke(smooth_noise, (base_b + j++) * 4, buffer_f32, lerp(top, bottom, vblend));
                }
                i++;
            }
        }
        
        return smooth_noise;
    };
    
    var base_noise = macaw_white_noise(w, h);
    var len = w * h * 4;
    var persistence = 0.5;
    var amplitude = 1;
    var total_amplitude = 0;
    
    var smooth_noise = macaw_smooth_noise(base_noise, w, h, octave_count);
    
    var perlin = buffer_create(len, buffer_fixed, 4);
    
    for (var o = octave_count - 1; o >= 0; o--) {
        amplitude *= persistence;
        total_amplitude += amplitude;
        var base_a = w * h * o;
        
        var i = 0;
        repeat (w) {
            var base_b = i++ * h;
            var j = 0;
            repeat (h) {
                buffer_poke(perlin, (base_b + j) * 4, buffer_f32, buffer_peek(perlin, (base_b + j) * 4, buffer_f32) + buffer_peek(smooth_noise, (base_a + base_b + j) * 4, buffer_f32) * amplitude);
                j++;
            }
        }
    }
    
    var index = 0;
    repeat (len / 4) {
        buffer_poke(perlin, index, buffer_f32, buffer_peek(perlin, index, buffer_f32) / total_amplitude);
        index += 4;
    }
    
    return {
        noise: perlin,
        width: w,
        height: h,
    }
}

function macaw_to_sprite(macaw) {
    var buffer = buffer_create(macaw.width * macaw.height * 4, buffer_fixed, 4);
    var noise = macaw.noise;
    buffer_seek(noise, buffer_seek_start, 0);
    repeat (macaw.width * macaw.height) {
        var intensity = floor(buffer_read(noise, buffer_f32) * 255);
        var c = 0xff000000 | make_colour_rgb(intensity, intensity, intensity);
        buffer_write(buffer, buffer_u32, c);
    }
    var surface = surface_create(macaw.width, macaw.height);
    buffer_set_surface(buffer, surface, 0);
    var spr = sprite_create_from_surface(surface, 0, 0, macaw.width, macaw.height, false, false, 0, 0);
    surface_free(surface);
    buffer_delete(buffer);
    return spr;
}

function macaw_destroy(macaw) {
    buffer_delete(macaw.noise);
}

function macaw_version() {
    show_debug_message("Macaw GML version: " + MACAW_VERSION);
    if (os_type == os_windows && os_browser == browser_not_a_browser) {
        show_debug_message("Macaw DLL version: " + __macaw_version());
    } else {
        show_debug_message("Macaw DLL version: N/A");
    }
}

function macaw_set_seed(seed) {
    global.__macaw_seed = seed;
    __macaw_set_seed(seed);
}

macaw_version();