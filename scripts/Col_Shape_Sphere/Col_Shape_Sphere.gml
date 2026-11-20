function ColSphere(position, radius) constructor {
    self.position = position;               // Vec3
    self.radius = radius;                   // Vec3
    
    self.property_min = position.Sub(radius);
    self.property_max = position.Add(radius);
    
    static Set = function(position = self.position, radius = self.radius) {
        self.position = position;
        self.radius = radius;
        self.property_min.x = position.x - radius;
        self.property_min.y = position.y - radius;
        self.property_min.z = position.z - radius;
        self.property_max.x = position.x + radius;
        self.property_max.y = position.y + radius;
        self.property_max.z = position.z + radius;
    };
    
    static CheckObject = function(object) {
        return object.shape.CheckSphere(self);
    };
    
    static CheckPoint = function(point) {
        return point.CheckSphere(self);
    };
    
    static CheckSphere = function(sphere) {
        var p1 = self.position;
        var p2 = sphere.position;
        return point_distance_3d(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z) < (self.radius + sphere.radius);
    };
    
    static CheckAABB = function(aabb) {
        var pa = aabb.position;
        var ps = self.position;
        if (point_distance_3d(pa.x, pa.y, pa.z, ps.x, ps.y, ps.z) > aabb.property_radius + self.radius) return false;
        
        var box_min = aabb.property_min;
        var box_max = aabb.property_max;
        var nx = clamp(ps.x, box_min.x, box_max.x);
        var ny = clamp(ps.y, box_min.y, box_max.y);
        var nz = clamp(ps.z, box_min.z, box_max.z);
        
        return point_distance_3d(nx, ny, nz, ps.x, ps.y, ps.z) < self.radius;
    };
    
    static CheckPlane = function(plane) {
        var ps = self.position;
        var pn = plane.normal;
        var dist = dot_product_3d(pn.x, pn.y, pn.z, ps.x, ps.y, ps.z) - plane.distance;
        return point_distance_3d(
            ps.x - pn.x * dist,
            ps.y - pn.y * dist,
            ps.z - pn.z * dist, ps.x, ps.y, ps.z) < self.radius;
    };
    
    static CheckOBB = function(obb) {
        return obb.CheckSphere(self);
    };
    
    static CheckCapsule = function(capsule) {
        return capsule.CheckSphere(self);
    };
    
    static CheckTriangle = function(triangle) {
        var ps = self.position;
        var nearest = triangle.NearestPoint(ps);
        return point_distance_3d(nearest.x, nearest.y, nearest.z, ps.x, ps.y, ps.z) < self.radius;
    };
    
    static CheckMesh = function(mesh) {
        return mesh.CheckSphere(self);
    };
    
    static CheckModel = function(model) {
        return model.CheckSphere(self);
    };
    
    static CheckRay = function(ray, hit_info = undefined) {
        var dir = ray.direction;
        var o = ray.origin;
        var p = self.position;
        var ex = p.x - o.x;
        var ey = p.y - o.y;
        var ez = p.z - o.z;
        var mag_squared = dot_product_3d(ex, ey, ez, ex, ey, ez);
        var r_squared = sqr(self.radius);
        var EdotD = dot_product_3d(ex, ey, ez, dir.x, dir.y, dir.z);
        var offset = r_squared - (mag_squared - (EdotD * EdotD));
        if (offset < 0) return false;
        
        if (hit_info) {
            var f = sqrt(abs(offset));
            var t = EdotD - f;
            if (mag_squared < r_squared) {
                t = EdotD + f;
            }
            static contact_point = new Vector3(0, 0, 0);
            contact_point.x = o.x + dir.x * t;
            contact_point.y = o.y + dir.y * t;
            contact_point.z = o.z + dir.z * t;
            
            //hit_info.Update(t, self, contact_point, contact_point.Sub(p).Normalize());
            hit_info.Update(contact_point.DistanceTo(ray.origin), self, contact_point, contact_point.Sub(p).Normalize());
        }
        
        return true;
    };
    
    static CheckLine = function(line) {
        var p = self.position;
        var nearest = line.NearestPoint(p);
        return point_distance_3d(nearest.x, nearest.y, nearest.z, p.x, p.y, p.z) < self.radius;
    };
    
    static DisplaceSphere = function(sphere) {
        if (!self.CheckSphere(sphere)) return undefined;
        
        var p1 = self.position;
        var p2 = sphere.position;
        if (p1.x == p2.x && p1.y == p2.y && p1.z == p2.z) return undefined;
        
        var dir = sphere.position.Sub(p1).Normalize();
        var offset = dir.Mul(sphere.radius + self.radius);
        
        return p1.Add(offset);
    };
    
    static NearestPoint = function(vec3) {
        var dist = vec3.Sub(self.position).Normalize();
        var scaled_dist = dist.Mul(self.radius);
        return scaled_dist.Add(self.position);
    };
    
    static GetMin = function() {
        return self.property_min.Clone();
    };
    
    static GetMax = function() {
        return self.property_max.Clone();
    };
    
    static CheckFrustum = function(frustum) {
        var planes = frustum.as_array;
        var is_intersecting_anything = false;
        var r = self.radius;
        var p = self.position;
        var px = p.x, py = p.y, pz = p.z;
        var i = 0;
        repeat (6) {
            var plane = planes[i++];
            var n = plane.normal;
            var dist = dot_product_3d(n.x, n.y, n.z, px, py, pz) + plane.distance;
            
            if (dist < -r)
                return EFrustumResults.OUTSIDE;
            
            if (abs(dist) < r)
                is_intersecting_anything = true;
        }
        return is_intersecting_anything ? EFrustumResults.INTERSECTING : EFrustumResults.INSIDE;
    };
    
    static CheckFrustumFast = function() {
        var p = self.position;
        return sphere_is_visible(p.x, p.y, p.z, self.radius) ? EFrustumResults.INSIDE : EFrustumResults.OUTSIDE;
    };
}