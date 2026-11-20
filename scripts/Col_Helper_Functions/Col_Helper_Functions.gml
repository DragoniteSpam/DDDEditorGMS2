function NewColAABBFromMinMax(point_min, point_max) {
    return new ColAABB(new Vector3(
        mean(point_min.x, point_max.x),
        mean(point_min.y, point_max.y),
        mean(point_min.z, point_max.z)
    ), new Vector3(
        abs((point_max.x - point_min.x) / 2),
        abs((point_max.y - point_min.y) / 2),
        abs((point_max.z - point_min.z) / 2)
    ));
}

function NewColRayFromPoints(start, finish) {
    return new ColRay(start, new Vector3(finish.x - start.x, finish.y - start.y, finish.z - start.z));
}

function RaycastHitInformation() constructor {
    self.shape = undefined;
    self.point = undefined;
    self.distance = infinity;
    self.normal = undefined;
    
    static Update = function(distance, shape, point, normal) {
        if (distance < self.distance) {
            self.distance = distance;
            self.shape = shape;
            self.point = point;
            self.normal = normal;
        }
    };
    
    static Clear = function() {
        self.shape = undefined;
        self.point = undefined;
        self.distance = infinity;
        self.normal = undefined;
    };
}

function col_project_onto_plane(vertex, origin, norm, e1, e2) {
    var dx = vertex.x - origin.x, dy = vertex.y - origin.y, dz = vertex.z - origin.z;
    return new Vector3(
        dot_product_3d(dx, dy, dz, e1.x, e1.y, e1.z),
        dot_product_3d(dx, dy, dz, e2.x, e2.y, e2.z),
        0
    );
}

function col_lines_intersect(a, b, c, d) {
    return (col_points_are_counterclockwise(a, c, d) != col_points_are_counterclockwise(b, c, d)) &&
        (col_points_are_counterclockwise(a, b, c) != col_points_are_counterclockwise(a, b, d));
}

function col_points_are_counterclockwise(a, b, c) {
    return ((c.y - a.y) * (b.x - a.x)) < ((b.y - a.y) * (c.x - a.x));
}