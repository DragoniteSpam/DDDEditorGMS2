function ColAABB(position, half_extents) constructor {
    self.position = undefined;
    self.half_extents = undefined;
    self.Set(position, half_extents);
    
    static Set = function(position = self.position, half_extents = self.half_extents) {
        self.position = position;
        self.half_extents = half_extents;
        
        self.property_min = position.Sub(half_extents);
        self.property_max = position.Add(half_extents);
        self.property_radius = point_distance_3d(0, 0, 0, half_extents.x, half_extents.y, half_extents.z);
        
        var pmin = self.property_min;
        var pmax = self.property_max;
        
        self.property_vertices = [
            new Vector3(pmin.x, pmax.y, pmax.z),
            new Vector3(pmin.x, pmax.y, pmin.z),
            new Vector3(pmin.x, pmin.y, pmax.z),
            new Vector3(pmin.x, pmin.y, pmin.z),
            new Vector3(pmax.x, pmax.y, pmax.z),
            new Vector3(pmax.x, pmax.y, pmin.z),
            new Vector3(pmax.x, pmin.y, pmax.z),
            new Vector3(pmax.x, pmin.y, pmin.z)
        ];
        
        var vertices = self.property_vertices;
        
        self.property_edges = [
            new ColLine(vertices[0], vertices[1]),
            new ColLine(vertices[0], vertices[2]),
            new ColLine(vertices[1], vertices[3]),
            new ColLine(vertices[2], vertices[3]),
            new ColLine(vertices[4], vertices[5]),
            new ColLine(vertices[4], vertices[6]),
            new ColLine(vertices[5], vertices[7]),
            new ColLine(vertices[6], vertices[7]),
            new ColLine(vertices[0], vertices[4]),
            new ColLine(vertices[1], vertices[5]),
            new ColLine(vertices[2], vertices[6]),
            new ColLine(vertices[3], vertices[7])
        ];
    };
    
    static CheckObject = function(object) {
        return object.shape.CheckAABB(self);
    };
    
    static CheckPoint = function(point) {
        return point.CheckAABB(self);
    };
    
    static CheckSphere = function(sphere) {
        return sphere.CheckAABB(self);
    };
    
    static CheckAABB = function(aabb) {
        var box_min = self.property_min;
        var box_max = self.property_max;
        var other_min = aabb.property_min;
        var other_max = aabb.property_max;
        return ((box_min.x <= other_max.x) && (box_max.x >= other_min.x) && (box_min.y <= other_max.y) && (box_max.y >= other_min.y) && (box_min.z <= other_max.z) && (box_max.z >= other_min.z));
    };
    
    static CheckPlane = function(plane) {
        var size = self.half_extents;
        var normal = plane.normal;
        var pos = self.position;
        var anx = abs(normal.x);
        var any = abs(normal.y);
        var anz = abs(normal.z);
        var plength = dot_product_3d(anx, any, anz, size.x, size.y, size.z);
        var ndot = dot_product_3d(normal.x, normal.y, normal.z, pos.x, pos.y, pos.z);
        return (abs(ndot - plane.distance) <= plength);
    };
    
    static CheckOBB = function(obb) {
        return obb.CheckAABB(self);
    };
    
    static CheckCapsule = function(capsule) {
        return capsule.CheckAABB(self);
    };
    
    static CheckTriangle = function(triangle) {
        var p1 = self.position;
        var p2 = triangle.property_center;
        if (point_distance_3d(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z) > triangle.property_radius + self.property_radius) return false;
        
        var ab = triangle.property_edge_ab;
        var bc = triangle.property_edge_bc;
        var ca = triangle.property_edge_ca;
         
        static axes = [
            1, 0, 0,
            0, 1, 0,
            0, 0, 1,
            0, 0, 0,
            0, 0, 0,
            0, 0, 0,
            0, 0, 0,
            0, 0, 0,
            0, 0, 0,
            0, 0, 0,
            0, 0, 0,
            0, 0, 0,
            0, 0, 0
        ];
        
        axes[3 * 3 + 0] = triangle.property_normal.x;
        axes[3 * 3 + 1] = triangle.property_normal.y;
        axes[3 * 3 + 2] = triangle.property_normal.z;
        axes[4 * 3 + 1] = -ab.z;
        axes[4 * 3 + 2] = ab.y;
        axes[5 * 3 + 1] = -bc.z;
        axes[5 * 3 + 2] = bc.y;
        axes[6 * 3 + 1] = -ca.z;
        axes[6 * 3 + 2] = ca.y;
        axes[7 * 3 + 0] = ab.z;
        axes[7 * 3 + 2] = -ab.x;
        axes[8 * 3 + 0] = bc.z;
        axes[8 * 3 + 2] = -bc.x;
        axes[9 * 3 + 0] = ca.z;
        axes[9 * 3 + 2] = -ca.x;
        axes[10 * 3 + 0] = -ab.y;
        axes[10 * 3 + 1] = ab.x;
        axes[11 * 3 + 0] = -bc.y;
        axes[11 * 3 + 1] = bc.x;
        axes[12 * 3 + 0] = -ca.y;
        axes[12 * 3 + 1] = ca.x;
        
        var vertices = self.property_vertices;
        var tax = triangle.a.x;
        var tay = triangle.a.y;
        var taz = triangle.a.z;
        var tbx = triangle.b.x;
        var tby = triangle.b.y;
        var tbz = triangle.b.z;
        var tcx = triangle.c.x;
        var tcy = triangle.c.y;
        var tcz = triangle.c.z;
        
        var i = 0;
        repeat (13) {
            var ax = axes[i++];
            var ay = axes[i++];
            var az = axes[i++];
        
            var vertex = vertices[0];
            var dot0 = dot_product_3d(ax, ay, az, vertex.x, vertex.y, vertex.z);
            vertex = vertices[1];
            var dot1 = dot_product_3d(ax, ay, az, vertex.x, vertex.y, vertex.z);
            vertex = vertices[2];
            var dot2 = dot_product_3d(ax, ay, az, vertex.x, vertex.y, vertex.z);
            vertex = vertices[3];
            var dot3 = dot_product_3d(ax, ay, az, vertex.x, vertex.y, vertex.z);
            vertex = vertices[4];
            var dot4 = dot_product_3d(ax, ay, az, vertex.x, vertex.y, vertex.z);
            vertex = vertices[5];
            var dot5 = dot_product_3d(ax, ay, az, vertex.x, vertex.y, vertex.z);
            vertex = vertices[6];
            var dot6 = dot_product_3d(ax, ay, az, vertex.x, vertex.y, vertex.z);
            vertex = vertices[7];
            var dot7 = dot_product_3d(ax, ay, az, vertex.x, vertex.y, vertex.z);
            var val_min_a = min(dot0, dot1, dot2, dot3, dot4, dot5, dot6, dot7);
            var val_max_a = max(dot0, dot1, dot2, dot3, dot4, dot5, dot6, dot7);
            
            var ada = dot_product_3d(ax, ay, az, tax, tay, taz);
            var adb = dot_product_3d(ax, ay, az, tbx, tby, tbz);
            var adc = dot_product_3d(ax, ay, az, tcx, tcy, tcz);
            var val_min_b = min(ada, adb, adc);
            var val_max_b = max(ada, adb, adc);
            
            if ((val_min_b > val_max_a) || (val_min_a > val_max_b)) {
                return false;
            }
        }
        
        return true;
    };
    
    static CheckMesh = function(mesh) {
        return mesh.CheckAABB(self);
    };
    
    static CheckModel = function(model) {
        return model.CheckAABB(self);
    };
    
    static CheckRay = function(ray, hit_info = undefined) {
        var box_min = self.property_min;
        var box_max = self.property_max;
        
        var dir = ray.direction;
        var p = ray.origin;
        
        var ray_x = (dir.x == 0) ? 0.0001 : dir.x;
        var ray_y = (dir.y == 0) ? 0.0001 : dir.y;
        var ray_z = (dir.z == 0) ? 0.0001 : dir.z;
        
        var t1 = (box_min.x - p.x) / ray_x;
        var t2 = (box_max.x - p.x) / ray_x;
        var t3 = (box_min.y - p.y) / ray_y;
        var t4 = (box_max.y - p.y) / ray_y;
        var t5 = (box_min.z - p.z) / ray_z;
        var t6 = (box_max.z - p.z) / ray_z;
        
        var tmin = max(
            min(t1, t2),
            min(t3, t4),
            min(t5, t6)
        );
        var tmax = min(
            max(t1, t2),
            max(t3, t4),
            max(t5, t6)
        );
        
        if (tmax < 0) return false;
        if (tmin > tmax) return false;
        
        if (hit_info) {
            var t = tmax;
            if (tmin > 0) {
                t = tmin;
            }
            
            var tnormal;
            if (t == t1) tnormal = new Vector3(-1, 0, 0);
            if (t == t2) tnormal = new Vector3(+1, 0, 0);
            if (t == t3) tnormal = new Vector3(0, -1, 0);
            if (t == t4) tnormal = new Vector3(0, +1, 0);
            if (t == t5) tnormal = new Vector3(0, 0, -1);
            if (t == t6) tnormal = new Vector3(0, 0, +1);
            
            hit_info.Update(t, self, p.Add(dir.Mul(t)), tnormal);
        }
        
        return true;
    };
    
    static CheckLine = function(line) {
        static hit_info = new RaycastHitInformation();
        hit_info.distance = infinity;
        
        if (self.CheckRay(line.property_ray, hit_info)) {
            return (hit_info.distance <= line.property_length);
        }
        return false;
    };
    
    static DisplaceSphere = function(sphere) {
        if (!sphere.CheckAABB(self)) return undefined;
        var ps = sphere.position;
        var pa = self.position;
        if (ps.x == pa.x && ps.y == pa.y && ps.z == pa.z) return undefined;
        
        var nearest = self.NearestPoint(ps);
        
        if (ps.x == nearest.x && nearest.y == pa.y && nearest.z == pa.z) {
            return undefined;
        }
        
        var dir = ps.Sub(nearest).Normalize();
        return nearest.Add(dir.Mul(sphere.radius));
    };
    
    static NearestPoint = function(vec3) {
        var box_min = self.property_min;
        var box_max = self.property_max;
        return new Vector3(
            clamp(vec3.x, box_min.x, box_max.x),
            clamp(vec3.y, box_min.y, box_max.y),
            clamp(vec3.z, box_min.z, box_max.z)
        );
    };
    
    static GetInterval = function(axis) {
        var vertices = self.property_vertices;
        var ax = axis.x;
        var ay = axis.y;
        var az = axis.z;
        
        var imin = infinity;
        var imax = -infinity;
        
        var i = 0;
        repeat (8) {
            var vertex = vertices[i++];
            var dot = dot_product_3d(ax, ay, az, vertex.x, vertex.y, vertex.z);
            imin = min(imin, dot);
            imax = max(imax, dot);
        }
        
        return { val_min: imin, val_max: imax };
    };
    
    static GetVertices = function() {
        return array_map(self.property_vertices, function(item) {
            return item.Clone();
        });
    };
    
    static GetEdges = function() {
        return array_map(self.property_edges, function(item) {
            return new ColLine(item.start, item.finish);
        });
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
        var r = self.property_radius;
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
        return sphere_is_visible(p.x, p.y, p.z, self.property_radius) ? EFrustumResults.INSIDE : EFrustumResults.OUTSIDE;
    };
}