/// @description smf_sample_create(modelIndex, animationIndex, type, time)
/// @param modelIndex
/// @param animationIndex
/// @param type
/// @param time
function smf_sample_create(argument0, argument1, argument2, argument3) {
    /*
    "Type" should be between 0 and 3, indicating one of the following:
        0: Looping animation with quadratic interpolation
        1: Non-looping animation with quadratic interpolation
        2: Looping animation with linear interpolation
        3: Non-looping animation with linear interpolation

    Script made by TheSnidr
    www.TheSnidr.com
    */
    var time, type, animationIndex, loop, quadratic, linear, bindPose, frameGrid, worldDQ, Qa, Qb, Qc, deltaWorldDQ, boneNum, frameNum, pDQ, cDQ, dWDQ, lr, ld, a, b, i, j, l, p, f, ma, mb, d, Q, bindDQ, localFrame, framePriority, returnSample, bonesInSample;
    var modelIndex = argument0;
    animationIndex = argument1;
    type = argument2;
    time = argument3;
    loop = (type == SMF_loop_linear or type == SMF_loop_quadratic);
    quadratic = (type == SMF_play_quadratic or type == SMF_loop_quadratic);
    linear = !quadratic;
    while time > 1{time--;}
    while time < 0{time++;}

    bindPose = modelIndex[| SMF_model.BindPose];
    var animationList = modelIndex[| SMF_model.Animation];

    //If the animation has been linearized
    var optimizedAnim = animationList[| 3 * animationIndex + 2];
    if is_array(optimizedAnim)
    {
        var steps = array_length(optimizedAnim) - 1;
        time = min(time, 0.99999) * steps;
        var pos = floor(time);
        return smf_sample_blend(optimizedAnim[pos], optimizedAnim[pos + 1], frac(time));
    }

    frameGrid = animationList[| 3 * animationIndex + 1];
    boneNum = ds_grid_height(frameGrid) - 1;
    frameNum = ds_grid_width(frameGrid);

    if bindPose == -1
    {
        show_debug_message("Script smf_sample_create failed: Trying to generate sample for nonexisting animation");
        return [animationIndex, modelIndex];
    }

    returnSample = -1;
    bonesInSample = 0;

    var ta, tb, tc;
    var a = 0, b = 0, c = 0, d = 0;
    if quadratic
    {
        for (i = 0; i < frameNum; i ++)
        {
            a = i;
            b = (a + 1) mod frameNum;
            c = (a + 2) mod frameNum;
            ta = frameGrid[# a, 0];
            tb = frameGrid[# b, 0];
            tc = frameGrid[# c, 0];
            if loop{
                if time > tc{
                    tb += (tb < ta);
                    tc += (tc < tb);}
                tb -= (tb > tc);
                ta -= (ta > tb);}
            else{
                if a == frameNum - 2{
                    c = frameNum - 1;
                    tc = 1;}
                if a == frameNum - 1{
                    if time > tc{
                        b = frameNum - 1;
                        tb = ta;
                        c = frameNum - 1;
                        tc = 1;}
                    else{
                        a = 0;
                        ta = 0;
                        b = 0;
                        tb = 0;}}}
            if time >= (ta + tb) / 2 and time < (tb + tc) / 2{
                if time < tb{if tb == ta{d = 0;}else{d = (time - (ta + tb) / 2) / (tb - ta);}}
                else{if tc == tb{d = 1;}else{d = 0.5 + (time - tb) / (tc - tb);}}
                break;}}

        worldDQ[0] = bindPose[| 0];
        for (i = 0; i < boneNum; i ++)
        {
            Qa = frameGrid[# a, i + 1];
            Qb = frameGrid[# b, i + 1];
            Qc = frameGrid[# c, i + 1];
            for (j = 0; j < 8; j ++)
            {
                //Interpolated local orientation
                Q[j] = smf_quadratic_bezier(Qa[j], Qb[j], Qc[j], d);
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
        
            //Delta world dual quaternion (dWDQ) = Child dual quaternion (cDQ) * Bind dual quaternion (bindDQ)
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
            else{lr = 1 / lr;}
            dWDQ[0] *= lr; dWDQ[1] *= lr; dWDQ[2] *= lr; dWDQ[3] *= lr;
            ld = dWDQ[0] * dWDQ[4] + dWDQ[1] * dWDQ[5] + dWDQ[2] * dWDQ[6] + dWDQ[3] * dWDQ[7];
            dWDQ[4] = (dWDQ[4] - dWDQ[0] * ld) * lr;
            dWDQ[5] = (dWDQ[5] - dWDQ[1] * ld) * lr;
            dWDQ[6] = (dWDQ[6] - dWDQ[2] * ld) * lr;
            dWDQ[7] = (dWDQ[7] - dWDQ[3] * ld) * lr;
    
            //Generate sample
            if bindDQ[9] //If this bone is attached to its parent
            {
                for (var j = 0; j < 8; j ++)
                {
                    returnSample[bonesInSample * 8 + j] = dWDQ[j];
                }
                bonesInSample++;
            }
            cDQ = -1;
        }
    }
    if linear
    {
        for (f = 0; f < frameNum; f ++){
            if frameGrid[# f, 0] >= time{
                b = f; break;}}
        if loop{a = (b - 1 + frameNum) mod frameNum;}
        else{
            if b == 0{b = frameNum - 1; a = b;} 
            else{a = max(b - 1, 0);}}
        if (a != b){
            mb = frameGrid[# b, 0]; mb += (time > mb);
            ma = frameGrid[# a, 0]; ma -= (ma > mb);
            if mb == ma{d = 0;}else{d = (time - ma) / (mb - ma);}}

        worldDQ[0] = bindPose[| 0];
        for (i = 0; i < boneNum; i ++)
        {
            Qa = frameGrid[# a, i + 1];
            Qb = frameGrid[# b, i + 1];
            for (j = 0; j < 8; j ++)
            {
                Q[j] = lerp(Qa[j], Qb[j], d);
            } 
            bindDQ = bindPose[| i];
            pDQ = worldDQ[bindDQ[8]];
        
            //Child dual quaternion (cDQ) = Parent dual quaternion (pDQ) * Frame dual quaternion (Q)
            cDQ = -1;
            cDQ[0] = pDQ[3] * Q[0] + pDQ[0] * Q[3] + pDQ[1] * Q[2] - pDQ[2] * Q[1];
            cDQ[1] = pDQ[3] * Q[1] + pDQ[1] * Q[3] + pDQ[2] * Q[0] - pDQ[0] * Q[2];
            cDQ[2] = pDQ[3] * Q[2] + pDQ[2] * Q[3] + pDQ[0] * Q[1] - pDQ[1] * Q[0];
            cDQ[3] = pDQ[3] * Q[3] - pDQ[0] * Q[0] - pDQ[1] * Q[1] - pDQ[2] * Q[2];
            cDQ[4] = pDQ[3] * Q[4] + pDQ[0] * Q[7] + pDQ[1] * Q[6] - pDQ[2] * Q[5] + pDQ[7] * Q[0] + pDQ[4] * Q[3] + pDQ[5] * Q[2] - pDQ[6] * Q[1];
            cDQ[5] = pDQ[3] * Q[5] + pDQ[1] * Q[7] + pDQ[2] * Q[4] - pDQ[0] * Q[6] + pDQ[7] * Q[1] + pDQ[5] * Q[3] + pDQ[6] * Q[0] - pDQ[4] * Q[2];
            cDQ[6] = pDQ[3] * Q[6] + pDQ[2] * Q[7] + pDQ[0] * Q[5] - pDQ[1] * Q[4] + pDQ[7] * Q[2] + pDQ[6] * Q[3] + pDQ[4] * Q[1] - pDQ[5] * Q[0];
            cDQ[7] = pDQ[3] * Q[7] - pDQ[0] * Q[4] - pDQ[1] * Q[5] - pDQ[2] * Q[6] + pDQ[7] * Q[3] - pDQ[4] * Q[0] - pDQ[5] * Q[1] - pDQ[6] * Q[2];
            worldDQ[i] = cDQ;
        
            //Delta world dual quaternion (dWDQ) = Child dual quaternion (cDQ) * Bind dual quaternion (bindDQ)
            dWDQ = -1;
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
            else{lr = 1 / lr;}
            dWDQ[0] *= lr; dWDQ[1] *= lr; dWDQ[2] *= lr; dWDQ[3] *= lr;
            ld = dWDQ[0] * dWDQ[4] + dWDQ[1] * dWDQ[5] + dWDQ[2] * dWDQ[6] + dWDQ[3] * dWDQ[7];
            dWDQ[4] = (dWDQ[4] - dWDQ[0] * ld) * lr;
            dWDQ[5] = (dWDQ[5] - dWDQ[1] * ld) * lr;
            dWDQ[6] = (dWDQ[6] - dWDQ[2] * ld) * lr;
            dWDQ[7] = (dWDQ[7] - dWDQ[3] * ld) * lr;
    
            //Generate sample
            if bindDQ[9] //If this bone is attached to its parent
            {
                for (var j = 0; j < 8; j ++)
                {
                    returnSample[bonesInSample * 8 + j] = dWDQ[j];
                }
                bonesInSample++;
            }
        }
    }
    returnSample[array_length(returnSample)] = animationIndex;
    returnSample[array_length(returnSample)] = modelIndex;
    return returnSample;


}
