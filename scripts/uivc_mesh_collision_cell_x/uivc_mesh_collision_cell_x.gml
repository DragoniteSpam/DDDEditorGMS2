function uivc_mesh_collision_cell_x(input) {
    input.root.xx = real(input.value);
    input.root.el_x.value = input.root.xx / max(input.value_upper, 1);
    
    var mesh = slider.root.mesh;
    input.root.el_collision_triggers.value = mesh.collision_flags[@ slider.root.xx][@ slider.root.yy][@ slider.root.zz];
}