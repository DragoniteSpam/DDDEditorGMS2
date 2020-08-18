/// @param beats
/// @param bpm
/// @param samplingRate
function FMODGMS_Util_BeatsToSamples(argument0, argument1, argument2) {

	var beats = argument0;
	var bpm = argument1;
	var rate = argument2;

	// Converts time measured in beats to samples, assuming a constant BPM. Can be used in conjuction with FMODGMS_Snd_Set_LoopPoints
	// for precise loop point control.

	return rate * beats / bpm * 60;


}
