// Feather disable all
function __d3d_floor_internal(vb, x1, y1, z1, x2, y2, z2, hrepeat, vrepeat, c, a) {
    static vertex = Drago3D_Internals.Vertex;
    
    var xdiff = x2 - x1;
    var zdiff = z2 - z1;
    var l = point_distance(xdiff, zdiff, 0, 0);
    var nx = -zdiff / l;
    var nz = xdiff / l;
    
    vertex(vb, x1, y1, z1, nx, 0, nz, 0, 0, c, a);
    vertex(vb, x1, y2, z1, nx, 0, nz, 0, vrepeat, c, a);
    vertex(vb, x2, y2, z2, nx, 0, nz, hrepeat, vrepeat, c, a);
    vertex(vb, x2, y2, z2, nx, 0, nz, hrepeat, vrepeat, c, a);
    vertex(vb, x2, y1, z2, nx, 0, nz, hrepeat, 0, c, a);
    vertex(vb, x1, y1, z1, nx, 0, nz, 0, 0, c, a);
}