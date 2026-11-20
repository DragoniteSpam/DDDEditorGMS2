function ColPoint(position) constructor {
    self.Set(position);
    
    static Set = function(position) {
        self.position = position;
        self.property_min = position;
        self.property_max = position;
    };
    
    static CheckObject = function(object) {
        return object.shape.CheckPoint(self);
    };
    
    static CheckPoint = function(point) {
        var p1 = self.position;
        var p2 = point.position;
        return p1.x == p2.x && p1.y == p2.y && p1.z == p2.z;
    };
    
    static CheckSphere = function(sphere) {
        var pp = self.position;
        var ps = sphere.position;
        return point_distance_3d(pp.x, pp.y, pp.z, ps.x, ps.y, ps.z) < sphere.radius;
    };
    
    static CheckAABB = function(aabb) {
        var box_min = aabb.property_min;
        var box_max = aabb.property_max;
        var p = self.position;
        if (p.x < box_min.x || p.y < box_min.y || p.z < box_min.z) return false;
        if (p.x > box_max.x || p.y > box_max.y || p.z > box_max.z) return false;
        return true;
    };
    
    static CheckPlane = function(plane) {
        var p = self.position;
        var n = plane.normal;
        return (dot_product_3d(p.x, p.y, p.z, n.x, n.y, n.z) == plane.distance);
    };
    
    static CheckOBB = function(obb) {
        return obb.CheckPoint(self);
    };
    
    static CheckCapsule = function(capsule) {
        return capsule.CheckPoint(self);
    };
    
    static CheckTriangle = function(triangle) {
        var pa = triangle.a.Sub(self.position);
        var pb = triangle.b.Sub(self.position);
        var pc = triangle.c.Sub(self.position);
        
        var normPBC = pb.Cross(pc).Normalize();
        var normPCA = pc.Cross(pa).Normalize();
        var normPAB = pa.Cross(pb).Normalize();
        
        if (dot_product_3d(normPBC.x, normPBC.y, normPBC.z, normPCA.x, normPCA.y, normPCA.z) < 1) {
            return false;
        }
        
        if (dot_product_3d(normPBC.x, normPBC.y, normPBC.z, normPAB.x, normPAB.y, normPAB.z) < 1) {
            return false;
        }
        
        return true;
    };
    
    static CheckMesh = function(mesh) {
        return mesh.CheckPoint(self);
    };
    
    static CheckModel = function(model) {
        return model.CheckPoint(self);
    };
    
    static CheckRay = function(ray, hit_info = undefined) {
        var p = self.position;
        var nearest = ray.NearestPoint(p);
        if (point_distance_3d(nearest.x, nearest.y, nearest.z, p.x, p.y, p.z) > 0) return false;
        
        if (hit_info) {
            var ro = ray.origin;
            hit_info.Update(point_distance_3d(p.x, p.y, p.z, ro.x, ro.x, ro.z), self, p, undefined);
        }
        
        return true;
    };
    
    static CheckLine = function(line) {
        var p = self.position;
        var nearest = line.NearestPoint(p);
         return nearest.x == p.x && nearest.y == p.y && nearest.z == p.z;
    };
    
    static DisplaceSphere = function(sphere) {
        var pp = self.position;
        var ps = sphere.position;
        var d = point_distance_3d(pp.x, pp.y, pp.z, ps.x, ps.y, ps.z);
        if (d == 0 || d > sphere.radius) return undefined;
        
        return pp.Add(ps.Sub(pp).Normalize().Mul(sphere.radius));
    };
    
    static GetMin = function() {
        return self.position.Clone();
    };
    
    static GetMax = function() {
        return self.position.Clone();
    };
    
    static CheckFrustum = function(frustum) {
        var planes = frustum.as_array;
        var p = self.position;
        var px = p.x, py = p.y, pz = p.z;
        var i = 0;
        repeat (6) {
            var plane = planes[i++];
            var n = plane.normal;
            if (dot_product_3d(n.x, n.y, n.z, px, py, pz) + plane.distance < 0)
                return EFrustumResults.OUTSIDE;
        }
        return EFrustumResults.INSIDE;
    };
    
    static CheckFrustumFast = function() {
        var p = self.position;
        return sphere_is_visible(p.x, p.y, p.z, 0.0001) ? EFrustumResults.INSIDE : EFrustumResults.OUTSIDE;
    };
}