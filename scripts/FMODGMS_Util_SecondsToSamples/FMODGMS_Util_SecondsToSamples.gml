/// @param seconds
/// @param samplingRate

var seconds = argument0;
var rate = argument1;

// Converts time measured in seconds to samples. Can be used in conjuction with FMODGMS_Snd_Set_LoopPoints
// for precise loop point control.

return seconds * rate;