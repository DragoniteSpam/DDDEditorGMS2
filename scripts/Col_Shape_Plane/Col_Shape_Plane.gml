function ColPlane(normal, distance) constructor {
    self.normal = normal;                   // Vec3
    self.distance = distance;               // number
    
    self.property_min = undefined;
    self.property_max = undefined;
    
    static CheckObject = function(object) {
        return object.shape.CheckPlane(self);
    };
    
    static CheckPoint = function(point) {
        return point.CheckPlane(self);
    };
    
    static CheckSphere = function(sphere) {
        return sphere.CheckPlane(self);
    };
    
    static CheckAABB = function(aabb) {
        return aabb.CheckPlane(self);
    };
    
    static CheckPlane = function(plane) {
        if (self.distance == plane.distance) return true;
        var n1 = self.normal;
        var n2 = plane.normal;
        return point_distance_3d(0, 0, 0, n1.y * n2.z - n2.y * n1.z, n1.z * n2.x - n2.z * n1.x, n1.x * n2.y - n2.x * n1.y) > 0;
    };
    
    static CheckOBB = function(obb) {
        return obb.CheckPlane(self);
    };
    
    static CheckCapsule = function(capsule) {
        return capsule.CheckPlane(self);
    };
    
    static CheckTriangle = function(triangle) {
        var nx = self.normal.x, ny = self.normal.y, nz = self.normal.z;
        var d = self.distance;
        var side_a = dot_product_3d(nx, ny, nz, triangle.a.x, triangle.a.y, triangle.a.z) - d;
        var side_b = dot_product_3d(nx, ny, nz, triangle.b.x, triangle.b.y, triangle.b.z) - d;
        var side_c = dot_product_3d(nx, ny, nz, triangle.c.x, triangle.c.y, triangle.c.z) - d;
        
        if (side_a == 0 && side_b == 0 && side_c == 0) {
            return true;
        }
        
        if (sign(side_a) == sign(side_b) && sign(side_a) == sign(side_c)) {
            return false;
        }
        
        return true;
    };
    
    static CheckMesh = function(mesh) {
        return mesh.CheckPlane(self);
    };
    
    static CheckModel = function(model) {
        return model.CheckPlane(self);
    };
    
    static CheckRay = function(ray, hit_info = undefined) {
        var rd = ray.direction;
        var n = self.normal;
        var DdotN = dot_product_3d(rd.x, rd.y, rd.z, n.x, n.y, n.z);
        if (DdotN >= 0) return false;
        
        var ro = ray.origin;
        var OdotN = dot_product_3d(ro.x, ro.y, ro.z, n.x, n.y, n.z);
        var t = (self.distance - OdotN) / DdotN;
        if (t < 0) return false;
        
        if (hit_info) {
            hit_info.Update(t, self, ro.Add(rd.Mul(t)), n);
        }
        
        return true;
    };
    
    static CheckLine = function(line) {
        var n = self.normal;
        var start = line.start;
        var dir = line.property_ray.direction;
        var NdotS = dot_product_3d(n.x, n.y, n.z, start.x, start.y, start.z);
        var NdotD = dot_product_3d(n.x, n.y, n.z, dir.x, dir.y, dir.z);
        
        if (NdotD == 0) return false;
        var t = (self.distance - NdotS) / NdotD;
        return (t >= 0) && (t <= 1);
    };
    
    static DisplaceSphere = function(sphere) {
        if (!self.CheckSphere(sphere)) return undefined;
        
        var nearest = self.NearestPoint(sphere.position);
        var offset = self.normal.Mul(sphere.radius);
        
        return nearest.Add(offset);
    };
    
    static NearestPoint = function(vec3) {
        var nx = self.normal.x, ny = self.normal.y, nz = self.normal.z;
        var dist = dot_product_3d(nx, ny, nz, vec3.x, vec3.y, vec3.z) - self.distance;
        return new Vector3(vec3.x - nx * dist, vec3.y - ny * dist, vec3.z - nz * dist);
    };
    
    static PlaneEquation = function(vec3) {
        // much like the dot product, this function will return:
        // - +1ish if the value is in front of the plane
        // - 0 if the value is on the plane
        // - -1ish is the value is behind the plane
        var n = self.normal;
        return dot_product_3d(n.x, n.y, n.z, vec3.x, vec3.y, vec3.z) - self.distance;
    };
    
    static GetMin = function() {
        return undefined;
    };
    
    static GetMax = function() {
        return undefined;
    };
    
    static Normalize = function() {
        var n = self.normal;
        var mag = point_distance_3d(0, 0, 0, n.x, n.y, n.z);
        return new ColPlane(n.Div(mag), self.distance / mag);
    };
}