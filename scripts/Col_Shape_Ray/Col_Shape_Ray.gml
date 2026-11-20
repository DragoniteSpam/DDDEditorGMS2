function ColRay(origin, direction) constructor {
    self.origin = origin;                   // Vec3
    var mag = point_distance_3d(0, 0, 0, direction.x, direction.y, direction.z);
    self.direction = new Vector3(
        direction.x / mag,
        direction.y / mag,
        direction.z / mag
    );                                      // vec3
    
    static CheckPoint = function(point, hit_info) {
        return point.CheckRay(self, hit_info);
    };
    
    static CheckSphere = function(sphere, hit_info) {
        return sphere.CheckRay(self, hit_info);
    };
    
    static CheckAABB = function(aabb, hit_info) {
        return aabb.CheckRay(self, hit_info);
    };
    
    static CheckPlane = function(plane, hit_info) {
        return plane.CheckRay(self, hit_info);
    };
    
    static CheckOBB = function(obb, hit_info) {
        return obb.CheckRay(self, hit_info);
    };
    
    static CheckCapsule = function(capsule, hit_info) {
        return capsule.CheckRay(self, hit_info);
    };
    
    static CheckTriangle = function(triangle, hit_info) {
        return triangle.CheckRay(self, hit_info);
    };
    
    static CheckMesh = function(mesh, hit_info) {
        return mesh.CheckRay(self, hit_info);
    };
    
    static CheckModel = function(model, hit_info) {
        return model.CheckRay(self, hit_info);
    };
    
    static CheckRay = function(ray, hit_info = undefined) {
        return false;
    };
    
    static CheckLine = function(line, hit_info) {
        return false;
    };
    
    static DisplaceSphere = function(sphere) {
        return undefined;
    };
    
    static NearestPoint = function(vec3) {
        var origin = self.origin;
        var vx = vec3.x - origin.x;
        var vy = vec3.y - origin.y;
        var vz = vec3.z - origin.z;
        var d = self.direction;
        var t = max(dot_product_3d(vx, vy, vz, d.x, d.y, d.z), 0);
        return new Vector3(
            origin.x + d.x * t,
            origin.y + d.y * t,
            origin.z + d.z * t
        );
    };
    
    static GetMin = function() {
        return undefined;
    };
    
    static GetMax = function() {
        return undefined;
    };
}