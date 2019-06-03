/// @description boolean menu_is_ancestor(test, root);
/// @param test
/// @param root

// check this first because if the root turns out to be noone
// it'll always return true because everything's super root is
// noone.

if (argument0==noone) {
    return false;
}

if (argument0==argument1) {
    return true;
}

return menu_is_ancestor(argument0.root, argument1);
