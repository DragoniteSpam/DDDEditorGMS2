function animation_create(name, internal_name) {
    if (name == undefined) name = "";
    if (internal_name == undefined) internal_name = "";
    
    var animation = new DataAnimation(name != "" ? name : "Animation");
    if (internal_name != "") internal_name_set(animation, internal_name);
    instance_deactivate_object(animation);
    ds_list_add(Game.animations, animation);
    
    return animation;
}