function uivc_mesh_collision_cell_z(input) {
    input.root.zz = real(input.value);
    input.root.el_z.value = input.root.zz / max(input.value_upper, 1);
    
    var mesh = slider.root.mesh;
    input.root.el_collision_triggers.value = mesh.collision_flags[@ slider.root.xx][@ slider.root.yy][@ slider.root.zz];
}