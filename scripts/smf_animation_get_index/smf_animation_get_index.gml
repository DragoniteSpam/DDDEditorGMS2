/// @description smf_animation_get_index(modelIndex, name)
/// @param modelIndex
/// @param name
function smf_animation_get_index(argument0, argument1) {
    //Returns -1 if the animation does not exist
    var modelIndex = argument0;
    var animationList = modelIndex[| SMF_model.Animation];
    var ind = ds_list_find_index(animationList, argument1);
    if ind >= 0
    {
        return ind / 3;
    }
    else
    {
        return -1;
    }


}
