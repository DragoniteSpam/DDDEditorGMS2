// Feather disable all
function __d3d_wall_internal(vb, x1, y1, z1, x2, y2, z2, hrepeat, vrepeat, c, a) {
    static vertex = Drago3D_Internals.Vertex;
    
    var xdiff = x2 - x1;
    var ydiff = y2 - y1;
    var l = point_distance(xdiff, ydiff, 0, 0);
    var nx = ydiff / l;
    var ny = -xdiff / l;
    
    vertex(vb, x1, y1, z1, nx, ny, 0, 0, 0, c, a);
    vertex(vb, x2, y2, z1, nx, ny, 0, hrepeat, 0, c, a);
    vertex(vb, x2, y2, z2, nx, ny, 0, hrepeat, vrepeat, c, a);
    vertex(vb, x2, y2, z2, nx, ny, 0, hrepeat, vrepeat, c, a);
    vertex(vb, x1, y1, z2, nx, ny, 0, 0, vrepeat, c, a);
    vertex(vb, x1, y1, z1, nx, ny, 0, 0, 0, c, a);
}