/// @param UIBitField
/// @param data[]

// see create_bitfield_options for how the data is arranged

var bitfield = argument[0];
var things = argument[1];

for (var i = 0; i < array_length_1d(things); i++) {
    var n = ds_list_size(bitfield.contents);
    var data = things[i];
	var yy = (n == 0) ? bitfield.height : ds_list_top(bitfield.contents).y + ds_list_top(bitfield.contents).height;
    
    var option = instance_create_depth(0, yy, 0, UIBitFieldOption);
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