/// @param name
/// @param internal-name

var name = (argument_count > 0) ? argument[0] : "";
var internal_name = (argument_count > 1) ? argument[1] : "";

var animation = instantiate(DataAnimation);
if (argument_count > 0) {
    animation.name = name;
}
if (argument_count > 1) {
    internal_name_set(animation, internal_name);
}
instance_deactivate_object(animation);
ds_list_add(Stuff.all_animations, animation);

return animation;