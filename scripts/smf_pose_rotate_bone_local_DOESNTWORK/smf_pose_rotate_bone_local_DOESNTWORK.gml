/// @description smf_frame_rotate_bone(frame, boneIndex, ax, ay, az, angle)
/// @param frame
/// @param boneIndex
/// @param ax
/// @param ay
/// @param az
/// @param angle
/*
var frame, bone, ax, ay, az, angle, bindPose, i, R, S, l, bind, animationIndex;
frame = argument0;
bone = argument1;
ax = argument2;
ay = argument3;
az = argument4;
angle = argument5;
animationIndex = frame[array_length_1d(frame) - 1];

bind = ds_list_find_value(SMF_bindList[| animationIndex], bone);
pBind = ds_list_find_value(SMF_bindList[| animationIndex], bind[8]);

i = 8;
while i--{R[i] = frame[bone * 8 + i];}

localBindDQ = smf_dualquat_multiply(smf_dualquat_get_conjugate(pBind), bind);

rotationDQ = smf_dualquat_create(angle, ax, ay, az, 0, 0, 0);

deltaDQ = smf_dualquat_multiply(smf_dualquat_get_conjugate(localBindDQ), R);
R = smf_dualquat_multiply(rotationDQ, R);
Q = smf_dualquat_multiply(localBindDQ, R);



i = 8;
while i--{frame[@ bone * 8 + i] = Q[i];}