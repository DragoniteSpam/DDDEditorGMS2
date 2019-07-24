/// @param UIRadioArray
/// @param string0
/// @param [..stringn]

var array = argument[0];

for (var i = 1; i < argument_count; i++) {
    var n = ds_list_size(array.contents);
    var option = instance_create_depth(0, array.height * (1 + n), 0, UITextRadio);
    option.text = argument[i];
    option.root = array;
    option.height = array.height;
    option.value = n;
    option.check_view = array.check_view;
    
    ds_list_add(array.contents, option);
}