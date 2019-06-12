/// @param UIRadioArray
/// @param string0
/// @param ..stringn

for (var i = 1; i < argument_count; i++) {
    var n = ds_list_size(argument[0].contents);
    var option = instance_create_depth(0, argument[0].height * (1 + n), 0, UITextRadio);
    option.text = argument[i];
    option.root = argument[0];
    option.height = argument[0].height;
    option.value = n;
    
    ds_list_add(argument[0].contents, option);
}
