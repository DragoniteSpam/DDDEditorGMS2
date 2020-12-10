function data_mesh_recalculate_bounds(mesh) {
    var xx = mesh.xmax - mesh.xmin;
    var yy = mesh.ymax - mesh.ymin;
    var zz = mesh.zmax - mesh.zmin;
    array_resize(mesh.asset_flags, xx);
    for (var i = 0; i < xx; i++) {
        if (!is_array(mesh.asset_flags[i])) {
            mesh.asset_flags[@ i] = array_create(yy);
        } else {
            array_resize(mesh.asset_flags[@ i], yy);
        }
        for (var j = 0; j < yy; j++) {
            if (!is_array(mesh.asset_flags[i][j])) {
                mesh.asset_flags[@ i][@ j] = array_create(zz);
            } else {
                array_resize(mesh.asset_flags[@ i][@ j], zz);
            }
        }
    }
}