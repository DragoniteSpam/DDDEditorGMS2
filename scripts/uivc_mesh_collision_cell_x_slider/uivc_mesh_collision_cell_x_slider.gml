function uivc_mesh_collision_cell_x_slider(slider) {
    var input = slider.root.el_x_input;
    slider.root.xx = round(slider.value * input.value_upper);
    input.value = string(slider.root.xx);
    
    var mesh = slider.root.mesh;
    input.root.el_collision_triggers.value = mesh.collision_flags[@ slider.root.xx][@ slider.root.yy][@ slider.root.zz];
}