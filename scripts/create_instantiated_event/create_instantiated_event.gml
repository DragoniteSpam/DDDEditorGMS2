/// @param name
function create_instantiated_event() {

	with (instance_create_depth(0, 0, 0, DataInstantiatedEvent)) {
	    name = argument[0];
    
	    instance_deactivate_object(id);
	    return id;
	}


}
