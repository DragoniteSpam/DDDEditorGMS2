/// @param test
/// @param root
function menu_is_ancestor(argument0, argument1) {

    var test = argument0;
    var root = argument1;

    if (!test || !root) {
        return false;
    }

    if (test == root) {
        return true;
    }

    return menu_is_ancestor(test.root, root);


}
