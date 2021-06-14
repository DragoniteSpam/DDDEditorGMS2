function ParticleType(name) constructor {
    self.name = name;
    self.type = part_type_create();
    
    self.sprite_custom = false;
    self.shape = PartTypeShapes.SPHERE;
    self.part_type_shape(type, pt_shape_sphere);
    self.sprite = NULL;
    self.sprite_animated = false;
    self.sprite_stretched = false;
    self.sprite_random = false;
    
    self.speed_min = 0;
    self.speed_max = 0;
    self.speed_incr = 0;
    self.speed_wiggle = 0;
    part_type_speed(self.type, self.speed_min, self.speed_max, self.speed_incr, self.speed_wiggle);
    
    self.direction_min = 0;
    self.direction_max = 0;
    self.direction_incr = 0;
    self.direction_wiggle = 0;
    part_type_direction(self.type, self.direction_min, self.direction_max, self.direction_incr, self.direction_wiggle);
    
    self.gravity = 0.25;
    self.gravity_direction = 270;
    part_type_gravity(self.type, self.gravity, self.gravity_direction);
    
    self.orientation_min = 0;
    self.orientation_max = 0;
    self.orientation_incr = 0;
    self.orientation_wiggle = 0;
    self.orientation_relative = 0;
    part_type_orientation(self.type, self.orientation_min, self.orientation_max, self.orientation_incr, self.orientation_wiggle, self.orientation_relative);
    
    self.color_1a = c_white;
    self.alpha_1 = 1;
    self.color_1b = c_white;
    self.color_1b_enabled = false;
    self.color_2 = c_white;
    self.alpha_2 = 1;
    self.color_2_enabled = false;
    self.color_3 = c_white;
    self.alpha_3 = 1;
    self.color_3_enabled = false;
    self.blend = false;
    
    self.size_min = 1;
    self.size_max = 1;
    self.size_incr = 0;
    self.size_wiggle = 0;
    part_type_size(self.type, self.size_min, self.size_max, self.size_incr, self.size_wiggle);
    
    self.xscale = 1;
    self.yscale = 1;
    part_type_scale(self.type, self.xscale, self.yscale);
    
    self.life_min = 2;
    self.life_max = 2;
    var f = game_get_speed(gamespeed_fps);
    part_type_life(self.type, self.life_min * f, self.life_max * f);
    
    self.update_type = noone;
    self.update_rate = 60;
    self.death_type = noone;
    self.death_rate = 10;
    
    enum PartTypeShapes {
        PIXEL, DISK, SQUARE, LINE, STAR, CIRCLE, RING, SPHERE, FLARE, SPARK, EXPLOSION, CLOUD, SMOKE, SNOW,
    }
    
    self.type_shapes = [pt_shape_pixel, pt_shape_disk, pt_shape_square, pt_shape_line, pt_shape_star, pt_shape_circle, pt_shape_ring, pt_shape_sphere, pt_shape_flare, pt_shape_spark, pt_shape_explosion, pt_shape_cloud, pt_shape_smoke, pt_shape_snow];
    
    static Destroy = function() {
        part_type_destroy(self.type);
    };
}

function ParticleEmitter(name) constructor {
    self.name = "Emitter";
    
    self.emitter = part_emitter_create(Stuff.particle.system);
    self.region_shape = PartEmitterShapes.ELLIPSE;
    self.region_distribution = PartEmitterDistributions.LINEAR;
    self.region_x1 = 160;
    self.region_y1 = 160;
    self.region_x2 = 240;
    self.region_y2 = 240;
    
    self.streaming = false;
    self.rate = 120;
    self.type = noone;
    
    self.draw_region = false;
    self.region = vertex_create_buffer();
    editor_particle_emitter_create_region(self);
    
    enum PartEmitterShapes {
        RECTANGLE, ELLIPSE, DIAMOND, LINE
    }
    
    enum PartEmitterDistributions {
        LINEAR, GAUSSIAN, INVGAUSSIAN
    }
    
    self.emitter_shapes = [ps_shape_rectangle, ps_shape_ellipse, ps_shape_diamond, ps_shape_line];
    self.emitter_distributions = [ps_distr_linear, ps_distr_gaussian, ps_distr_invgaussian];

    static Destroy = function() {
        part_emitter_destroy(Stuff.particle.system, self.emitter);
        vertex_delete_buffer(self.region);
    };
}