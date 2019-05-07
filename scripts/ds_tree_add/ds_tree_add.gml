/// @description  node ds_tree_add(tree, data);
/// @param tree
/// @param  data
// this will break if you try to mix numbers and strings

enum DSTree {
    EXISTS,
    DATA,
    LEFT,
    RIGHT
}

if (!argument0[@ DSTree.EXISTS]){
    argument0[@ DSTree.DATA]=argument1;
    return argument0;
}

if (argument1==argument0[@ DSTree.DATA]){
    return noone;
}

if (argument1>argument0[@ DSTree.DATA]){
    if (is_array(argument0[@ DSTree.RIGHT])){
        return ds_tree_add(argument0[@ DSTree.RIGHT], argument1);
    } else {
        argument0[@ DSTree.RIGHT]=ds_tree_node(argument1);
    }
    return argument0[@ DSTree.RIGHT];
}

if (argument1<argument0[@ DSTree.DATA]){
    if (is_array(argument0[@ DSTree.LEFT])){
        return ds_tree_add(argument0[@ DSTree.LEFT], argument1);
    } else {
        argument0[@ DSTree.LEFT]=ds_tree_node(argument1);
    }
    return argument0[@ DSTree.LEFT];
}
