function ColCapsule(start, finish, radius) constructor {
    self.line = undefined;
    self.radius = 0;
    self.Set(start, finish, radius);
    
    static Set = function(start = self.line.start, finish = self.line.finish, radius = self.radius) {
        if (self.line) {
            self.line.Set(start, finish);
        } else {
            self.line = new ColLine(start, finish);
        }
        var line = self.line;
        self.radius = radius;
        self.property_center = line.property_center;
        self.property_radius = line.property_length / 2 + radius;
        self.property_min = line.property_min.Sub(radius);
        self.property_max = line.property_min.Add(radius);
    };
    
    static CheckObject = function(object) {
        return object.shape.CheckCapsule(self);
    };
    
    static CheckPoint = function(point) {
        var nearest = self.line.NearestPoint(point.position);
        var dist = nearest.DistanceTo(point.position);
        
        return dist < self.radius;
    };
    
    static CheckSphere = function(sphere) {
        var nearest = self.line.NearestPoint(sphere.position);
        var dist = nearest.DistanceTo(sphere.position);
        
        return dist < (self.radius + sphere.radius);
    };
    
    static CheckAABB = function(aabb) {
        var p1 = self.property_center;
        var p2 = aabb.position;
        if (point_distance_3d(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z) >= (self.property_radius + aabb.property_radius)) return false;
        
        var r = self.radius;
        var line = self.line;
        var line_start = self.line.start;
        var line_finish = self.line.finish;
        var box_min = aabb.property_min;
        var box_max = aabb.property_max;
        var bmnx = box_min.x;
        var bmny = box_min.y;
        var bmnz = box_min.z;
        var bmxx = box_max.x;
        var bmxy = box_max.y;
        var bmxz = box_max.z;
        var lvx = line_finish.x - line_start.x;
        var lvy = line_finish.y - line_start.y;
        var lvz = line_finish.z - line_start.z;
        var lsx = line_start.x;
        var lsy = line_start.y;
        var lsz = line_start.z;
        var ldd = dot_product_3d(lvx, lvy, lvz, lvx, lvy, lvz);
        
        var nx = clamp(line_start.x, bmnx, bmxx);
        var ny = clamp(line_start.y, bmny, bmxy);
        var nz = clamp(line_start.z, bmnz, bmxz);
        if (point_distance_3d(nx, ny, nz, line_start.x, line_start.y, line_start.z) < r) return true;
        
        nx = clamp(line_finish.x, bmnx, bmxx);
        ny = clamp(line_finish.y, bmny, bmxy);
        nz = clamp(line_finish.z, bmnz, bmxz);
        if (point_distance_3d(nx, ny, nz, line_finish.x, line_finish.y, line_finish.z) < r) return true;
        
        var edges = aabb.property_edges;
        
        var i = 0;
        repeat (12) {
            var nearest_line_to_edge = edges[i++].NearestConnectionToLine(line);
            var nearest_start = nearest_line_to_edge.start;
            
            var px = nearest_start.x - lsx;
            var py = nearest_start.y - lsy;
            var pz = nearest_start.z - lsz;
            var t = clamp(dot_product_3d(px, py, pz, lvx, lvy, lvz) / ldd , 0, 1);
            
            var p = (lsx + lvx * t == nearest_start.x && lsy + lvy * t == nearest_start.y && lsz + lvz * t == nearest_start.z) ? nearest_line_to_edge.start : nearest_line_to_edge.finish;
            
            nx = clamp(p.x, bmnx, bmxx);
            ny = clamp(p.y, bmny, bmxy);
            nz = clamp(p.z, bmnz, bmxz);
            
            if (point_distance_3d(nx, ny, nz, p.x, p.y, p.z) < r) return true;
        }
        
        return false;
    };
    
    static CheckPlane = function(plane) {
        var start = self.line.start;
        var nearest = plane.NearestPoint(start);
        if (point_distance_3d(nearest.x, nearest.y, nearest.z, start.x, start.y, start.z) < self.radius) return true;
        
        var finish = self.line.finish;
        nearest = plane.NearestPoint(finish);
        if (point_distance_3d(nearest.x, nearest.y, nearest.z, finish.x, finish.y, finish.z) < self.radius) return true;
        
        return self.line.CheckPlane(plane);
    };
    
    static CheckOBB = function(obb) {
        var p1 = self.property_center;
        var p2 = obb.position;
        if (point_distance_3d(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z) >= (self.property_radius + obb.property_radius)) return false;
        
        var obb_position = obb.position;
        var obb_orientation = obb.property_orientation_array;
        var obb_size_array = [obb.size.x, obb.size.y, obb.size.z];
        
        var r = self.radius;
        var line = self.line;
        var p = line.start;
        
        var nx = obb_position.x, ny = obb_position.y, nz = obb_position.z;
        var dx = p.x - nx, dy = p.y - ny, dz = p.z - nz;
        
        for (var i = 0; i < 3; i++) {
            var axis = obb_orientation[i];
            var dist = dot_product_3d(dx, dy, dz, axis.x, axis.y, axis.z);
            dist = clamp(dist, -obb_size_array[i], obb_size_array[i]);
            nx += axis.x * dist;
            ny += axis.y * dist;
            nz += axis.z * dist;
        }
        
        if (point_distance_3d(nx, ny, nz, p.x, p.y, p.z) < r) return true;
        p = line.finish;
        
        nx = obb_position.x;
        ny = obb_position.y;
        nz = obb_position.z;
        dx = p.x - nx;
        dy = p.y - ny;
        dz = p.z - nz;
        
        for (var i = 0; i < 3; i++) {
            var axis = obb_orientation[i];
            var dist = dot_product_3d(dx, dy, dz, axis.x, axis.y, axis.z);
            dist = clamp(dist, -obb_size_array[i], obb_size_array[i]);
            nx += axis.x * dist;
            ny += axis.y * dist;
            nz += axis.z * dist;
        }
        
        if (point_distance_3d(nx, ny, nz, p.x, p.y, p.z) < r) return true;
        
        var edges = obb.property_edges;
        
        var i = 0;
        repeat (12) {
            var nearest_line_to_edge = edges[i++].NearestConnectionToLine(line);
            var nearest_start = nearest_line_to_edge.start;
            var nearest_self = line.NearestPoint(nearest_start);
            
            p = (nearest_self.x == nearest_start.x && nearest_self.y == nearest_start.y && nearest_self.z == nearest_start.z) ? nearest_line_to_edge.start : nearest_line_to_edge.finish;
            
            nx = obb_position.x;
            ny = obb_position.y;
            nz = obb_position.z;
            dx = p.x - nx;
            dy = p.y - ny;
            dz = p.z - nz;
            
            for (var j = 0; j < 3; j++) {
                var axis = obb.property_orientation_array[j];
                var dist = dot_product_3d(dx, dy, dz, axis.x, axis.y, axis.z);
                dist = clamp(dist, -obb_size_array[j], obb_size_array[j]);
                nx += axis.x * dist;
                ny += axis.y * dist;
                nz += axis.z * dist;
            }
            
            if (point_distance_3d(nx, ny, nz, p.x, p.y, p.z) < r) return true;
        }
        
        return false;
    };
    
    static CheckCapsule = function(capsule) {
        var p1 = self.property_center;
        var p2 = capsule.property_center;
        if (point_distance_3d(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z) >= (self.property_radius + capsule.property_radius)) return false;
        
        var connecting_line = self.line.NearestConnectionToLine(capsule.line);
        return connecting_line.property_length < (self.radius + capsule.radius);
    };
    
    static CheckTriangle = function(triangle) {
        var p1 = self.property_center;
        var p2 = triangle.property_center;
        if (point_distance_3d(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z) >= (self.property_radius + triangle.property_radius)) return false;
        
        var line = self.line;
        var target = triangle.NearestPoint(line.start);
        var nearest = line.NearestPoint(target);
        if (point_distance_3d(nearest.x, nearest.y, nearest.z, target.x, target.y, target.z) < self.radius) return true;
        
        target = triangle.NearestPoint(line.finish);
        nearest = line.NearestPoint(target);
        if (point_distance_3d(nearest.x, nearest.y, nearest.z, target.x, target.y, target.z) < self.radius) return true;
        
        return false;
    };
    
    static CheckMesh = function(mesh) {
        return mesh.CheckCapsule(self);
    };
    
    static CheckModel = function(model) {
        return model.CheckCapsule(self);
    };
    
    static CheckRay = function(ray, hit_info = undefined) {
        var center = self.property_center;
        var nearest = ray.NearestPoint(center);
        if (point_distance_3d(nearest.x, nearest.y, nearest.z, center.x, center.y, center.z) >= self.property_radius) return false;
        
        var line = self.line;
        var cd = line.property_ray.direction.Mul(line.Length());
        var rd = ray.direction;
        var ro = ray.origin;
        var oa = ro.Sub(line.start);
        
        var baba = dot_product_3d(cd.x, cd.y, cd.z, cd.x, cd.y, cd.z);
        var bard = dot_product_3d(cd.x, cd.y, cd.z, rd.x, rd.y, rd.z);
        var baoa = dot_product_3d(cd.x, cd.y, cd.z, oa.x, oa.y, oa.z);
        var rdoa = dot_product_3d(rd.x, rd.y, rd.z, oa.x, oa.y, oa.z);
        var oaoa = dot_product_3d(oa.x, oa.y, oa.z, oa.x, oa.y, oa.z);
        
        var a = baba - sqr(bard);
        var b = baba * rdoa - baoa * bard;
        var c = baba * oaoa - sqr(baoa) - sqr(self.radius) * baba;
        var h = sqr(b) - a * c;
        
        if (h > 0) {
            var t = (-b - sqrt(h)) / a;
            var why = baoa + t * bard;
            
            if (why > 0 && why < baba) {
                if (hit_info) {
                    var contact_point = ro.Add(rd.Mul(t));
                    var nearest_inner_point = line.NearestPoint(contact_point);
                    var contact_normal = contact_point.Sub(nearest_inner_point).Normalize();
                    hit_info.Update(t, self, contact_point, contact_normal);
                }
                return true;
            }
            
            var oc = (why <= 0) ? oa : ro.Sub(line.finish);
            b = dot_product_3d(rd.x, rd.y, rd.z, oc.x, oc.y, oc.z);
            c = dot_product_3d(oc.x, oc.y, oc.z, oc.x, oc.y, oc.z) - sqr(self.radius);
            h = sqr(b) - c;
            
            if (h > 0) {
                if (hit_info) {
                    t = -b - sqrt(h);
                    var contact_point = ro.Add(rd.Mul(t));
                    var nearest_inner_point = line.NearestPoint(contact_point);
                    var contact_normal = contact_point.Sub(nearest_inner_point).Normalize();
                    hit_info.Update(t, self, contact_point, contact_normal);
                }
                return true;
            }
        }
        
        return false;
    };
    
    static CheckLine = function(line) {
        var closest_line = self.line.NearestConnectionToLine(line);
        return closest_line.property_length < self.radius;
    };
    
    static DisplaceSphere = function(sphere) {
        if (!self.CheckSphere(sphere)) return undefined;
        
        var ps = sphere.position;
        var nearest = self.line.NearestPoint(ps);
        
        if (ps.x == nearest.x && ps.y == nearest.y && ps.z == nearest.z) return undefined;
        
        var dir = ps.Sub(nearest).Normalize();
        var offset = dir.Mul(sphere.radius + self.radius);
        
        return nearest.Add(offset);
    };
    
    static GetMin = function() {
        return self.property_min.Clone();
    };
    
    static GetMax = function() {
        return self.property_max.Clone();
    };
}