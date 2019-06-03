/// @description void create_bitfield_options(UIBitField, data0, .. datan);
/// @param UIBitField
/// @param data0
/// @param .. datan
/*
 * data is an array with the following data:
 *
 * 0. value
 * 1. render
 * 2. onvaluechange
 * 3. text
 * 4. sprite
 * 5. image index
 * 6. half width
 * 7. half height
 *
 * feel free to use create_bitfield_option_data but you can also just
 * compose the array yourself and itll work
 */

for (var i=1; i<argument_count; i++) {
    var n=ds_list_size(argument[0].contents);
    var data=argument[i];
    if (n==0) {
        var xx=argument[0].width;
    } else {
        var xx=ds_list_top(argument[0].contents).x+ds_list_top(argument[0].contents).width;
    }
    var option=instance_create_depth(xx, argument[0].height/2-data[7], 0, UIBitFieldOption);
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
