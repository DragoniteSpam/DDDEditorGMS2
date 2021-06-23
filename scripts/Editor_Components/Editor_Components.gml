#macro BulletUserIDCollection global.__bullet_user_id_collection

BulletUserIDCollection = new (function() constructor {
    static current = 0;
    static lookup = { };
    
    self.Add = function(component) {
        component.id = current++;
        lookup[$ string(component.id)] = component;
        return component.id;
    };
    
    self.Get = function(id) {
        return lookup[$ string(id)];
    };
    
    self.Remove = function(component) {
        variable_struct_remove(lookup, string(component.id));
    };
})();

function EditorComponent(parent, object) constructor {
    self.parent = parent;
    self.object = object;
    self.current_mask = 0;
    self.id = BulletUserIDCollection.Add(self);
    self.is_component = true;
    
    c_object_set_userid(self.object, self.id);
    c_world_add_object(self.object);
    
    self.on_mouse_down = null;
    self.on_mouse_up = null;
    self.on_mouse_stay = null;
    self.on_mouse_hover = null;
    
    static Destroy = function() {
        BulletUserIDCollection.Remove(self);
        if (self.object) {
            // it turns out removing these things is REALLY SLOW, so instead we'll pool
            // them to be removed in an orderly manner (and nullify their masks so they
            // don't accidentally trigger interactions if you click on them)
            c_object_set_mask(self.object, 0, 0);
            c_object_set_userid(self.object, 0);
            ds_queue_enqueue(Stuff.c_object_cache, self.object);
        }
    };
}

function EditorComponentAxis(parent, object, axis) : EditorComponent(parent, object) constructor {
    self.axis = axis;
    
    self.on_mouse_down = component_axis_down;
    self.on_mouse_stay = component_axis_stay;
    self.on_mouse_up = component_axis_up;
    self.on_mouse_hover = component_axis_hover;
}

enum CollisionSpecialValues {
    NONE,
    TRANSLATE_X,
    TRANSLATE_Y,
    TRANSLATE_Z,
}