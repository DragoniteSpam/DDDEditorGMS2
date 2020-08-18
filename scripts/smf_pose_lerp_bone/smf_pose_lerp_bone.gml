/// @description smf_pose_lerp_bone(targetPose, sourcePose, boneIndex, amount)
/// @param targetPose
/// @param sourcePose
/// @param boneIndex
/// @param amount
function smf_pose_lerp_bone(argument0, argument1, argument2, argument3) {
	var targetPose, sourcePose, bone, amount, i, j;
	targetPose = argument0;
	sourcePose = argument1;
	bone = argument2;
	amount = argument3;
	i = 8;
	j = bone * 8;
	while i--{targetPose[@ j + i] = lerp(targetPose[j + i], sourcePose[j + i], amount);}


}
