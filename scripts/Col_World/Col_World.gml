function ColObject(shape, reference, mask = 1, group = 1) constructor {
    self.shape = shape;
    self.reference = reference;
    self.mask = mask;                                   // what other objects can collide with me
    self.group = group;                                 // what masks i can detect collisions with
    shape.object = self;
    
    self.proxy = undefined;
    
    static CheckObject = function(object) {
        if (object == self) return false;
        if ((self.mask & object.group) == 0) return false;
        // this theoretically speeds up this method by quite a bit by cutting
        // out one, possibly two, levels of indirect method calls, but in
        // practice most of the time you'll be using the world collision checking
        // methods, which don't actually call this
        
        var this_shape = self.shape;
        var that_shape = object.shape;
        
        switch (instanceof(this_shape)) {
            case "ColPoint": {
                switch (instanceof(that_shape)) {
                    case "ColPoint": return this_shape.CheckPoint(that_shape);
                    case "ColSphere": return this_shape.CheckSphere(that_shape);
                    case "ColAABB": return this_shape.CheckAABB(that_shape);
                    case "ColOBB": return that_shape.CheckPoint(this_shape);
                    case "ColPlane": return this_shape.CheckPlane(that_shape);
                    case "ColCapsule": return that_shape.CheckPoint(this_shape);
                    case "ColTriangle": return this_shape.CheckTriangle(that_shape);
                }
            }
            case "ColSphere": {
                switch (instanceof(that_shape)) {
                    case "ColPoint": return that_shape.CheckSphere(this_shape);
                    case "ColSphere": return this_shape.CheckSphere(that_shape);
                    case "ColAABB": return this_shape.CheckAABB(that_shape);
                    case "ColOBB": return that_shape.CheckSphere(this_shape);
                    case "ColPlane": return this_shape.CheckPlane(that_shape);
                    case "ColCapsule": return that_shape.CheckSphere(this_shape);
                    case "ColTriangle": return this_shape.CheckTriangle(that_shape);
                }
            }
            case "ColAABB": {
                switch (instanceof(that_shape)) {
                    case "ColPoint": return that_shape.CheckAABB(this_shape);
                    case "ColSphere": return that_shape.CheckAABB(this_shape);
                    case "ColAABB": return this_shape.CheckAABB(that_shape);
                    case "ColOBB": return that_shape.CheckAABB(this_shape);
                    case "ColPlane": return this_shape.CheckPlane(that_shape);
                    case "ColCapsule": return that_shape.CheckAABB(this_shape);
                    case "ColTriangle": return this_shape.CheckTriangle(that_shape);
                }
            }
            case "ColOBB": {
                switch (instanceof(that_shape)) {
                    case "ColPoint": return this_shape.CheckPoint(that_shape);
                    case "ColSphere": return this_shape.CheckSphere(that_shape);
                    case "ColAABB": return this_shape.CheckAABB(that_shape);
                    case "ColOBB": return this_shape.CheckOBB(that_shape);
                    case "ColPlane": return this_shape.CheckPlane(that_shape);
                    case "ColCapsule": return that_shape.CheckOBB(this_shape);
                    case "ColTriangle": return this_shape.CheckTriangle(that_shape);
                }
            }
            case "ColPlane": {
                switch (instanceof(that_shape)) {
                    case "ColPoint": return that_shape.CheckPlane(this_shape);
                    case "ColSphere": return that_shape.CheckPlane(this_shape);
                    case "ColAABB": return that_shape.CheckPlane(this_shape);
                    case "ColOBB": return that_shape.CheckPlane(this_shape);
                    case "ColPlane": return this_shape.CheckPlane(that_shape);
                    case "ColCapsule": return that_shape.CheckPlane(this_shape);
                    case "ColTriangle": return this_shape.CheckTriangle(that_shape);
                }
            }
            case "ColCapsule": {
                switch (instanceof(that_shape)) {
                    case "ColPoint": return this_shape.CheckPoint(that_shape);
                    case "ColSphere": return this_shape.CheckSphere(that_shape);
                    case "ColAABB": return this_shape.CheckAABB(that_shape);
                    case "ColOBB": return this_shape.CheckOBB(that_shape);
                    case "ColPlane": return this_shape.CheckPlane(that_shape);
                    case "ColCapsule": return this_shape.CheckCapsule(that_shape);
                    case "ColTriangle": return this_shape.CheckTriangle(that_shape);
                }
            }
            case "ColTriangle": {
                switch (instanceof(that_shape)) {
                    case "ColPoint": return that_shape.CheckTriangle(this_shape);
                    case "ColSphere": return that_shape.CheckTriangle(this_shape);
                    case "ColAABB": return that_shape.CheckTriangle(this_shape);
                    case "ColOBB": return that_shape.CheckTriangle(this_shape);
                    case "ColPlane": return that_shape.CheckTriangle(this_shape);
                    case "ColCapsule": return that_shape.CheckTriangle(this_shape);
                    case "ColTriangle": return this_shape.CheckTriangle(that_shape);
                }
            }
        }
        
        // most of the remaining shapes aren't that useful and might as well be
        // handled generically
        return self.shape.CheckObject(object);
    };
    
    static CheckRay = function(ray, hit_info, group = 1) {
        if ((self.mask & group) == 0) return false;
        return self.shape.CheckRay(ray, hit_info);
    };
    
    static DisplaceSphere = function(sphere) {
        return self.shape.DisplaceSphere(sphere);
    };
    
    static GetMin = function() {
        return self.shape.point_min;
    };
    
    static GetMax = function() {
        return self.shape.point_max;
    };
}

function ColWorld(accelerator) constructor {
    self.accelerator = accelerator;
    
    // sphere displacement gets a little difficult if planes (usually the floor)
    // aren't handled first
    self.planes = [];
    
    static Add = function(object) {
        if (instanceof(object.shape) == "ColPlane") {
            array_push(self.planes, object);
        } else {
            self.accelerator.Add(object);
        }
    };
    
    static Remove = function(object) {
        if (instanceof(object.shape) == "ColPlane") {
            array_delete(self.planes, array_get_index(self.planes, object), 1);
        } else {
            self.accelerator.Remove(object);
        }
    };
    
    static Update = function(object) {
        if (instanceof(object.shape) != "ColPlane") {
            self.Remove(object);
            self.Add(object);
        }
    };
    
    static CheckObject = function(object) {
        for (var i = 0, n = array_length(self.planes); i < n; i++) {
            if (self.planes[i].CheckObject(object)) {
                return self.planes[i];
            }
        }
        return self.accelerator.CheckObject(object);
    };
    
    static CheckRay = function(ray, group = 1, distance = infinity) {
        var hit_info = new RaycastHitInformation();
        
        for (var i = 0, n = array_length(self.planes); i < n; i++) {
            self.planes[i].CheckRay(ray, hit_info, group);
        }
        
        self.accelerator.CheckRay(ray, hit_info, group);
        
        return (hit_info.distance <= distance) ? hit_info : undefined;
    };
    
    static DisplaceSphere = function(sphere_object, attempts = COL_DEFAULT_SPHERE_DISPLACEMENT_ATTEMPTS) {
        var current_position = sphere_object.shape.position;
        
        repeat (attempts) {
            // first try to find a plane you're in collision with
            var collided_with = undefined;
            for (var i = 0, n = array_length(self.planes); i < n; i++) {
                if (self.planes[i].shape.CheckObject(sphere_object)) {
                    collided_with = self.planes[i];
                    break;
                }
            }
            
            // if you can't do that, look for a regular collision object
            collided_with ??= self.accelerator.CheckObject(sphere_object);
            if (collided_with == undefined) break;
            
            var displaced_position = collided_with.shape.DisplaceSphere(sphere_object.shape);
            if (displaced_position == undefined) break;
            
            sphere_object.shape.Set(displaced_position);
        }
        
        var displaced_position = sphere_object.shape.position;
        if (current_position == displaced_position) return undefined;
        sphere_object.shape.Set(current_position);
        
        return displaced_position;
    };
    
    static GetObjectsInFrustum = function(view_mat, proj_mat) {
        // assuming planes are in the frustum by default is easier than calculating them
        var output = variable_clone(self.planes);
        
        // gamemaker worlds aren't recursive
        if (self.accelerator.self_contained_frustum_check) {
            self.accelerator.GetObjectsInFrustum(output, view_mat, proj_mat);
            return output;
        }
        
        var current_camera = camera_get_active();
        static filter_camera = camera_create();
        camera_set_view_mat(filter_camera, view_mat);
        camera_set_proj_mat(filter_camera, proj_mat);
        camera_apply(filter_camera);
        matrix_set(matrix_view, view_mat);
        matrix_set(matrix_projection, proj_mat);
        self.accelerator.GetObjectsInFrustum(output);
        var n = array_unique_ext(output);
        array_resize(output, n);
        camera_apply(current_camera);
        return output;
    };
}

function ColWorldGameMaker() constructor {
    static world_cleanup = undefined;
    
    self.self_contained_frustum_check = true;
    self.world_content = { };
    
    if (world_cleanup == undefined) {
        world_cleanup = [];
        call_later(13.37, time_source_units_seconds, function() {
            for (var i = array_length(world_cleanup) - 1; i >= 0; i--) {
                var data = world_cleanup[i];
                if (!weak_ref_alive(data.ref)) {
                    struct_foreach(data.content, function(key, value) {
                        if (instance_exists(value.proxy)) {
                            instance_destroy(value.proxy);
                        }
                    });
                    array_delete(world_cleanup, i, 1);
                }
            };
        }, true);
    }
    
    array_push(world_cleanup, {
        ref: weak_ref_create(self),
        content: self.world_content
    });
    
    static Add = function(object) {
        if (struct_exists(object.shape, "property_min") && object.shape.property_min != undefined) {
            if (!instance_exists(object.proxy)) {
                self.world_content[$ string(ptr(object))] = object;
                object.proxy = instance_create_depth(0, 0, 0, obj_col_proxy, {
                    ref: object
                });
            }
            
            with (object) {
                self.proxy.x = self.shape.property_min.x;
                self.proxy.y = self.shape.property_min.y;
                self.proxy.image_xscale = self.shape.property_max.x - self.proxy.x;
                self.proxy.image_yscale = self.shape.property_max.y - self.proxy.y;
            }
        }
    };
    
    static Remove = function(object) {
        if (instance_exists(object.proxy)) {
            struct_remove(self.world_content, string(ptr(object)));
            instance_destroy(object.proxy);
        }
    };
    
    static CheckObject = function(object) {
        static hits = ds_list_create();
        ds_list_clear(hits);
        
        if (!instance_exists(object.proxy)) {
            object.proxy = instance_create_depth(0, 0, 0, obj_col_proxy, {
                ref: object
            });
        }
        
        with (object) {
            self.proxy.x = self.shape.property_min.x;
            self.proxy.y = self.shape.property_min.y;
            self.proxy.image_xscale = self.shape.property_max.x - self.proxy.x;
            self.proxy.image_yscale = self.shape.property_max.y - self.proxy.y;
        }
        
        if (instance_exists(object.proxy)) {
            with (object.proxy) {
                var n = instance_place_list(self.x, self.y, obj_col_proxy, hits, false);
                for (var i = 0; i < n; i++) {
                    var thing = hits[| i];
                    if (thing.ref.CheckObject(object)) {
                        return thing.ref;
                    }
                }
            }
        }
        
        return undefined;
    };
    
    static CheckRay = function(ray, hit_info, group = 1) {
        static max_dist = 100_000;
        static hits = ds_list_create();
        ds_list_clear(hits);
        var x1 = ray.origin.x;
        var y1 = ray.origin.y;
        var x2 = x1 + max_dist * ray.direction.x;
        var y2 = y1 + max_dist * ray.direction.y;
        
        // if the ray is pointing perfect into (or out of) the XY plane, use a point check
        var n = 0;
        if (point_distance(x1, y1, x2, y2) == 0) {
            n = collision_point_list(x1, y1, obj_col_proxy, false, true, hits, false);
        } else {
            n = collision_line_list(x1, y1, x2, y2, obj_col_proxy, false, true, hits, false);
        }
        
        var result = false;
        var i = 0;
        repeat (n) {
            if (hits[| i++].ref.CheckRay(ray, hit_info, group)) {
                result = true;
            }
        }
        
        return result;
    };
    
    static GetObjectsInFrustum = function(output, view_mat, proj_mat) {
        static xx = array_create(8);
        static yy = array_create(8);
        
        var frustum = new ColCameraFrustum(view_mat, proj_mat);
        var corners = frustum.GetCorners();
        xx[0] = corners[0].x;
        xx[1] = corners[1].x;
        xx[2] = corners[2].x;
        xx[3] = corners[3].x;
        xx[4] = corners[4].x;
        xx[5] = corners[5].x;
        xx[6] = corners[6].x;
        xx[7] = corners[7].x;
        yy[0] = corners[0].y;
        yy[1] = corners[1].y;
        yy[2] = corners[2].y;
        yy[3] = corners[3].y;
        yy[4] = corners[4].y;
        yy[5] = corners[5].y;
        yy[6] = corners[6].y;
        yy[7] = corners[7].y;
        
        var xmin = script_execute_ext(min, xx);
        var xmax = script_execute_ext(max, xx);
        var ymin = script_execute_ext(min, yy);
        var ymax = script_execute_ext(max, yy);
        
        static hits = ds_list_create();
        ds_list_clear(hits);
        
        var i = 0;
        repeat (collision_rectangle_list(xmin, ymin, xmax, ymax, obj_col_proxy, false, true, hits, false)) {
            array_push(output, hits[| i++].ref);
        }
    };
}

function ColWorldOctree(bounds, depth) constructor {
    self.bounds = bounds;
    self.depth = depth;
    self.self_contained_frustum_check = false;
    
    self.contents = [];
    self.children = undefined;
    
    static Split = function() {
        var center = self.bounds.position;
        var sides = self.bounds.half_extents.Mul(0.5);
        var sx = sides.x;
        var sy = sides.y;
        var sz = sides.z;
        var d = self.depth - 1;
        
        var cx = center.x;
        var cy = center.y;
        var cz = center.z;
        
        self.children = [
            new ColWorldOctree(new ColAABB(new Vector3(cx - sx, cy + sy, cz - sz), sides), d),
            new ColWorldOctree(new ColAABB(new Vector3(cx + sx, cy + sy, cz - sz), sides), d),
            new ColWorldOctree(new ColAABB(new Vector3(cx - sx, cy + sy, cz + sz), sides), d),
            new ColWorldOctree(new ColAABB(new Vector3(cx + sx, cy + sy, cz + sz), sides), d),
            new ColWorldOctree(new ColAABB(new Vector3(cx - sx, cy - sy, cz - sz), sides), d),
            new ColWorldOctree(new ColAABB(new Vector3(cx + sx, cy - sy, cz - sz), sides), d),
            new ColWorldOctree(new ColAABB(new Vector3(cx - sx, cy - sy, cz + sz), sides), d),
            new ColWorldOctree(new ColAABB(new Vector3(cx + sx, cy - sy, cz + sz), sides), d),
        ];
        
        array_foreach(self.children, method({ contents: self.contents }, function(node) {
            array_foreach (self.contents, method({ node: node }, function(item) {
                self.node.Add(item);
            }));
        }));
    };
    
    static Add = function(object) {
        if (!object.shape.CheckAABB(self.bounds)) return;
        if (array_contains(self.contents, object)) return;
        
        array_push(self.contents, object);
        
        if (self.depth > 0) {
            if (self.children == undefined && array_length(self.contents) >= COL_MIN_TREE_DENSITY) {
                self.Split();
            }
            
            if (self.children != undefined) {
                array_foreach(self.children, method({ object: object }, function(node) {
                    node.Add(self.object);
                }));
            }
        }
    };
    
    static Remove = function(object) {
        var index = array_get_index(self.contents, object);
        if (index != -1) {
            array_delete(self.contents, index, 1);
            if (self.children != undefined) {
                array_foreach(self.children, method({ object: object }, function(subdivision) {
                    subdivision.Remove(self.object);
                }));
            }
        }
    };
    
    static CheckObject = function(object) {
        var to_check = [self];
        while (array_length(to_check) > 0) {
            var tree = to_check[0];
            array_delete(to_check, 0, 1);
            if (!object.shape.CheckAABB(tree.bounds)) continue;
            if (tree.children == undefined) {
                var i = 0;
                repeat (array_length(tree.contents)) {
                    if (tree.contents[i].shape.CheckObject(object)) {
                        return tree.contents[i];
                    }
                    i++;
                }
            } else {
                var head = array_length(to_check);
                var additions = array_length(tree.children);
                array_resize(to_check, head + additions)
                array_copy(to_check, head, tree.children, 0, additions);
            }
        }
        
        return undefined;
    };
    
    static CheckRay = function(ray, hit_info, group = 1) {
        if (!ray.CheckAABB(self.bounds)) return;
        
        var result = false;
        if (self.children == undefined) {
            var i = 0;
            repeat (array_length(self.contents)) {
                if (self.contents[i++].CheckRay(ray, hit_info, group)) {
                    result = true;
                }
            }
        } else {
            var i = 0;
            repeat (array_length(self.children)) {
                if (self.children[i++].CheckRay(ray, hit_info, group)) {
                    result = true;
                }
            }
        }
        
        return result;
    };
    
    static GetObjectsInFrustum = function(output) {
        var status = self.bounds.CheckFrustumFast();
        
        if (status == EFrustumResults.OUTSIDE)
            return;
        
        if (self.children == undefined) {
            var output_length = array_length(output);
            var contents_length = array_length(self.contents);
            array_resize(output, output_length + contents_length);
            array_copy(output, output_length, self.contents, 0, contents_length);
            return;
        }
        
        array_foreach(self.children, method({ output: output }, function(node) {
            node.GetObjectsInFrustum(self.output);
        }));
    };
}

function ColWorldQuadtree(bounds, depth) : ColWorldOctree(bounds, depth) constructor {
    static Split = function() {
        static factor = new Vector3(0.5, 0.5, 1);
        
        var center = self.bounds.position;
        var sides = self.bounds.half_extents.Mul(factor);
        var sx = sides.x;
        var sy = sides.y;
        var d = self.depth - 1;
        
        var cx = center.x;
        var cy = center.y;
        var cz = center.z;
        
        self.children = [
            new ColWorldQuadtree(new ColAABB(new Vector3(cx - sx, cy + sy, cz), sides), d),
            new ColWorldQuadtree(new ColAABB(new Vector3(cx + sx, cy + sy, cz), sides), d),
            new ColWorldQuadtree(new ColAABB(new Vector3(cx + sx, cy - sy, cz), sides), d),
            new ColWorldQuadtree(new ColAABB(new Vector3(cx - sx, cy - sy, cz), sides), d),
        ];
        
        array_foreach(self.children, method({ contents: self.contents }, function(node) {
            array_foreach (self.contents, method({ node: node }, function(item) {
                self.node.Add(item);
            }));
        }));
    };
}