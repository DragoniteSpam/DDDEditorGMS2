/// @description  void create_bitfield_options_vertical(UIBitField, data0, .. datan);
/// @param UIBitField
/// @param  data0
/// @param  .. datan
/*
 * see create_bitfield_options for how the data is arranged
 */

for (var i=1; i<argument_count; i++){
    var n=ds_list_size(argument[0].contents);
    var data=argument[i];
    if (n==0){
        var yy=argument[0].height;
    } else {
        var yy=ds_list_top(argument[0].contents).y+ds_list_top(argument[0].contents).height;
    }
    var option=instance_create_depth(0, yy, 0, UIBitFieldOption);
    option.value=data[0];
    option.render=data[1];
    option.onvaluechange=data[2];
    option.text=data[3];
    option.sprite_index=data[4];
    option.image_index=data[5];
    option.width=data[6]*2;
    option.height=data[7]*2;
    
    option.root=argument[0];
    option.height=argument[0].height;
    
    ds_list_add(argument[0].contents, option);
}
