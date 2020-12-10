function uivc_mesh_collision_cell_z(input) {
    input.root.zz = real(input.value);
    input.root.el_z.value = input.root.zz / max(input.value_upper, 1);
    
    var mesh = slider.root.mesh;
    input.root.el_collision_triggers.value = mesh.asset_flags[input.root.xx][input.root.yy][input.root.zz];
}