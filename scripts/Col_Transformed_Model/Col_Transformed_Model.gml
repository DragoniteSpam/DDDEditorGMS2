// feather disable GM2023
// feather disable GM1041
function ColTransformedModel(mesh, position = new Vector3(0, 0, 0), rotation = matrix_build_identity()) constructor {
    self.mesh = undefined;
    self.position = undefined;
    self.rotation = undefined;
    self.property_inverse = matrix_build_identity();
    self.property_transform = matrix_build_identity();
    self.Set(mesh, position, rotation);
    
    static Set = function(mesh = self.mesh, position = self.position, rotation = self.rotation) {
        static position_mat = matrix_build_identity();
        
        if (is_array(mesh)) mesh = new ColMesh(mesh);
        self.mesh = mesh;
        self.position = position;
        self.rotation = rotation;
        
        matrix_build(position.x, position.y, position.z, 0, 0, 0, 1, 1, 1, position_mat);
        matrix_multiply(rotation, position_mat, self.property_transform);
        matrix_inverse(self.property_transform, self.property_inverse);
        
        self.property_obb = new ColOBB(mat4_mul_point(self.property_transform, mesh.bounds.position), mesh.bounds.half_extents, self.property_transform);
        self.property_min = self.property_obb.property_min;
        self.property_max = self.property_obb.property_max;
    };
    
    static GetTransformMatrix = function() {
        return variable_clone(self.property_transform);
    };
    
    static CheckPoint = function(point) {
        if (!self.property_obb.CheckPoint(point)) return false;
        
        var untransformed = new ColPoint(mat4_mul_point(self.property_inverse, point.position));
        return self.mesh.CheckPoint(untransformed);
    };
    
    static CheckSphere = function(sphere) {
        if (!self.property_obb.CheckSphere(sphere)) return false;
        
        var untransformed = new ColSphere(mat4_mul_point(self.property_inverse, sphere.position), sphere.radius);
        return self.mesh.CheckSphere(untransformed);
    };
    
    static CheckAABB = function(aabb) {
        if (!self.property_obb.CheckAABB(aabb)) return false;
        
        var untransformed = new ColOBB(mat4_mul_point(self.property_inverse, aabb.position), aabb.half_extents, self.property_inverse);
        return self.mesh.CheckOBB(untransformed);
    };
    
    static CheckOBB = function(obb) {
        if (!self.property_obb.CheckOBB(obb)) return false;
        
        static untransformed_inverse = matrix_build_identity();
        
        matrix_multiply(obb.orientation, self.property_inverse, untransformed_inverse);
        
        var untransformed = new ColOBB(mat4_mul_point(self.property_inverse, obb.position), obb.size, untransformed_inverse);
        return self.mesh.CheckOBB(untransformed);
    };
    
    static CheckPlane = function(plane) {
        if (!self.property_obb.CheckPlane(plane)) return false;
        
        var point = plane.normal.Mul(plane.distance);
        point = mat4_mul_point(self.property_inverse, point);
        
        var normal = mat4_mul_vector(self.property_inverse, plane.normal);
        var distance = point.Dot(normal);
        
        var untransformed = new ColPlane(normal, distance);
        return self.mesh.CheckPlane(untransformed);
    };
    
    static CheckCapsule = function(capsule) {
        if (!capsule.CheckOBB(self.property_obb)) return false;
        
        var untransformed = new ColCapsule(mat4_mul_point(self.property_inverse, capsule.line.start), mat4_mul_point(self.property_inverse, capsule.line.finish), capsule.radius);
        return self.mesh.CheckCapsule(untransformed);
    };
    
    static CheckTriangle = function(triangle) {
        if (!self.property_obb.CheckTriangle(triangle)) return false;
        
        var inverse = self.property_inverse;
        // "homework"
    };
    
    static CheckMesh = function(mesh) {
        if (!mesh.CheckOBB(self.property_obb)) return false;
        
        return false;
    };
    
    static CheckModel = function(model) {
        if (!model.CheckOBB(self.property_obb)) return false;
        
        return false;
    };
    
    static CheckLine = function(line) {
        if (!self.property_obb.CheckLine(line)) return false;
        
        var inverse = self.property_inverse;
        // "homework"
    };
    
    static CheckRay = function(ray, hit_info = undefined) {
        if (!self.property_obb.CheckRay(ray)) return false;
        
        static untransformed_hit_info = new RaycastHitInformation();
        untransformed_hit_info.distance = infinity;
        
        var untransformed = new ColRay(mat4_mul_point(self.property_inverse, ray.origin), mat4_mul_vector(self.property_inverse, ray.direction));
        
        if (self.mesh.CheckRay(untransformed, untransformed_hit_info)) {
            if (hit_info) {
                var point = mat4_mul_point(self.property_transform, untransformed_hit_info.point);
                var normal = mat4_mul_vector(self.property_transform, untransformed_hit_info.normal);
                var distance = point_distance_3d(ray.origin.x, ray.origin.y, ray.origin.z, point.x, point.y, point.z);
                hit_info.Update(distance, self, point, normal);
            }
            return true;
        }
        
        return false;
    };
    
    static DisplaceSphere = function(sphere) {
        return undefined;
    };
    
    static GetMin = function() {
        return self.property_min.Clone();
    };
    
    static GetMax = function() {
        return self.property_max.Clone();
    };
}