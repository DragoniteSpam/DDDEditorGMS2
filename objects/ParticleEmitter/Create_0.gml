name = "Emitter";

emitter = part_emitter_create(Stuff.particle.system);
region_shape = ps_shape_ellipse;
region_dist = ps_distr_linear;
region_x1 = 160;
region_y1 = 160;
region_x2 = 240;
region_y2 = 240;

streaming = true;