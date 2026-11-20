// Feather disable all
function __d3d_block_wireframe_internal(vb, x1, y1, z1, x2, y2, z2, hrepeat, vrepeat, c, a) {
    static vertex = Drago3D_Internals.Vertex;
    
    vertex(vb, x1, y1, z1, 0, 0, -1, 0, 0, c, a);
    vertex(vb, x1, y2, z1, 0, 0, -1, 0, vrepeat, c, a);
    vertex(vb, x1, y2, z1, 0, 0, -1, 0, vrepeat, c, a);
    vertex(vb, x2, y2, z1, 0, 0, -1, hrepeat, vrepeat, c, a);
    vertex(vb, x2, y2, z1, 0, 0, -1, hrepeat, vrepeat, c, a);
    vertex(vb, x1, y1, z1, 0, 0, -1, 0, 0, c, a);
    
    vertex(vb, x2, y2, z1, 0, 0, -1, hrepeat, vrepeat, c, a);
    vertex(vb, x2, y1, z1, 0, 0, -1, hrepeat, 0, c, a);
    vertex(vb, x2, y1, z1, 0, 0, -1, hrepeat, 0, c, a);
    vertex(vb, x1, y1, z1, 0, 0, -1, 0, 0, c, a);
    vertex(vb, x1, y1, z1, 0, 0, -1, 0, 0, c, a);
    vertex(vb, x2, y2, z1, 0, 0, -1, hrepeat, vrepeat, c, a);
    
    vertex(vb, x1, y1, z2, 0, 0, 1, 0, 0, c, a);
    vertex(vb, x2, y1, z2, 0, 0, 1, hrepeat, 0, c, a);
    vertex(vb, x2, y1, z2, 0, 0, 1, hrepeat, 0, c, a);
    vertex(vb, x2, y2, z2, 0, 0, 1, hrepeat, vrepeat, c, a);
    vertex(vb, x2, y2, z2, 0, 0, 1, hrepeat, vrepeat, c, a);
    vertex(vb, x1, y1, z2, 0, 0, 1, 0, 0, c, a);
    
    vertex(vb, x2, y2, z2, 0, 0, 1, hrepeat, vrepeat, c, a);
    vertex(vb, x1, y2, z2, 0, 0, 1, 0, vrepeat, c, a);
    vertex(vb, x1, y2, z2, 0, 0, 1, 0, vrepeat, c, a);
    vertex(vb, x1, y1, z2, 0, 0, 1, 0, 0, c, a);
    vertex(vb, x1, y1, z2, 0, 0, 1, 0, 0, c, a);
    vertex(vb, x2, y2, z2, 0, 0, 1, hrepeat, vrepeat, c, a);
    
    vertex(vb, x1, y2, z1, 0, 1, 0, 0, 0, c, a);
    vertex(vb, x1, y2, z2, 0, 1, 0, 0, vrepeat, c, a);
    vertex(vb, x1, y2, z2, 0, 1, 0, 0, vrepeat, c, a);
    vertex(vb, x2, y2, z2, 0, 1, 0, hrepeat, vrepeat, c, a);
    vertex(vb, x2, y2, z2, 0, 1, 0, hrepeat, vrepeat, c, a);
    vertex(vb, x1, y2, z1, 0, 1, 0, 0, 0, c, a);
    
    vertex(vb, x2, y2, z2, 0, 1, 0, hrepeat, vrepeat, c, a);
    vertex(vb, x2, y2, z1, 0, 1, 0, hrepeat, 0, c, a);
    vertex(vb, x2, y2, z1, 0, 1, 0, hrepeat, 0, c, a);
    vertex(vb, x1, y2, z1, 0, 1, 0, 0, 0, c, a);
    vertex(vb, x1, y2, z1, 0, 1, 0, 0, 0, c, a);
    vertex(vb, x2, y2, z2, 0, 1, 0, hrepeat, vrepeat, c, a);
    
    vertex(vb, x2, y2, z1, 1, 0, 0, 0, 0, c, a);
    vertex(vb, x2, y2, z2, 1, 0, 0, 0, vrepeat, c, a);
    vertex(vb, x2, y2, z2, 1, 0, 0, 0, vrepeat, c, a);
    vertex(vb, x2, y1, z2, 1, 0, 0, hrepeat, vrepeat, c, a);
    vertex(vb, x2, y1, z2, 1, 0, 0, hrepeat, vrepeat, c, a);
    vertex(vb, x2, y2, z1, 1, 0, 0, 0, 0, c, a);
    
    vertex(vb, x2, y1, z2, 1, 0, 0, hrepeat, vrepeat, c, a);
    vertex(vb, x2, y1, z1, 1, 0, 0, hrepeat, 0, c, a);
    vertex(vb, x2, y1, z1, 1, 0, 0, hrepeat, 0, c, a);
    vertex(vb, x2, y2, z1, 1, 0, 0, 0, 0, c, a);
    vertex(vb, x2, y2, z1, 1, 0, 0, 0, 0, c, a);
    vertex(vb, x2, y1, z2, 1, 0, 0, hrepeat, vrepeat, c, a);
    
    vertex(vb, x2, y1, z1, 0, -1, 0, 0, 0, c, a);
    vertex(vb, x2, y1, z2, 0, -1, 0, 0, vrepeat, c, a);
    vertex(vb, x2, y1, z2, 0, -1, 0, 0, vrepeat, c, a);
    vertex(vb, x1, y1, z2, 0, -1, 0, hrepeat, vrepeat, c, a);
    vertex(vb, x1, y1, z2, 0, -1, 0, hrepeat, vrepeat, c, a);
    vertex(vb, x2, y1, z1, 0, -1, 0, 0, 0, c, a);
    
    vertex(vb, x1, y1, z2, 0, -1, 0, hrepeat, vrepeat, c, a);
    vertex(vb, x1, y1, z1, 0, -1, 0, hrepeat, 0, c, a);
    vertex(vb, x1, y1, z1, 0, -1, 0, hrepeat, 0, c, a);
    vertex(vb, x2, y1, z1, 0, -1, 0, 0, 0, c, a);
    vertex(vb, x2, y1, z1, 0, -1, 0, 0, 0, c, a);
    vertex(vb, x1, y1, z2, 0, -1, 0, hrepeat, vrepeat, c, a);
    
    vertex(vb, x1, y1, z1, -1, 0, 0, 0, 0, c, a);
    vertex(vb, x1, y1, z2, -1, 0, 0, 0, vrepeat, c, a);
    vertex(vb, x1, y1, z2, -1, 0, 0, 0, vrepeat, c, a);
    vertex(vb, x1, y2, z2, -1, 0, 0, hrepeat, vrepeat, c, a);
    vertex(vb, x1, y2, z2, -1, 0, 0, hrepeat, vrepeat, c, a);
    vertex(vb, x1, y1, z1, -1, 0, 0, 0, 0, c, a);
    
    vertex(vb, x1, y2, z2, -1, 0, 0, hrepeat, vrepeat, c, a);
    vertex(vb, x1, y2, z1, -1, 0, 0, hrepeat, 0, c, a);
    vertex(vb, x1, y2, z1, -1, 0, 0, hrepeat, 0, c, a);
    vertex(vb, x1, y1, z1, -1, 0, 0, 0, 0, c, a);
    vertex(vb, x1, y1, z1, -1, 0, 0, 0, 0, c, a);
    vertex(vb, x1, y2, z2, -1, 0, 0, hrepeat, vrepeat, c, a);
}