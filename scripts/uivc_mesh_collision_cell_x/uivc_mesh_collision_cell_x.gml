function uivc_mesh_collision_cell_x(input) {
    input.root.xx = real(input.value);
    input.root.el_x.value = input.root.xx / max(input.value_upper, 1);
    
    var mesh = slider.root.mesh;
    input.root.el_collision_triggers.value = mesh.asset_flags[input.root.xx][input.root.yy][input.root.zz];
}