function MapContents(parent) constructor {
    // helper struct; does NOT extend Data
    self.parent = parent;
    
    self.batches = [ ];                           // array of structs
    self.batch_in_the_future = ds_list_create();     // entities
    self.dynamic = ds_list_create();                 // entities
    
    self.all_entities = ds_list_create();            // entities
    self.all_zones = [];
    self.refids = { };                               // entities (mapped onto refids)
    self.refid_current = 0;
    
    // these just needs to exist for now, it'll get resized when stuff is loaded
    self.map_grid = array_create_4d(parent.xx, parent.yy, parent.zz, MapCellContents._COUNT, undefined);
    self.frozen = undefined;                         // everything that will be a single batch in the game
    self.frozen_data = undefined;                    // the raw data in the frozen vertex buffer
    self.reflect_frozen = undefined;
    self.reflect_frozen_data = undefined;
    
    self.water = undefined;
    self.water_data = undefined;
    
    self.stats = new (function(parent) constructor {
        self.parent = parent;
        
        self.GetEntityCount = function() {
            return ds_list_size(self.parent.all_entities);
        };
        
        self.GetZoneCount = function() {
            return array_length(self.parent.all_zones);
        };
        
        self.GetVertexByteCount = function() {
            return self.parent.frozen_data ? buffer_get_size(self.parent.frozen_data) : 0;
        };
        
        self.GetVertexCount = function() {
            return self.GetVertexByteCount() / VERTEX_SIZE;
        };
        
        self.GetVertexTriangleCount = function() {
            return self.GetVertexByteCount() / VERTEX_SIZE / 3;
        };
    })(self);
    
    static ClearFrozenData = function() {
        if (self.frozen) vertex_delete_buffer(self.frozen);
        if (self.reflect_frozen) vertex_delete_buffer(self.reflect_frozen);
        if (self.frozen_data) buffer_delete(self.frozen_data);
        if (self.reflect_frozen_data) buffer_delete(self.reflect_frozen_data);
        
        self.frozen = undefined;
        self.frozen_data = undefined;
        self.reflect_frozen = undefined;
        self.reflect_frozen_data = undefined;
        
        self.water = undefined;
        self.water_data = undefined;
        if (self.water) vertex_delete_buffer(self.water);
        if (self.water_data) buffer_delete(self.water_data);
    };
    
    static Destroy = function() {
        for (var i = 0; i < array_length(self.batches); i++) {
            var data = self.batches[i];
            if (data.vertex) vertex_delete_buffer(data.vertex);
            if (data.reflect_vertex) vertex_delete_buffer(data.reflect_vertex);
        }
        
        // don't actually delete the instances from here or bad things will happen
        ds_list_destroy(self.batch_in_the_future);
        ds_list_destroy(self.dynamic);
        
        // the last three lists are not guaranteed to have all
        // entities in the map in them. this one is.
        ds_list_destroy_instances(self.all_entities);
        for (var i = 0; i < array_length(self.all_zones); i++) {
            self.all_zones[i].Destroy();
        }
        
        self.ClearFrozenData();
    };
}

enum MapCellContents {
    TILE,
    MESH,
    PAWN,
    EFFECT,
    EVENT,
    _COUNT
}