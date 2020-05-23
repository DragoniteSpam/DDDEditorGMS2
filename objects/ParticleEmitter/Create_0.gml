name = "Emitter";

emitter = part_emitter_create(Stuff.particle.system);
region_shape = ps_shape_ellipse;
region_distribution = ps_distr_linear;
region_x1 = 160;
region_y1 = 160;
region_x2 = 240;
region_y2 = 240;

streaming = true;

enum PartEmitterShapes {
    RECTANGLE, ELLIPSE, DIAMOND, LINE
}

enum PartEmitterDistributions {
    LINEAR, GAUSSIAN, INVGAUSSIAN
}

emitter_shapes = [ps_shape_rectangle, ps_shape_ellipse, ps_shape_diamond, ps_shape_line];
emitter_distributions = [ps_distr_linear, ps_distr_gaussian, ps_distr_invgaussian];