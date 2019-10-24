/// @param UIButton

var button = argument0;

if (ds_list_size(Stuff.all_game_constants) < 0xffff) {
    var data = instance_create_depth(0, 0, 0, DataConstant);
    data.name = "Constant " + string(ds_list_size(Stuff.all_game_constants));
    instance_deactivate_object(data);
    
    ds_list_add(Stuff.all_game_constants, data);
}