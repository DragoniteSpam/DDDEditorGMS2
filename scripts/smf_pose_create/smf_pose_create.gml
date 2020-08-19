/// @description smf_pose_create(modelIndex, animationIndex, type, time)
/// @param modelIndex
/// @param animationIndex
/// @param type
/// @param time
function smf_pose_create(argument0, argument1, argument2, argument3) {
	/*

	Script made by TheSnidr
	www.TheSnidr.com
	*/
	var time, type, animationIndex, loop, quadratic, linear, bindPose, frameGrid, worldDQ, Qa, Qb, Qc, deltaWorldDQ, boneNum, frameNum, pDQ, cDQ, dWDQ, lr, ld, a, b, i, j, l, p, f, ma, mb, d, Q, bindDQ, localFrame, framePriority, returnPose;
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

	frameGrid = animationList[| 3 * animationIndex + 1];
	boneNum = ds_grid_height(frameGrid) - 1;
	frameNum = ds_grid_width(frameGrid);


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

	    for (i = 0; i < boneNum; i ++)
	    {
	        Qa = frameGrid[# a, i + 1];
	        Qb = frameGrid[# b, i + 1];
	        Qc = frameGrid[# c, i + 1];
	        for (j = 0; j < 8; j ++)
	        {
	            returnPose[i * 8 + j] = sqr(1 - d) * (Qa[j] + Qb[j]) / 2 + 2 * d * (1 - d) * Qb[j] + sqr(d) * (Qc[j] + Qb[j]) / 2;
	        }
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

	    for (i = 0; i < boneNum; i ++)
	    {
	        Qa = frameGrid[# a, i + 1];
	        Qb = frameGrid[# b, i + 1];
	        for (j = 0; j < 8; j ++)
	        {
	            returnPose[i * 8 + j] = lerp(Qa[j], Qb[j], d);
	        }
	    }
	}
	returnPose[array_length(returnPose)] = animationIndex;
	returnPose[array_length(returnPose)] = modelIndex;
	return returnPose;


}
