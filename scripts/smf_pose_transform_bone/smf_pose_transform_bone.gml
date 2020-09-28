/// @description smf_pose_transform_bone(pose, boneIndex, transformDQ[8])
/// @param pose
/// @param boneIndex
/// @param transformDQ[8]
function smf_pose_transform_bone(argument0, argument1, argument2) {
    //This script can be optimized a lot
    var pose, bone, transformDQ, bindPose, animationIndex, modelIndex, bind, pBind, i, R, T, pT, Q, worldDQ;
    pose = argument0;
    bone = argument1;
    transformDQ = argument2;
    modelIndex = pose[array_length(pose) - 1];
    bindPose = modelIndex[| SMF_model.BindPose];

    bind = bindPose[| bone];
    pBind = bindPose[| bind[8]];

    i = 8;
    while i--{R[i] = pose[bone * 8 + i];}

    worldDQ = smf_dualquat_multiply(pBind, R);
    T = smf_dualquat_get_translation(worldDQ);
    pT = smf_dualquat_get_translation(pBind);
    worldDQ = smf_dualquat_set_translation(worldDQ, T[0] - pT[0], T[1] - pT[1], T[2] - pT[2]);
    worldDQ = smf_dualquat_multiply(transformDQ, worldDQ);
    T = smf_dualquat_get_translation(worldDQ);
    worldDQ = smf_dualquat_set_translation(worldDQ, T[0] + pT[0], T[1] + pT[1], T[2] + pT[2]);
    worldDQ = smf_dualquat_normalize(worldDQ);
    Q = smf_dualquat_multiply(smf_dualquat_get_conjugate(pBind), worldDQ);

    i = 8;
    while i--{pose[@ bone * 8 + i] = Q[i];}


}
