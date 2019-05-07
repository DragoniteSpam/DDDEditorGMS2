/// @description  node ds_tree_node(data, [exists?]);
/// @param data
/// @param  [exists?]

var exists=true;
switch (argument_count){
    case 2:
        exists=argument[1];
        break;
}

return array_compose(exists, argument[0], noone, noone);
