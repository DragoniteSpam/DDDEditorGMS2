/// @param UIThing

var thing = argument0;

if (ds_list_size(Stuff.all_animations) < 1000) {
    var animation = instantiate(DataAnimation);
    var n = string(ds_list_size(Stuff.all_animations));;
    animation.name = "Animation" + n;
    internal_name_set(animation, "Anim" + n);
    instance_deactivate_object(animation);
    ui_list_deselect(thing.root.el_master);
    ds_list_add(Stuff.all_animations, animation);
} else {
    dialog_create_notice(thing.root, "Please don't try to create more than a million animations. Bad things will happen. In fact, they probably happened long before this. Why did you even let it get this far, anyway?", "Hey!");
}