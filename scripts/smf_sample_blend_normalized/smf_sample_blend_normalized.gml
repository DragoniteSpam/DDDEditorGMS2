/// @description smf_sample_blend(sample1, sample2, amount)
/// @param sample1
/// @param sample2
/// @param amount
function smf_sample_blend_normalized(argument0, argument1, argument2) {
	/*
	Linearly blend between two samples.
	Modifying samples directly like this can be a bit risky, as changes to one bone don't
	affect bones further down the hierarchy. The end points will be correct, but too large
	movements may result in bones being "detached" in the process. Still, it works well
	enough for most situations.

	Script made by TheSnidr
	www.TheSnidr.com
	*/
	var sample1, sample2, t1, t2, num, i, returnSample;
	sample1 = argument0;
	sample2 = argument1;
	t2 = argument2;
	t1 = 1 - t2;
	num = array_length(sample1);
	returnSample = -1;
	var Q, ii;
	for (i = 0; i < num div 8; i ++)
	{
	    ii = i*8;
	    Q = -1;
	    for (var j = 0; j < 8; j ++){
	        Q[j] = sample1[ii+j] * t1 + sample2[ii+j] * t2;}
	    Q = smf_dualquat_normalize(Q);
	    for (var j = 0; j < 8; j ++){
	        returnSample[ii+j] = Q[j];}
	}
	return returnSample;


}
