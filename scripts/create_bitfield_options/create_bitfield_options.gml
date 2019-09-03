/// @param UIBitField
/// @param data[]

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

// @todo gml update lightweight objects
var bitfield = argument[0];
var things = argument[1];

for (var i = 0; i < array_length_1d(things); i++) {
    var n = ds_list_size(bitfield.contents);
    var data = things[i];
	var xx = (n == 0) ? bitfield.width : ds_list_top(bitfield.contents).x + ds_list_top(bitfield.contents).width;
    
    var option = instance_create_depth(xx, bitfield.height / 2 - data[7], 0, UIBitFieldOption);
    option.value = data[0];
    option.render = data[1];
    option.onvaluechange = data[2];
    option.text = data[3];
    option.sprite_index = data[4];
    option.image_index = data[5];
    option.width = data[6] * 2;
    option.height = data[7] * 2;
    
    option.root = bitfield;
    option.height = bitfield.height;
    
    ds_list_add(bitfield.contents, option);
}