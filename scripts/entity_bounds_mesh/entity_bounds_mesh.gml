function entity_bounds_mesh(mesh) {
    var mesh_data = guid_get(mesh.mesh);
    return new BoundingBox(mesh.xx + mesh_data.xmin, mesh.yy + mesh_data.ymin, mesh.zz + mesh_data.zmin, mesh.xx + mesh_data.xmax, mesh.yy + mesh_data.ymax, mesh.zz + mesh_data.zmax);
}