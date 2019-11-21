/// @description smf_sample_blend(sample1, sample2, amount)
/// @param sample1
/// @param sample2
/// @param amount
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
num = array_length_1d(sample1);
returnSample = -1;
for (i = 0; i < num - 2; i ++)
{
    returnSample[i] = sample1[i] * t1 + sample2[i] * t2;
}
returnSample[num - 2] = sample1[num - 2];
returnSample[num - 1] = sample1[num - 1];
return returnSample;