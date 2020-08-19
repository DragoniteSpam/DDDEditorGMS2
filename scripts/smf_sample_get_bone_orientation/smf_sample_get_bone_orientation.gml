/// @description smf_sample_get_bone_orientation(sample, boneIndex)
/// @param sample
/// @param boneIndex
function smf_sample_get_bone_orientation(argument0, argument1) {
	/*
	Returns the dual quaternion of the given bone
	*/
	var bindPose, modelIndex, bone, sample, R, S, Q, i;
	sample = argument0;
	modelIndex = sample[array_length(sample) - 1];
	bone = ds_list_find_value(modelIndex[| SMF_model.BindSampleMappingList], argument1);
	bindPose = modelIndex[| SMF_model.BindPose];
	S = bindPose[| argument1];
	i = 8;
	while i--{R[i] = sample[bone * 8 + i];}
	Q[0] = R[3] * S[0] + R[0] * S[3] + R[1] * S[2] - R[2] * S[1];
	Q[1] = R[3] * S[1] + R[1] * S[3] + R[2] * S[0] - R[0] * S[2];
	Q[2] = R[3] * S[2] + R[2] * S[3] + R[0] * S[1] - R[1] * S[0];
	Q[3] = R[3] * S[3] - R[0] * S[0] - R[1] * S[1] - R[2] * S[2];
	Q[4] = R[3] * S[4] + R[0] * S[7] + R[1] * S[6] - R[2] * S[5] + R[7] * S[0] + R[4] * S[3] + R[5] * S[2] - R[6] * S[1];
	Q[5] = R[3] * S[5] + R[1] * S[7] + R[2] * S[4] - R[0] * S[6] + R[7] * S[1] + R[5] * S[3] + R[6] * S[0] - R[4] * S[2];
	Q[6] = R[3] * S[6] + R[2] * S[7] + R[0] * S[5] - R[1] * S[4] + R[7] * S[2] + R[6] * S[3] + R[4] * S[1] - R[5] * S[0];
	Q[7] = R[3] * S[7] - R[0] * S[4] - R[1] * S[5] - R[2] * S[6] + R[7] * S[3] - R[4] * S[0] - R[5] * S[1] - R[6] * S[2];
	return smf_dualquat_normalize(Q);


}
