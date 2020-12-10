function uivc_mesh_collision_cell_y_slider(slider) {
    var input = slider.root.el_y_input;
    slider.root.yy = round(slider.value * input.value_upper);
    input.value = string(slider.root.yy);
    
    var mesh = slider.root.mesh;
    input.root.el_collision_triggers.value = mesh.collision_flags[@ slider.root.xx][@ slider.root.yy][@ slider.root.zz];
}