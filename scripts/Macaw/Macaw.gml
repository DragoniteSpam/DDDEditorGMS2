#macro MACAW_VERSION "0.0.1"

function macaw_white_noise(w, h) {
    var array = array_create(w);
    for (var i = 0; i < w; i++) {
        var a = array_create(h);
        array[@ i] = a;
        for (var j = 0; j < h; j++) {
            a[@ j] = random(1);
        }
    }
    return array;
}

function macaw_generate(base_noise, octave_count) {
    static macaw_smooth_noise = function(base_noise, octave) {
        var w = array_length(base_noise);
        var h = array_length(base_noise[0]);
        var smooth_noise = array_create(w);
        var period = 1 << octave;
        var frequency = 1 / period;
        
        for (var i = 0; i < w; i++) {
            var i0 = (i div period) * period;
            var i1 = (i0 + period) % w;
            var hblend = (i - i0) * frequency;
            var a = array_create(h);
            smooth_noise[@ i] = a;
            var b0 = base_noise[i0];
            var b1 = base_noise[i1];
            
            for (var j = 0; j < h; j++) {
                var j0 = (j div period) * period;
                var j1 = (j0 + period) % h;
                var vblend = (j - j0) * frequency;
                
                var top = lerp(b0[j0], b1[j0], hblend);
                var bottom = lerp(b0[j1], b1[j1], hblend);
                a[@ j] = lerp(top, bottom, vblend);
            }
        }
        
        return smooth_noise;
    }

    var w = array_length(base_noise);
    var h = array_length(base_noise[0]);
    var persistence = 0.5;
    var amplitude = 1;
    var total_amplitude = 0;
    
    var smooth_noise = array_create(octave_count);
    for (var i = 0; i < octave_count; i++) {
        smooth_noise[@ i] = macaw_smooth_noise(base_noise, i);
    }
    
    var perlin = array_create(w, 0);
    for (var i = 0; i < w; i++) {
        perlin[@ i] = array_create(h, 0);
    }
    
    for (var o = octave_count - 1; o >= 0; o--) {
        amplitude *= persistence;
        total_amplitude += amplitude;
        var sm = smooth_noise[o];
        
        for (var i = 0; i < w; i++) {
            var a = perlin[i];
            var b = sm[i];
            for (var j = 0; j < h; j++) {
                a[@ j] += b[j] * amplitude;
            }
        }
    }
    
    for (var i = 0; i < w; i++) {
        var a = perlin[@ i];
        for (var j = 0; j < h; j++) {
            a[@ j] /= total_amplitude;
        }
    }
    
    return perlin;
}

function macaw_to_sprite(noise) {
    var w = array_length(noise);
    var h = array_length(noise[0]);
    var buffer = buffer_create(w * h * 4, buffer_fixed, 4);
    for (var j = 0; j < h; j++) {
        for (var i = 0; i < w; i++) {
            var idx = (i * h + j) * 4;
            var intensity = floor(noise[i][j] * 255);
            var c = 0xff000000 | make_colour_rgb(intensity, intensity, intensity);
            buffer_poke(buffer, idx, buffer_u32, c);
        }
    }
    var surface = surface_create(w, h);
    buffer_set_surface(buffer, surface, 0);
    var spr = sprite_create_from_surface(surface, 0, 0, w, h, false, false, 0, 0);
    surface_free(surface);
    buffer_delete(buffer);
    return spr;
}

function macaw_version() {
    show_debug_message("Macaw GML version: " + MACAW_VERSION);
}

macaw_version();