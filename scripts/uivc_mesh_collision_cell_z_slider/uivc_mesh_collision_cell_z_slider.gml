function uivc_mesh_collision_cell_z_slider(slider) {
    var input = slider.root.el_z_input;
    slider.root.zz = round(slider.value * input.value_upper);
    input.value = string(slider.root.zz);
    
    var mesh = slider.root.mesh;
    input.root.el_collision_triggers.value = mesh.collision_flags[@ slider.root.xx][@ slider.root.yy][@ slider.root.zz];
}