/// these two matrices are going to be Matrix4 instances
function ColCameraFrustum(view_mat, proj_mat) constructor {
    static vp = matrix_build_identity();
    matrix_multiply(view_mat, proj_mat, vp);
    
    var c1 = new Vector3(vp[ 0], vp[ 4], vp[ 8]);
    var c2 = new Vector3(vp[ 1], vp[ 5], vp[ 9]);
    var c3 = new Vector3(vp[ 2], vp[ 6], vp[10]);
    var c4 = new Vector3(vp[ 3], vp[ 7], vp[11]);
    
    var ww = vp[15];
    
    self.left =         new ColPlane(c4.Add(c1), ww + vp[12]).Normalize();
    self.right =        new ColPlane(c4.Sub(c1), ww - vp[12]).Normalize();
    self.bottom  =      new ColPlane(c4.Add(c2), ww + vp[13]).Normalize();
    self.top =          new ColPlane(c4.Sub(c2), ww - vp[13]).Normalize();
    self.near =         new ColPlane(c4.Add(c3), ww + vp[14]).Normalize();
    self.far =          new ColPlane(c4.Sub(c3), ww - vp[14]).Normalize();
    
    self.as_array = [self.left, self.right, self.bottom, self.top, self.near, self.far];
    
    static AsArray = function() {
        return self.as_array;
    };
    
    static GetCorners = function() {
        return [
            col_three_plane_intersection(self.near,   self.top,       self.left),
            col_three_plane_intersection(self.near,   self.top,       self.right),
            col_three_plane_intersection(self.near,   self.bottom,    self.left),
            col_three_plane_intersection(self.near,   self.bottom,    self.right),
            col_three_plane_intersection(self.far,    self.top,       self.left),
            col_three_plane_intersection(self.far,    self.top,       self.right),
            col_three_plane_intersection(self.far,    self.bottom,    self.left),
            col_three_plane_intersection(self.far,    self.bottom,    self.right)
        ];
    };
}

function col_three_plane_intersection(p1, p2, p3) {
    var n = p1.normal;
    var p2xp3 = p2.normal.Cross(p3.normal);
    var p3xp1 = p3.normal.Cross(n);
    var p1xp2 = n.Cross(p2.normal);
    
    var cross_product_sum = p2xp3.Mul(-p1.distance)
        .Add(p3xp1.Mul(-p2.distance))
        .Add(p1xp2.Mul(-p3.distance));
    
    return cross_product_sum.Div(dot_product_3d(n.x, n.y, n.z, p2xp3.x, p2xp3.y, p2xp3.z));
}

enum EFrustumResults {
    OUTSIDE,
    INTERSECTING,
    INSIDE
}