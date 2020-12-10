function uivc_mesh_collision_cell_y(input) {
    input.root.yy = real(input.value);
    input.root.el_y.value = input.root.yy / max(input.value_upper, 1);
    
    var mesh = slider.root.mesh;
    input.root.el_collision_triggers.value = mesh.asset_flags[input.root.xx][input.root.yy][input.root.zz];
}