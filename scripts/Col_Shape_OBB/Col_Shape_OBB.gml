function ColOBB(position, size, orientation) constructor {
    self.position = undefined;
    self.size = undefined;
    self.orientation = undefined;
    self.Set(position, size, orientation);
    
    static Set = function(position = self.position, size = self.size, orientation = self.orientation) {
        self.position = position;
        self.size = size;
        self.orientation = orientation;
        
        var ox = new Vector3(orientation[ 0], orientation[ 1], orientation[ 2]);
        var oy = new Vector3(orientation[ 4], orientation[ 5], orientation[ 6]);
        var oz = new Vector3(orientation[ 8], orientation[ 9], orientation[10]);
        self.property_orientation_array = [ox, oy, oz];
        var xs = ox.Mul(size.x);
        var ys = oy.Mul(size.y);
        var zs = oz.Mul(size.z);
        
        self.property_vertices = [
            position.Add(xs).Add(ys).Add(zs),
            position.Sub(xs).Add(ys).Add(zs),
            position.Add(xs).Sub(ys).Add(zs),
            position.Add(xs).Add(ys).Sub(zs),
            position.Sub(xs).Sub(ys).Sub(zs),
            position.Add(xs).Sub(ys).Sub(zs),
            position.Sub(xs).Add(ys).Sub(zs),
            position.Sub(xs).Sub(ys).Add(zs),
        ];
        
        var vertices = self.property_vertices;
        
        self.property_edges = [
            new ColLine(vertices[1], vertices[6]),
            new ColLine(vertices[6], vertices[4]),
            new ColLine(vertices[4], vertices[7]),
            new ColLine(vertices[7], vertices[1]),
            new ColLine(vertices[0], vertices[3]),
            new ColLine(vertices[3], vertices[5]),
            new ColLine(vertices[5], vertices[2]),
            new ColLine(vertices[1], vertices[0]),
            new ColLine(vertices[7], vertices[2]),
            new ColLine(vertices[2], vertices[0]),
            new ColLine(vertices[6], vertices[3]),
            new ColLine(vertices[4], vertices[5]),
        ];
        
        self.property_min = new Vector3(infinity, infinity, infinity);
        self.property_max = new Vector3(-infinity, -infinity, -infinity);
        var pmin = self.property_min;
        var pmax = self.property_max;
        for (var i = 0; i < 8; i++) {
            var vertex = vertices[i];
            pmin.x = min(pmin.x, vertex.x);
            pmin.y = min(pmin.y, vertex.y);
            pmin.z = min(pmin.z, vertex.z);
            pmax.x = max(pmax.x, vertex.x);
            pmax.y = max(pmax.y, vertex.y);
            pmax.z = max(pmax.z, vertex.z);
        }
        
        self.property_radius = point_distance_3d(size.x, size.y, size.z, 0, 0, 0);
        
        self.property_aabb_axes = [
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
            0, 0, 0,
            0, 0, 0,
            0, 0, 0
        ];
        var axes = self.property_aabb_axes;
        
        ox = self.property_orientation_array[0];
        oy = self.property_orientation_array[1];
        oz = self.property_orientation_array[2];
        
        axes[3 * 3 + 0] = ox.x;
        axes[3 * 3 + 1] = ox.y;
        axes[3 * 3 + 2] = ox.z;
        axes[4 * 3 + 0] = oy.x;
        axes[4 * 3 + 1] = oy.y;
        axes[4 * 3 + 2] = oy.z;
        axes[5 * 3 + 0] = oz.x;
        axes[5 * 3 + 1] = oz.y;
        axes[5 * 3 + 2] = oz.z;
        
        axes[6 * 3 + 1] = -ox.z;
        axes[6 * 3 + 2] = -ox.y;
        
        axes[7 * 3 + 1] = -oy.z;
        axes[7 * 3 + 2] = -oy.y;
        
        axes[8 * 3 + 1] = -oz.z;
        axes[8 * 3 + 2] = -oz.y;
        
        axes[9 * 3 + 0] =   ox.z;
        
        axes[9 * 3 + 2] =  -ox.x;
        axes[10 * 3 + 0] =  oy.z;
        
        axes[10 * 3 + 2] = -oy.x;
        axes[11 * 3 + 0] =  oz.z;
        
        axes[11 * 3 + 2] = -oz.x;
        
        axes[12 + 3 + 0] = -ox.y;
        axes[12 + 3 + 1] =  ox.x;
        
        axes[13 + 3 + 0] = -oy.y;
        axes[13 + 3 + 1] =  oy.x;
        
        axes[14 + 3 + 0] = -oz.y;
        axes[14 + 3 + 1] =  oz.x;
        
        self.property_axis_extents = array_create(30);
        var i = 0;
        var axis_counter = 0;
        
        repeat (15) {
            var xx = axes[i++];
            var yy = axes[i++];
            var zz = axes[i++];
            
            var vertex = vertices[0];
            var dot0a = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices[1];
            var dot1a = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices[2];
            var dot2a = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices[3];
            var dot3a = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices[4];
            var dot4a = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices[5];
            var dot5a = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices[6];
            var dot6a = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices[7];
            var dot7a = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            
            self.property_axis_extents[axis_counter++] = min(dot0a, dot1a, dot2a, dot3a, dot4a, dot5a, dot6a, dot7a);
            self.property_axis_extents[axis_counter++] = max(dot0a, dot1a, dot2a, dot3a, dot4a, dot5a, dot6a, dot7a);
        }
    };
    
    static CheckObject = function(object) {
        return object.shape.CheckOBB(self);
    };
    
    static CheckPoint = function(point) {
        var pp = point.position;
        var po = self.position;
        if (point_distance_3d(po.x, po.y, po.z, pp.x, pp.y, pp.z) > self.property_radius) return false;
        
        var dx = pp.x - po.x, dy = pp.y - po.y, dz = pp.z - po.z;
        
        var size_array = [self.size.x, self.size.y, self.size.z];
        
        for (var i = 0; i < 3; i++) {
            var axis = self.property_orientation_array[i];
            if (abs(dot_product_3d(dx, dy, dz, axis.x, axis.y, axis.z)) > abs(size_array[i])) {
                return false;
            }
        }
        
        return true;
    };
    
    static CheckSphere = function(sphere) {
        var ps = sphere.position;
        var px = self.position.x;
        var py = self.position.y;
        var pz = self.position.z;
        if (point_distance_3d(px, py, pz, ps.x, ps.y, ps.z) > self.property_radius + sphere.radius) return false;
        
        var dx = ps.x - px, dy = ps.y - py, dz = ps.z - pz;
        
        static size_array = array_create(3);
        size_array[0] = self.size.x;
        size_array[1] = self.size.y;
        size_array[2] = self.size.z;
        
        for (var i = 0; i < 3; i++) {
            var axis = self.property_orientation_array[i];
            var dist = clamp(dot_product_3d(dx, dy, dz, axis.x, axis.y, axis.z), -size_array[i], size_array[i]);
            px += axis.x * dist;
            py += axis.y * dist;
            pz += axis.z * dist;
        }
        
        return point_distance_3d(px, py, pz, ps.x, ps.y, ps.z) < sphere.radius;
    };
    
    static CheckAABB = function(aabb) {
        var p1 = self.position;
        var p2 = aabb.position;
        if (point_distance_3d(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z) > aabb.property_radius + self.property_radius) return false;
        
        var axes = self.property_aabb_axes;
        
        var i = 0;
        var axis_counter = 0;
        var axis_extents = self.property_axis_extents;
        var vertices_aabb = aabb.property_vertices;
        repeat (15) {
            var xx = axes[i++];
            var yy = axes[i++];
            var zz = axes[i++];
            
            var val_min_a = axis_extents[axis_counter++];
            var val_max_a = axis_extents[axis_counter++];
            
            var vertex = vertices_aabb[0];
            var dot0 = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices_aabb[1];
            var dot1 = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices_aabb[2];
            var dot2 = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices_aabb[3];
            var dot3 = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices_aabb[4];
            var dot4 = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices_aabb[5];
            var dot5 = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices_aabb[6];
            var dot6 = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices_aabb[7];
            var dot7 = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            var val_min_b = min(dot0, dot1, dot2, dot3, dot4, dot5, dot6, dot7);
            var val_max_b = max(dot0, dot1, dot2, dot3, dot4, dot5, dot6, dot7);
            
            if ((val_min_b > val_max_a) || (val_min_a > val_max_b)) {
                return false;
            }
        }
        
        return true;
    };
    
    static CheckOBB = function(obb) {
        var p1 = self.position;
        var p2 = obb.position;
        
        if (point_distance_3d(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z) > self.property_radius + obb.property_radius) return false;
        
        static axes = array_create(15 * 3);
        
        var ix = obb.property_orientation_array[0];
        var iy = obb.property_orientation_array[1];
        var iz = obb.property_orientation_array[2];
        var ixx = ix.x, ixy = ix.y, ixz = ix.z;
        var iyx = iy.x, iyy = iy.y, iyz = iy.z;
        var izx = iz.x, izy = iz.y, izz = iz.z;
        var ox = self.property_orientation_array[0];
        var oy = self.property_orientation_array[1];
        var oz = self.property_orientation_array[2];
        var oxx = ox.x, oxy = ox.y, oxz = ox.z;
        var oyx = oy.x, oyy = oy.y, oyz = oy.z;
        var ozx = oz.x, ozy = oz.y, ozz = oz.z;
        
        axes[0 * 3 + 0] = ixx;
        axes[0 * 3 + 1] = ixy;
        axes[0 * 3 + 2] = ixz;
        axes[1 * 3 + 0] = iyx;
        axes[1 * 3 + 1] = iyy;
        axes[1 * 3 + 2] = iyz;
        axes[2 * 3 + 0] = izx;
        axes[2 * 3 + 1] = izy;
        axes[2 * 3 + 2] = izz;
        axes[3 * 3 + 0] = oxx;
        axes[3 * 3 + 1] = oxy;
        axes[3 * 3 + 2] = oxz;
        axes[4 * 3 + 0] = oyx;
        axes[4 * 3 + 1] = oyy;
        axes[4 * 3 + 2] = oyz;
        axes[5 * 3 + 0] = ozx;
        axes[5 * 3 + 1] = ozy;
        axes[5 * 3 + 2] = ozz;
        
        axes[6 * 3 + 0] = ixy * oxz - oxy * ixz;
        axes[6 * 3 + 1] = ixz * oxx - oxz * ixx;
        axes[6 * 3 + 2] = ixx * oxy - oxx * ixy;
        axes[7 * 3 + 0] = iyy * oxz - oxy * iyz;
        axes[7 * 3 + 1] = iyz * oxx - oxz * iyx;
        axes[7 * 3 + 2] = iyx * oxy - oxx * iyy;
        axes[8 * 3 + 0] = izy * oxz - oxy * izz;
        axes[8 * 3 + 1] = izz * oxx - oxz * izx;
        axes[8 * 3 + 2] = izx * oxy - oxx * izy;
        axes[9 * 3 + 0] = ixy * oyz - oyy * ixz;
        axes[9 * 3 + 1] = ixz * oyx - oyz * ixx;
        axes[9 * 3 + 2] = ixx * oyy - oyx * ixy;
        axes[10 * 3 + 0] = iyy * oyz - oyy * iyz;
        axes[10 * 3 + 1] = iyz * oyx - oyz * iyx;
        axes[10 * 3 + 2] = iyx * oyy - oyx * iyy;
        axes[11 * 3 + 0] = izy * oyz - oyy * izz;
        axes[11 * 3 + 1] = izz * oyx - oyz * izx;
        axes[11 * 3 + 2] = izx * oyy - oyx * izy;
        axes[12 * 3 + 0] = ixy * ozz - ozy * ixz;
        axes[12 * 3 + 1] = ixz * ozx - ozz * ixx;
        axes[12 * 3 + 2] = ixx * ozy - ozx * ixy;
        axes[13 * 3 + 0] = iyy * ozz - ozy * iyz;
        axes[13 * 3 + 1] = iyz * ozx - ozz * iyx;
        axes[13 * 3 + 2] = iyx * ozy - ozx * iyy;
        axes[14 * 3 + 0] = izy * ozz - ozy * izz;
        axes[14 * 3 + 1] = izz * ozx - ozz * izx;
        axes[14 * 3 + 2] = izx * ozy - ozx * izy;
        
        var vertices = self.property_vertices;
        var vertices_obb = obb.property_vertices;
        
        var i = 0;
        repeat (15) {
            var xx = axes[i++];
            var yy = axes[i++];
            var zz = axes[i++];
            
            var vertex = vertices[0];
            var dot0a = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices[1];
            var dot1a = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices[2];
            var dot2a = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices[3];
            var dot3a = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices[4];
            var dot4a = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices[5];
            var dot5a = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices[6];
            var dot6a = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices[7];
            var dot7a = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            var val_min_a = min(dot0a, dot1a, dot2a, dot3a, dot4a, dot5a, dot6a, dot7a);
            var val_max_a = max(dot0a, dot1a, dot2a, dot3a, dot4a, dot5a, dot6a, dot7a);
            vertex = vertices_obb[0];
            var dot0b = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices_obb[1];
            var dot1b = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices_obb[2];
            var dot2b = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices_obb[3];
            var dot3b = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices_obb[4];
            var dot4b = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices_obb[5];
            var dot5b = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices_obb[6];
            var dot6b = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices_obb[7];
            var dot7b = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            var val_min_b = min(dot0b, dot1b, dot2b, dot3b, dot4b, dot5b, dot6b, dot7b);
            var val_max_b = max(dot0b, dot1b, dot2b, dot3b, dot4b, dot5b, dot6b, dot7b);
            
            if ((val_min_b > val_max_a) || (val_min_a > val_max_b)) {
                return false;
            }
        }
        
        return true;
    };
    
    static CheckPlane = function(plane) {
        var normal = plane.normal;
        var nx = normal.x;
        var ny = normal.y;
        var nz = normal.z;
        var ox = self.property_orientation_array[0];
        var oy = self.property_orientation_array[1];
        var oz = self.property_orientation_array[2];
        var p = self.position;
        var plen =
            self.size.x * abs(dot_product_3d(nx, ny, nz, ox.x, ox.y, ox.z)) +
            self.size.y * abs(dot_product_3d(nx, ny, nz, oy.x, oy.y, oy.z)) +
            self.size.z * abs(dot_product_3d(nx, ny, nz, oz.x, oz.y, oz.z));
        
        var dist = dot_product_3d(nx, ny, nz, p.x, p.y, p.z) - plane.distance;
        
        return abs(dist) < plen;
    };
    
    static CheckCapsule = function(capsule) {
        return capsule.CheckOBB(self);
    };
    
    static CheckTriangle = function(triangle) {
        var p1 = self.position;
        var p2 = triangle.property_center;
        if (point_distance_3d(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z) > triangle.property_radius + self.property_radius) return false;
        
        static axes = array_create(13 * 3);
        
        var ab = triangle.property_edge_ab;
        var bc = triangle.property_edge_bc;
        var ca = triangle.property_edge_ca;
        var ixx = ab.x, ixy = ab.y, ixz = ab.z;
        var iyx = bc.x, iyy = bc.y, iyz = bc.z;
        var izx = ca.x, izy = ca.y, izz = ca.z;
        var ox = self.property_orientation_array[0];
        var oy = self.property_orientation_array[1];
        var oz = self.property_orientation_array[2];
        var oxx = ox.x, oxy = ox.y, oxz = ox.z;
        var oyx = oy.x, oyy = oy.y, oyz = oy.z;
        var ozx = oz.x, ozy = oz.y, ozz = oz.z;
        var tn = triangle.property_normal;
        
        axes[0 * 3 + 0] = oxx;
        axes[0 * 3 + 1] = oxy;
        axes[0 * 3 + 2] = oxz;
        axes[1 * 3 + 0] = oyx;
        axes[1 * 3 + 1] = oyy;
        axes[1 * 3 + 2] = oyz;
        axes[2 * 3 + 0] = ozx;
        axes[2 * 3 + 1] = ozy;
        axes[2 * 3 + 2] = ozz;
        axes[3 * 3 + 0] = tn.x;
        axes[3 * 3 + 1] = tn.y;
        axes[3 * 3 + 2] = tn.z;
        
        axes[4 * 3 + 0] = ixy * oxz - oxy * ixz;
        axes[4 * 3 + 1] = ixz * oxx - oxz * ixx;
        axes[4 * 3 + 2] = ixx * oxy - oxx * ixy;
        axes[5 * 3 + 0] = iyy * oxz - oxy * iyz;
        axes[5 * 3 + 1] = iyz * oxx - oxz * iyx;
        axes[5 * 3 + 2] = iyx * oxy - oxx * iyy;
        axes[6 * 3 + 0] = izy * oxz - oxy * izz;
        axes[6 * 3 + 1] = izz * oxx - oxz * izx;
        axes[6 * 3 + 2] = izx * oxy - oxx * izy;
        axes[7 * 3 + 0] = ixy * oyz - oyy * ixz;
        axes[7 * 3 + 1] = ixz * oyx - oyz * ixx;
        axes[7 * 3 + 2] = ixx * oyy - oyx * ixy;
        axes[8 * 3 + 0] = iyy * oyz - oyy * iyz;
        axes[8 * 3 + 1] = iyz * oyx - oyz * iyx;
        axes[8 * 3 + 2] = iyx * oyy - oyx * iyy;
        axes[9 * 3 + 0] = izy * oyz - oyy * izz;
        axes[9 * 3 + 1] = izz * oyx - oyz * izx;
        axes[9 * 3 + 2] = izx * oyy - oyx * izy;
        axes[10 * 3 + 0] = ixy * ozz - ozy * ixz;
        axes[10 * 3 + 1] = ixz * ozx - ozz * ixx;
        axes[10 * 3 + 2] = ixx * ozy - ozx * ixy;
        axes[11 * 3 + 0] = iyy * ozz - ozy * iyz;
        axes[11 * 3 + 1] = iyz * ozx - ozz * iyx;
        axes[11 * 3 + 2] = iyx * ozy - ozx * iyy;
        axes[12 * 3 + 0] = izy * ozz - ozy * izz;
        axes[12 * 3 + 1] = izz * ozx - ozz * izx;
        axes[12 * 3 + 2] = izx * ozy - ozx * izy;
        
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
            var xx = axes[i++];
            var yy = axes[i++];
            var zz = axes[i++];
            
            var vertex = vertices[0];
            var dot1 = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices[1];
            var dot2 = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices[2];
            var dot3 = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices[3];
            var dot4 = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices[4];
            var dot5 = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices[5];
            var dot6 = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices[6];
            var dot7 = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            vertex = vertices[7];
            var dot0 = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            var val_min_a = min(dot0, dot1, dot2, dot3, dot4, dot5, dot6, dot7);
            var val_max_a = max(dot0, dot1, dot2, dot3, dot4, dot5, dot6, dot7);
            
            var ada = dot_product_3d(xx, yy, zz, tax, tay, taz);
            var adb = dot_product_3d(xx, yy, zz, tbx, tby, tbz);
            var adc = dot_product_3d(xx, yy, zz, tcx, tcy, tcz);
            var val_min_b = min(ada, adb, adc);
            var val_max_b = max(ada, adb, adc);
            
            if ((val_min_b > val_max_a) || (val_min_a > val_max_b)) {
                return false;
            }
        }
        
        return true;
    };
    
    static CheckMesh = function(mesh) {
        return mesh.CheckOBB(self);
    };
    
    static CheckModel = function(model) {
        return model.CheckOBB(self);
    };
    
    static CheckRay = function(ray, hit_info = undefined) {
        static direction_dots = array_create(3);
        static position_dots = array_create(3);
        static t = array_create(6);
        
        var rd = ray.direction;
        var p = self.position;
        var o = ray.origin;
        var size_array = [self.size.x, self.size.y, self.size.z];
        
        var dx = p.x - o.x, dy = p.y - o.y, dz = p.z - o.z;
        var ox = self.property_orientation_array[0];
        var oy = self.property_orientation_array[1];
        var oz = self.property_orientation_array[2];
        var rdx = rd.x, rdy = rd.y, rdz = rd.z;
        
        direction_dots[0] = dot_product_3d(ox.x, ox.y, ox.z, rdx, rdy, rdz);
        direction_dots[1] = dot_product_3d(oy.x, oy.y, oy.z, rdx, rdy, rdz);
        direction_dots[2] = dot_product_3d(oz.x, oz.y, oz.z, rdx, rdy, rdz);
        
        position_dots[0] = dot_product_3d(ox.x, ox.y, ox.z, dx, dy, dz);
        position_dots[1] = dot_product_3d(oy.x, oy.y, oy.z, dx, dy, dz);
        position_dots[2] = dot_product_3d(oz.x, oz.y, oz.z, dx, dy, dz);
        
        for (var i = 0; i < 3; i++) {
            var dd = direction_dots[i];
            var pd = position_dots[i];
            var s = size_array[i];
            if (dd == 0) {
                if ((-pd - s) > 0 || (-pd + s) < 0) {
                    return false;
                }
                dd = 0.0001;
            }
            
            t[i * 2 + 0] = (pd + s) / dd;
            t[i * 2 + 1] = (pd - s) / dd;
        }
        
        var tmax = min(
            max(t[0], t[1]),
            max(t[2], t[3]),
            max(t[4], t[5])
        );
        
        if (tmax < 0) return false;
        
        var tmin = max(
            min(t[0], t[1]),
            min(t[2], t[3]),
            min(t[4], t[5])
        );
        
        if (tmin > tmax) return false;
        
        if (hit_info) {
            var contact_distance = (tmin < 0) ? tmax : tmin;
            var contact_normal;
            
            var contact_point = ray.origin.Add(rd.Mul(contact_distance));
            
            for (var i = 0; i < 6; i++) {
                if (contact_distance == t[i]) {
                    switch (i) {
                        case 0: contact_normal = ox; break;
                        case 1: contact_normal = ox.Mul(-1); break;
                        case 2: contact_normal = oy; break;
                        case 3: contact_normal = oy.Mul(-1); break;
                        case 4: contact_normal = oz; break;
                        case 5: contact_normal = oz.Mul(-1); break;
                    }
                }
            }
            
            hit_info.Update(contact_distance, self, contact_point, contact_normal);
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
        if (!self.CheckSphere(sphere)) return undefined;
        
        var ps = sphere.position;
        var po = self.position;
        if (ps.x == po.x && ps.y == po.y && ps.z == po.z) return undefined;
        
        var nearest = self.NearestPoint(ps);
        
        if (nearest.x == ps.x && nearest.y == ps.y && nearest.z == ps.z) {
            return undefined;
        }
        
        var dir = sphere.position.Sub(nearest).Normalize();
        return nearest.Add(dir.Mul(sphere.radius));
    };
    
    static NearestPoint = function(vec3) {
        var rx = self.position.x;
        var ry = self.position.y;
        var rz = self.position.z;
        var dx = vec3.x - rx, dy = vec3.y - ry, dz = vec3.z - rz;
        
        var size_array = [self.size.x, self.size.y, self.size.z];
        
        for (var i = 0; i < 3; i++) {
            var axis = self.property_orientation_array[i];
            var dist = dot_product_3d(dx, dy, dz, axis.x, axis.y, axis.z);
            dist = clamp(dist, -size_array[i], size_array[i]);
            rx += axis.x * dist;
            ry += axis.y * dist;
            rz += axis.z * dist;
        }
        
        return new Vector3(rx, ry, rz);
    };
    
    static GetInterval = function(axis) {
        var vertices = self.property_vertices;
        
        var xx = axis.x;
        var yy = axis.y;
        var zz = axis.z;
        
        var imin = infinity;
        var imax = -infinity;
        
        var i = 0;
        repeat (8) {
            var vertex = vertices[i++];
            var dot = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
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
}