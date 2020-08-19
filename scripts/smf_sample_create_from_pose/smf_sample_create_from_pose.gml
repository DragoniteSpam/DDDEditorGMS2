/// @description smf_sample_create_from_pose(pose)
/// @param pose
function smf_sample_create_from_pose(argument0) {
    /*

    Script made by TheSnidr
    www.TheSnidr.com
    */
    var pose, time, type, animationIndex, bonesInSample, loop, quadratic, linear, bindPose, frameGrid, worldDQ, Qa, Qb, Qc, deltaWorldDQ, boneNum, frameNum, pDQ, cDQ, dWDQ, lr, ld, a, b, i, j, l, p, f, ma, mb, d, Q, bindDQ, localFrame, framePriority, returnSample;
    pose = argument0;
    animationIndex = pose[array_length(pose) - 2];
    var modelIndex = pose[array_length(pose) - 1];

    bindPose = modelIndex[| SMF_model.BindPose];
    boneNum = ds_list_size(bindPose);
    bonesInSample = 0;

    worldDQ[0] = bindPose[| 0];
    for (i = 0; i < boneNum; i ++)
    {
        for (j = 0; j < 8; j ++)
        {
            //Interpolated local orientation
            Q[j] = pose[i * 8 + j];
        }
        bindDQ = bindPose[| i];
        pDQ = worldDQ[bindDQ[8]];
        
        //Child dual quaternion (cDQ) = Parent dual quaternion (pDQ) * Frame dual quaternion (Q)
        cDQ[0] = pDQ[3] * Q[0] + pDQ[0] * Q[3] + pDQ[1] * Q[2] - pDQ[2] * Q[1];
        cDQ[1] = pDQ[3] * Q[1] + pDQ[1] * Q[3] + pDQ[2] * Q[0] - pDQ[0] * Q[2];
        cDQ[2] = pDQ[3] * Q[2] + pDQ[2] * Q[3] + pDQ[0] * Q[1] - pDQ[1] * Q[0];
        cDQ[3] = pDQ[3] * Q[3] - pDQ[0] * Q[0] - pDQ[1] * Q[1] - pDQ[2] * Q[2];
        cDQ[4] = pDQ[3] * Q[4] + pDQ[0] * Q[7] + pDQ[1] * Q[6] - pDQ[2] * Q[5] + pDQ[7] * Q[0] + pDQ[4] * Q[3] + pDQ[5] * Q[2] - pDQ[6] * Q[1];
        cDQ[5] = pDQ[3] * Q[5] + pDQ[1] * Q[7] + pDQ[2] * Q[4] - pDQ[0] * Q[6] + pDQ[7] * Q[1] + pDQ[5] * Q[3] + pDQ[6] * Q[0] - pDQ[4] * Q[2];
        cDQ[6] = pDQ[3] * Q[6] + pDQ[2] * Q[7] + pDQ[0] * Q[5] - pDQ[1] * Q[4] + pDQ[7] * Q[2] + pDQ[6] * Q[3] + pDQ[4] * Q[1] - pDQ[5] * Q[0];
        cDQ[7] = pDQ[3] * Q[7] - pDQ[0] * Q[4] - pDQ[1] * Q[5] - pDQ[2] * Q[6] + pDQ[7] * Q[3] - pDQ[4] * Q[0] - pDQ[5] * Q[1] - pDQ[6] * Q[2];
        worldDQ[i] = cDQ;
        
        //Delta world dual quaternion (dWDQ) = Child dual quaternion (cDQ) * conjugate of Bind dual quaternion (bindDQ)
        dWDQ[0] = - cDQ[3] * bindDQ[0] + cDQ[0] * bindDQ[3] - cDQ[1] * bindDQ[2] + cDQ[2] * bindDQ[1];
        dWDQ[1] = - cDQ[3] * bindDQ[1] + cDQ[1] * bindDQ[3] - cDQ[2] * bindDQ[0] + cDQ[0] * bindDQ[2];
        dWDQ[2] = - cDQ[3] * bindDQ[2] + cDQ[2] * bindDQ[3] - cDQ[0] * bindDQ[1] + cDQ[1] * bindDQ[0];
        dWDQ[3] = cDQ[3] * bindDQ[3] + cDQ[0] * bindDQ[0] + cDQ[1] * bindDQ[1] + cDQ[2] * bindDQ[2];
        dWDQ[4] = - cDQ[3] * bindDQ[4] + cDQ[0] * bindDQ[7] - cDQ[1] * bindDQ[6] + cDQ[2] * bindDQ[5] - cDQ[7] * bindDQ[0] + cDQ[4] * bindDQ[3] - cDQ[5] * bindDQ[2] + cDQ[6] * bindDQ[1];
        dWDQ[5] = - cDQ[3] * bindDQ[5] + cDQ[1] * bindDQ[7] - cDQ[2] * bindDQ[4] + cDQ[0] * bindDQ[6] - cDQ[7] * bindDQ[1] + cDQ[5] * bindDQ[3] - cDQ[6] * bindDQ[0] + cDQ[4] * bindDQ[2];
        dWDQ[6] = - cDQ[3] * bindDQ[6] + cDQ[2] * bindDQ[7] - cDQ[0] * bindDQ[5] + cDQ[1] * bindDQ[4] - cDQ[7] * bindDQ[2] + cDQ[6] * bindDQ[3] - cDQ[4] * bindDQ[1] + cDQ[5] * bindDQ[0];
        dWDQ[7] = cDQ[3] * bindDQ[7] + cDQ[0] * bindDQ[4] + cDQ[1] * bindDQ[5] + cDQ[2] * bindDQ[6] +  cDQ[7] * bindDQ[3] + cDQ[4] * bindDQ[0] + cDQ[5] * bindDQ[1] + cDQ[6] * bindDQ[2];
        
        //Normalize Delta world dual quaternion
        lr = sqrt(sqr(dWDQ[0]) + sqr(dWDQ[1]) + sqr(dWDQ[2]) + sqr(dWDQ[3]));
        if lr < 0.00001{
            lr = 1;
            dWDQ[0] = 1;
            dWDQ[1] = 0;
            dWDQ[2] = 0;
            dWDQ[3] = 0;}
        else{lr = 1 / lr;
        dWDQ[0] *= lr; dWDQ[1] *= lr; dWDQ[2] *= lr; dWDQ[3] *= lr;}
        ld = dWDQ[0] * dWDQ[4] + dWDQ[1] * dWDQ[5] + dWDQ[2] * dWDQ[6] + dWDQ[3] * dWDQ[7];
        dWDQ[4] = (dWDQ[4] - dWDQ[0] * ld) * lr;
        dWDQ[5] = (dWDQ[5] - dWDQ[1] * ld) * lr;
        dWDQ[6] = (dWDQ[6] - dWDQ[2] * ld) * lr;
        dWDQ[7] = (dWDQ[7] - dWDQ[3] * ld) * lr;
    
        //Generate sample
        if bindDQ[9]
        {
            for (var j = 0; j < 8; j ++){returnSample[bonesInSample * 8 + j] = dWDQ[j];}
            bonesInSample++;
        }
        cDQ = -1;
    }
    returnSample[array_length(returnSample)] = animationIndex;
    returnSample[array_length(returnSample)] = modelIndex;
    return returnSample;


}
