/// @description  DataInstantiatedEvent create_instantiated_event(name);
/// @param name

with (instance_create(0, 0, DataInstantiatedEvent)){
    name=argument[0];
    
    instance_deactivate_object(id);
    return id;
}
