function ColMesh(triangle_array) constructor {
    self.triangles = triangle_array;
    
    self.property_min = new Vector3(infinity, infinity, infinity);
    self.property_max = new Vector3(-infinity, -infinity, -infinity);
    
    var bmn = self.property_min;
    var bmx = self.property_max;
    
    var i = 0;
    repeat (array_length(triangle_array)) {
        var tri = triangle_array[i++];
        bmn.x = min(bmn.x, tri.a.x, tri.b.x, tri.c.x);
        bmn.y = min(bmn.y, tri.a.y, tri.b.y, tri.c.y);
        bmn.z = min(bmn.z, tri.a.z, tri.b.z, tri.c.z);
        bmx.x = max(bmx.x, tri.a.x, tri.b.x, tri.c.x);
        bmx.y = max(bmx.y, tri.a.y, tri.b.y, tri.c.y);
        bmx.z = max(bmx.z, tri.a.z, tri.b.z, tri.c.z);
    }
    
    self.bounds = NewColAABBFromMinMax(bmn, bmx);
    
    self.accelerator = new self.octree(self.bounds, self.octree);
    self.accelerator.triangles = triangle_array;
    var t = get_timer();
    self.accelerator.Split(COL_MESH_MAX_SPLITS);
    show_debug_message($"hierarching the tree took {(get_timer() - t) / 1000} ms")
    
    static octree = function(bounds, octree) constructor {
        self.bounds = bounds;
        self.octree = octree;
        
        self.triangles = [];
        self.children = undefined;
        
        static Split = function(depth) {
            if (depth == 0) return;
            if (array_length(self.triangles) < COL_MIN_TREE_DENSITY) return;
            if (self.children != undefined) return;
            
            var center = self.bounds.position;
            var sides = self.bounds.half_extents.Mul(0.5);
            
            self.children = [
                new self.octree(new ColAABB(center.Add(new Vector3(-sides.x,  sides.y, -sides.z)), sides), self.octree),
                new self.octree(new ColAABB(center.Add(new Vector3( sides.x,  sides.y, -sides.z)), sides), self.octree),
                new self.octree(new ColAABB(center.Add(new Vector3(-sides.x,  sides.y,  sides.z)), sides), self.octree),
                new self.octree(new ColAABB(center.Add(new Vector3( sides.x,  sides.y,  sides.z)), sides), self.octree),
                new self.octree(new ColAABB(center.Add(new Vector3(-sides.x, -sides.y, -sides.z)), sides), self.octree),
                new self.octree(new ColAABB(center.Add(new Vector3( sides.x, -sides.y, -sides.z)), sides), self.octree),
                new self.octree(new ColAABB(center.Add(new Vector3(-sides.x, -sides.y,  sides.z)), sides), self.octree),
                new self.octree(new ColAABB(center.Add(new Vector3( sides.x, -sides.y,  sides.z)), sides), self.octree),
            ];
            
            var i = 0;
            repeat (array_length(self.children)) {
                var tree = self.children[i];
                var j = 0;
                repeat (array_length(self.triangles)) {
                    if (tree.bounds.CheckTriangle(self.triangles[j])) {
                        array_push(tree.triangles, self.triangles[j]);
                    }
                    j++;
                }
                if (array_length(tree.triangles) == 0) {
                    self.children[i] = undefined;
                } else {
                    tree.Split(depth - 1);
                }
                i++;
            }
        };
    };
    
    static quadtree = function(bounds, quadtree) constructor {
        self.bounds = bounds;
        self.quadtree = quadtree;
        
        self.triangles = [];
        self.children = undefined;
        
        static Split = function(depth) {
            if (depth == 0) return;
            if (array_length(self.triangles) < COL_MIN_TREE_DENSITY) return;
            if (self.children != undefined) return;
            
            static subdivision_factor = new Vector3(0.5, 0.5, 1);
            
            var center = self.bounds.position;
            var sides = self.bounds.half_extents.Mul(subdivision_factor);
            
            self.children = [
                new self.quadtree(new ColAABB(center.Add(new Vector3(-sides.x,  sides.y, 0)), sides), self.quadtree),
                new self.quadtree(new ColAABB(center.Add(new Vector3( sides.x,  sides.y, 0)), sides), self.quadtree),
                new self.quadtree(new ColAABB(center.Add(new Vector3(-sides.x, -sides.y, 0)), sides), self.quadtree),
                new self.quadtree(new ColAABB(center.Add(new Vector3( sides.x, -sides.y, 0)), sides), self.quadtree),
            ];
            
            var i = 0;
            repeat (array_length(self.children)) {
                var tree = self.children[i];
                var j = 0;
                repeat (array_length(self.triangles)) {
                    if (tree.bounds.CheckTriangle(self.triangles[j])) {
                        array_push(tree.triangles, self.triangles[j]);
                    }
                    j++;
                }
                if (array_length(tree.triangles) == 0) {
                    self.children[i] = undefined;
                } else {
                    tree.Split(depth - 1);
                }
                i++;
            }
        };
    };
    
    static CheckObject = function(object) {
        return object.shape.CheckMesh(self);
    };
    
    static CheckGeneral = function(shape) {
        var process_these = [self.accelerator];
        
        while (array_length(process_these) > 0) {
            var tree = process_these[0];
            array_delete(process_these, 0, 1);
            
            if (tree.children == undefined) {
                for (var i = 0, n = array_length(tree.triangles); i < n; i++) {
                    if (shape.CheckTriangle(tree.triangles[i])) {
                        return true;
                    }
                }
            } else {
                for (var i = 0, n = array_length(tree.children); i < n; i++) {
                    if (tree.children[i] == undefined) continue;
                    if (shape.CheckAABB(tree.children[i].bounds)) {
                        array_push(process_these, tree.children[i]);
                    }
                }
            }
        }
        
        return false;
    };
    
    static CheckPoint = function(point) {
        return self.CheckGeneral(point);
    };
    
    static CheckSphere = function(sphere) {
        return self.CheckGeneral(sphere);
    };
    
    static CheckAABB = function(aabb) {
        return self.CheckGeneral(aabb);
    };
    
    static CheckPlane = function(plane) {
        return self.CheckGeneral(plane);
    };
    
    static CheckTriangle = function(triangle) {
        return self.CheckGeneral(triangle);
    };
    
    static CheckMesh = function(mesh) {
        return self.CheckGeneral(mesh);
    };
    
    static CheckModel = function(model) {
        return false;
    };
    
    static CheckOBB = function(obb) {
        return self.CheckGeneral(obb);
    };
    
    static CheckCapsule = function(capsule) {
        return self.CheckGeneral(capsule);
    };
    
    static CheckRay = function(ray, hit_info = undefined) {
        var process_these = [self.accelerator];
        static dummy_hit_info = new RaycastHitInformation();
        dummy_hit_info.Clear();
        
        var hit_detected = false;
        
        while (array_length(process_these) > 0) {
            var tree = process_these[0];
            array_delete(process_these, 0, 1);
            
            if (tree.children == undefined) {
                for (var i = 0; i < array_length(tree.triangles); i++) {
                    if (ray.CheckTriangle(tree.triangles[i], hit_info)) {
                        hit_detected = true;
                    }
                }
            } else {
                for (var i = 0, n = array_length(tree.children); i < n; i++) {
                    if (tree.children[i] == undefined) continue;
                    if (ray.CheckAABB(tree.children[i].bounds, dummy_hit_info)) {
                        array_push(process_these, tree.children[i]);
                    }
                }
            }
        }
        
        return hit_detected;
    };
    
    static CheckLine = function(line) {
        static hit_info = new RaycastHitInformation();
        hit_info.Clear();
        
        if (self.CheckRay(line.property_ray, hit_info)) {
            return (hit_info.distance <= line.property_length);
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