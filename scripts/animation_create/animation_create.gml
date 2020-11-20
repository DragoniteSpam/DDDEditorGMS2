function animation_create(name, internal_name) {
    if (name == undefined) name = "";
    if (internal_name == undefined) internal_name = "";
    
    var animation = instance_create_depth(0, 0, 0, DataAnimation);
    if (name != "") animation.name = name;
    if (internal_name != "") internal_name_set(animation, internal_name);
    instance_deactivate_object(animation);
    ds_list_add(Stuff.all_animations, animation);
    
    return animation;
}