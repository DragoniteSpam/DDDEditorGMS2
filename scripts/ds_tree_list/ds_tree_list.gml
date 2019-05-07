/// @description  void ds_tree_list(tree, list);
/// @param tree
/// @param  list

if (is_array(argument0)){
    if (argument0[@ DSTree.EXISTS]){
        ds_tree_list(argument0[@ DSTree.LEFT], argument1);
        ds_list_add(argument1, argument0[@ DSTree.DATA]);
        ds_tree_list(argument0[@ DSTree.RIGHT], argument1);
    }
}
