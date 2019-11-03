var modulo = Stuff.water_reptition;

shader_set(shd_water_base);
transform_set(0, 0, -8, 0, 0, 0, 1, 1, 1);
texture_set_stage(shader_get_sampler_index(shd_water_base, "displacementMap"), sprite_get_texture(spr_water_displacement, 0));
shader_set_uniform_f(shader_get_uniform(shd_water_base, "displacement"), 0.0625);
shader_set_uniform_f_array(shader_get_uniform(shd_water_base, "time"), [current_time / 1000, current_time / 1000]);
vertex_submit(Stuff.mesh_water_base, pr_trianglelist, sprite_get_texture(spr_water_base, 0));
transform_reset();

shader_set(shd_water_bright);
texture_set_stage(shader_get_sampler_index(shd_water_base, "displacementMap"), sprite_get_texture(spr_water_displacement, 0));
shader_set_uniform_f(shader_get_uniform(shd_water_base, "displacement"), 0.0625);
shader_set_uniform_f_array(shader_get_uniform(shd_water_bright, "time"), [-current_time / 1000, current_time / 1000]);
vertex_submit(Stuff.mesh_water_bright, pr_trianglelist, sprite_get_texture(spr_water_base, 0));
shader_set_uniform_f_array(shader_get_uniform(shd_water_bright, "time"), [current_time / 1000, -current_time / 1000]);
vertex_submit(Stuff.mesh_water_bright, pr_trianglelist, sprite_get_texture(spr_water_base, 0));
shader_reset();
transform_reset();