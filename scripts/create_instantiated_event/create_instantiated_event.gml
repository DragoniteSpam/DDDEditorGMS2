/// @param name

with (instantiate(DataInstantiatedEvent)) {
    name = argument[0];
    
    instance_deactivate_object(id);
    return id;
}