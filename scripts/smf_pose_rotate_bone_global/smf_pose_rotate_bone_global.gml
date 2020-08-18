/// @description smf_pose_rotate_bone_global(pose, boneIndex, ax, ay, az, angle)
/// @param pose
/// @param boneIndex
/// @param ax
/// @param ay
/// @param az
/// @param angle
function smf_pose_rotate_bone_global(argument0, argument1, argument2, argument3, argument4, argument5) {
	//This script can be optimized a lot
	var frame, bone, ax, ay, az, angle, modelIndex, bindPose, i, R, S, l, bind, animationIndex;
	frame = argument0;
	bone = argument1;
	ax = argument2;
	ay = argument3;
	az = argument4;
	angle = argument5;
	modelIndex = frame[array_length_1d(frame) - 1];
	bindPose = modelIndex[| SMF_model.BindPose];

	bind = bindPose[| bone];
	pBind = bindPose[| bind[8]];

	i = 8;
	while i--{R[i] = frame[bone * 8 + i];}

	rotationDQ = smf_dualquat_create(angle, ax, ay, az, 0, 0, 0);

	worldDQ = smf_dualquat_multiply(pBind, R);
	T = smf_dualquat_get_translation(worldDQ);
	pT = smf_dualquat_get_translation(pBind);
	worldDQ = smf_dualquat_set_translation(worldDQ, T[0] - pT[0], T[1] - pT[1], T[2] - pT[2]);
	worldDQ = smf_dualquat_multiply(rotationDQ, worldDQ);
	T = smf_dualquat_get_translation(worldDQ);
	worldDQ = smf_dualquat_set_translation(worldDQ, T[0] + pT[0], T[1] + pT[1], T[2] + pT[2]);
	worldDQ = smf_dualquat_normalize(worldDQ);
	Q = smf_dualquat_multiply(smf_dualquat_get_conjugate(pBind), worldDQ);

	i = 8;
	while i--{frame[@ bone * 8 + i] = Q[i];}


}
