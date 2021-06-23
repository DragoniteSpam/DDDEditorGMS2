function EditorComponent() constructor {
    self.object = undefined;
    self.parent = undefined;
    self.current_mask = 0;
    
    self.on_mouse_down = null;
    self.on_mouse_up = null;
    self.on_mouse_stay = null;
    self.on_mouse_hover = null;
    
    static Destroy = function() {
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

function EditorComponentAxis() : EditorComponent() constructor {
    self.object = undefined;
    self.axis = CollisionSpecialValues.NONE;
    self.parent = undefined;
    self.name = "";
    
    self.on_mouse_down = component_axis_down;
    self.on_mouse_stay = component_axis_stay;
    self.on_mouse_up = component_axis_up;
    self.on_mouse_hover = component_axis_hover;
}