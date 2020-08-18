/// @param samples
/// @param samplingRate
function FMODGMS_Util_SamplesToSeconds(argument0, argument1) {

	var samples = argument0;
	var rate = argument1;

	// Converts time measured in samples to seconds.

	return samples * rate;


}
