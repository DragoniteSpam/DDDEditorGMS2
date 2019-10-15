/// @description smf_animation_linearize(modelIndex, animIndex, type, steps)
/// @param modelIndex
/// @param animIndex
/// @param animType
/// @param steps
/*
This cuts the animation into even steps.
Interpolating between them is now incredibly fast, as the game won't have to do any 
dual quaternion operations ingame!
*/
var modelIndex = argument0;
var animIndex = argument1;
var animType = argument2;
var steps = argument3;
var animationList = modelIndex[| SMF_model.Animation];
animationList[| 3 * animIndex + 2] = -1;
var animArray = [];
for (var i = 0; i <= steps; i ++)
{
	animArray[i] = smf_sample_create(modelIndex, animIndex, animType, i / steps);
}
animationList[| 3 * animIndex + 2] = animArray;