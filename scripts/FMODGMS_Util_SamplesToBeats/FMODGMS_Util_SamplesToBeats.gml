/// @param samples
/// @param bpm
/// @param samplingRate

var samples = argument0;
var bpm = argument1;
var rate = argument2;

// Converts time measured in samples to beats, assuming a constant BPM.

return samples / bpm * rate / 60;