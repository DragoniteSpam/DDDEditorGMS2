// feather disable GM2023
function ColWorldSpatialHash(chunk_size) constructor {
    self.chunk_size = chunk_size;
    self.chunks = { };
    
    self.bounds = undefined;
    self.object_record = { };
    
    self.planes = [];
    
    static HashFunction = function(x, y, z) {
        return $"{x},{y},{z}";
    };
    
    static GetBoundingChunk = function(object) {
        var object_min = object.shape.property_min;
        var object_max = object.shape.property_max;
        
        if (object_min == undefined) {
            return undefined;
        }
        
        return NewColAABBFromMinMax(
            new Vector3(floor(object_min.x / self.chunk_size), floor(object_min.y / self.chunk_size), floor(object_min.z / self.chunk_size)),
            new Vector3(floor(object_max.x / self.chunk_size), floor(object_max.y / self.chunk_size), floor(object_max.z / self.chunk_size))
        );
    };
    
    static GetChunk = function(x, y, z) {
        return self.chunks[$ self.HashFunction(x, y, z)];
    };
    
    static AddChunk = function(x, y, z, chunk) {
        self.chunks[$ self.HashFunction(x, y, z)] = chunk;
    };
    
    static RemoveChunk = function(x, y, z) {
        variable_struct_remove(self.chunks, self.HashFunction(x, y, z));
    };
    
    static Contains = function(object) {
        return self.object_record[$ string(ptr(object))];
    };
    
    static Add = function(object) {
        var bounds = self.GetBoundingChunk(object);
        
        if (bounds == undefined) {
            if (array_get_index(self.planes, object) == -1) {
                array_push(self.planes, object);
            }
            return;
        }
        
        var bounds_min = bounds.property_min;
        var bounds_max = bounds.property_max;
        
        // is the object already in the spatial hash?
        var location = self.Contains(object);
        if (location != undefined) {
            if (location.property_min.Equals(bounds_min) && location.property_max.Equals(bounds_max)) {
                // object's position is the same, there's no point
                return;
            } else {
                self.Remove(object);
            }
        }
        
        for (var i = bounds_min.x; i <= bounds_max.x; i++) {
            for (var j = bounds_min.y; j <= bounds_max.y; j++) {
                for (var k = bounds_min.z; k <= bounds_max.z; k++) {
                    var chunk = self.GetChunk(i, j, k);
                    
                    if (chunk == undefined) {
                        var coords = new Vector3(i, j, k);
                        var coords_min = coords.Mul(self.chunk_size);
                        var coords_max = coords_min.Add(self.chunk_size);
                        
                        var chunk_bounds = NewColAABBFromMinMax(coords_min, coords_max);
                        chunk = new ColSpatialHashNode(chunk_bounds);
                        self.AddChunk(i, j, k, chunk);
                        
                        if (self.bounds == undefined) {
                            self.bounds = NewColAABBFromMinMax(coords_min, coords_max);
                        } else {
                            self.bounds = NewColAABBFromMinMax(
                                self.bounds.property_min.Min(coords_min),
                                self.bounds.property_max.Max(coords_max)
                            );
                        }
                    }
                    
                    chunk.Add(object);
                    
                    var object_id = string(ptr(object));
                    self.object_record[$ object_id] = bounds;
                }
            }
        }
    };
    
    static Remove = function(object) {
        var plane_index = array_get_index(self.planes, object);
        if (plane_index != -1) {
            array_delete(self.planes, plane_index, 1);
            return;
        }
        
        var location = self.Contains(object);
        if (location == undefined) {
            return;
        }
        
        var bounds_min = location.property_min;
        var bounds_max = location.property_max;
        
        for (var i = bounds_min.x; i <= bounds_max.x; i++) {
            for (var j = bounds_min.y; j <= bounds_max.y; j++) {
                for (var k = bounds_min.z; k <= bounds_max.z; k++) {
                    var chunk = self.GetChunk(i, j, k);
                    chunk.Remove(object);
                    
                    if (chunk.Size() == 0) {
                        self.RemoveChunk(i, j, k);
                        
                        // you may want to resize the bounds of the spatial hash
                        // after removing an empty chunk, but i dont know if a nice
                        // way to do that besides looping over every chunk from
                        // scratch so I won't be doing that here
                    }
                }
            }
        }
        
        var object_id = string(ptr(object));
        variable_struct_remove(self.object_record, object_id);
    };
    
    static CheckObject = function(object) {
        for (var i = 0, n = array_length(self.planes); i < n; i++) {
            if (self.planes[i].CheckObject(object))
                return self.planes[i];
        }
        
        var bounds = self.GetBoundingChunk(object);
        var bounds_min = bounds.property_min;
        var bounds_max = bounds.property_max;
        
        for (var i = bounds_min.x; i <= bounds_max.x; i++) {
            for (var j = bounds_min.y; j <= bounds_max.y; j++) {
                for (var k = bounds_min.z; k <= bounds_max.z; k++) {
                    var chunk = self.GetChunk(i, j, k);
                    
                    if (chunk != undefined) {
                        var result = chunk.CheckObject(object);
                        if (result != undefined) return result;
                    }
                }
            }
        }
        
        return undefined;
    };
    
    // https://github.com/prime31/Nez/blob/master/Nez.Portable/Physics/SpatialHash.cs
    static CheckRay = function(ray, group = 1) {
        static bounds_hit_info = new RaycastHitInformation();
        bounds_hit_info.shape = undefined;
        bounds_hit_info.point = undefined;
        bounds_hit_info.distance = infinity;
        bounds_hit_info.normal = undefined;
        
        var cs = self.chunk_size;
        var rd = ray.direction;
        var rdx = rd.x, rdy = rd.y, rdz = rd.z;
        var ro = ray.origin;
        
        var hit_info = new RaycastHitInformation();
        
        for (var i = 0, n = array_length(self.planes); i < n; i++) {
            self.planes[i].CheckRay(ray, hit_info, group);
        }
        
        self.bounds.CheckRay(ray, bounds_hit_info);
        
        // if the ray does not pass through the spatial hash at all, you can
        // exit early
        if (bounds_hit_info.point == undefined) {
            if (hit_info.point == undefined) {
                return undefined;
            } else {
                return hit_info;
            }
        }
        
        var current_cell = ro.Div(cs).Floor();
        
        var chunk = self.GetChunk(current_cell.x, current_cell.y, current_cell.z);
        if (chunk != undefined) {
            if (chunk.CheckRay(ray, hit_info, group)) {
                return hit_info;
            }
        }
        
        var last_cell = bounds_hit_info.point.Div(cs).Floor();
        
        var dx = sign(rdx);
        var dy = sign(rdy);
        var dz = sign(rdz);
        
        if (current_cell.x == last_cell.x) dx = 0;
        if (current_cell.y == last_cell.y) dy = 0;
        if (current_cell.z == last_cell.z) dz = 0;
        
        var step_x = max(dx, 0);
        var step_y = max(dy, 0);
        var step_z = max(dz, 0);
        var next_boundary_x = (current_cell.x + step_x) * cs;
        var next_boundary_y = (current_cell.y + step_y) * cs;
        var next_boundary_z = (current_cell.z + step_z) * cs;
        
        var max_x = (rdx != 0) ? ((next_boundary_x - ro.x) / rdx) : infinity;
        var max_y = (rdy != 0) ? ((next_boundary_y - ro.y) / rdy) : infinity;
        var max_z = (rdz != 0) ? ((next_boundary_z - ro.z) / rdz) : infinity;
        
        var lookahead_x = (rdx != 0) ? floor(cs / (rdx * dx)) : infinity;
        var lookahead_y = (rdy != 0) ? floor(cs / (rdy * dy)) : infinity;
        var lookahead_z = (rdz != 0) ? floor(cs / (rdz * dz)) : infinity;
        
        do {
            if (max_x < max_y) {
                if (max_x < max_z) {
                    current_cell.x += dx;
                    max_x += lookahead_x;
                } else {
                    current_cell.z += dz;
                    max_z += lookahead_z;
                }
            } else {
                if (max_y < max_z) {
                    current_cell.y += dy;
                    max_y += lookahead_y;
                } else {
                    current_cell.z += dz;
                    max_z += lookahead_z;
                }
            }
            
            chunk = self.GetChunk(current_cell.x, current_cell.y, current_cell.z);
            if (chunk != undefined) {
                if (chunk.CheckRay(ray, hit_info, group)) {
                    return hit_info;
                }
            }
        } until (current_cell.Equals(last_cell));
        
        if (hit_info.point == undefined) {
            return undefined;
        }
        
        return hit_info;
    };
    
    static GetObjectsInFrustum = function(frustum, output) {
        // not implemented
    };
}

function ColSpatialHashNode(bounds) constructor {
    self.bounds = bounds;
    self.objects = [];
    
    static Add = function(object) {
        array_push(self.objects, object);
    };
    
    static Remove = function(object) {
        var index = array_get_index(self.objects, object);
        array_delete(self.objects, index, 1);
    };
    
    static Size = function() {
        return array_length(self.objects);
    };
    
    static CheckObject = function(object) {
        var i = 0;
        repeat (array_length(self.objects)) {
            if (self.objects[i].shape.CheckObject(object))
                return self.objects[i];
            i++;
        }
        return undefined;
    };
    
    static CheckRay = function(ray, hit_info, group = 1) {
        var hit_detected = false;
        var i = 0;
        repeat (array_length(self.objects)) {
            if (self.objects[i++].CheckRay(ray, hit_info, group))
                hit_detected = true;
        }
        return hit_detected;
    };
}