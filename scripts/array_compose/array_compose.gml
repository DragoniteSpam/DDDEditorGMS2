/// @description  array_compose(argument0 .. argument1);
/// @param argument0 .. argument1

// sigh
//return array_copy(array, 0, argument, 0, argument_count);

var array=array_create(argument_count);

for (var i=0; i<argument_count; i++){
    array[i]=argument[i];
}

return array;
