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
    self.frozen_wire = undefined;                    // the wireframe for the frozen vertex buffer
    self.frozen_data = undefined;                    // the raw data in the frozen vertex buffer
    self.frozen_data_wire = undefined;               // the raw data in the frozen wireframe vertex buffer
    self.reflect_frozen = undefined;
    self.reflect_frozen_wire = undefined;
    self.reflect_frozen_data = undefined;
    self.reflect_frozen_data_wire = undefined;
    
    self.population = [0, 0, 0, 0, 0, 0, 0];
    self.population_static = 0;
    
    static ClearFrozenData = function() {
        if (self.frozen) vertex_delete_buffer(self.frozen);
        if (self.frozen_wire) vertex_delete_buffer(self.frozen_wire);
        if (self.reflect_frozen) vertex_delete_buffer(self.reflect_frozen);
        if (self.reflect_frozen_wire) vertex_delete_buffer(self.reflect_frozen_wire);
        if (self.frozen_data) buffer_delete(self.frozen_data);
        if (self.frozen_data_wire) buffer_delete(self.frozen_data_wire);
        if (self.reflect_frozen_data) buffer_delete(self.reflect_frozen_data);
        if (self.reflect_frozen_data_wire) buffer_delete(self.reflect_frozen_data_wire);
        self.frozen = undefined;
        self.frozen_wire = undefined;
        self.frozen_data = undefined;
        self.frozen_data_wire = undefined;
        self.reflect_frozen = undefined;
        self.reflect_frozen_wire = undefined;
        self.reflect_frozen_data = undefined;
        self.reflect_frozen_data_wire = undefined;
    };
    
    static Destroy = function() {
        for (var i = 0; i < array_length(self.batches); i++) {
            var data = self.batches[i];
            if (data.vertex) vertex_delete_buffer(data.vertex);
            if (data.wire) vertex_delete_buffer(data.wire);
            if (data.reflect_vertex) vertex_delete_buffer(data.reflect_vertex);
            if (data.reflect_wire) vertex_delete_buffer(data.reflect_wire);
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