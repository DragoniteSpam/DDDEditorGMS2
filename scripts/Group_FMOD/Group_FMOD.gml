function FMODGMS_Effect_TypeToString(sound_type_index) {
	//NB: Not all possible effects are covered
	switch (sound_type_index) {
	    case FMODGMS_EFFECT_CHORUS: return "Chorus";
	    case FMODGMS_EFFECT_DISTORTION: return "Distortion";
	    case FMODGMS_EFFECT_ECHO: return "Echo";
	    case FMODGMS_EFFECT_FLANGE: return "Flange";
	    case FMODGMS_EFFECT_HIGHPASS: return "Highpass";
	    case FMODGMS_EFFECT_LOWPASS: return "Lowpass";
	    case FMODGMS_EFFECT_REVERB: return "Reverb";
	    case FMODGMS_EFFECT_TREMOLO: return "Tremolo";
	    case -1: return "None";
	    default: return "Other";
	}
}

function FMODGMS_Snd_TagDataTypeToString(tag_datatype_index) {
	switch (tag_datatype_index) {
	    case FMODGMS_TAGDATATYPE_BINARY: return "Binary";
	    case FMODGMS_TAGDATATYPE_INT: return "Int";
	    case FMODGMS_TAGDATATYPE_FLOAT: return "Float";
	    case FMODGMS_TAGDATATYPE_STRING: return "String";
	    case FMODGMS_TAGDATATYPE_STRING_UTF16: return "String UTF-16";
	    case FMODGMS_TAGDATATYPE_STRING_UTF16BE: return "String UTF-16BE";
	    case FMODGMS_TAGDATATYPE_STRING_UTF8: return "String UTF-8";
	    case FMODGMS_TAGDATATYPE_CDTOC: return "CD Table of Contents";
	    case FMODGMS_TAGDATATYPE_MAX: return "Max Number of Data Types";
	    default: return "Unknown Data Type";
	}
}

function FMODGMS_Snd_TagTypeToString(tag_datatype_index) {
	switch (tag_datatype_index) {
    	case FMODGMS_TAGTYPE_ID3V1: return "ID3v1 tag";
    	case FMODGMS_TAGTYPE_ID3V2: return "ID3v2 tag";
    	case FMODGMS_TAGTYPE_VORBISCOMMENT: return "Vorbis comment";
    	case FMODGMS_TAGTYPE_SHOUTCAST: return "Shoutcast tag";
    	case FMODGMS_TAGTYPE_ICECAST: return "Icecast tag";
    	case FMODGMS_TAGTYPE_ASF: return "ASF tag";
    	case FMODGMS_TAGTYPE_MIDI: return "MIDI tag";
    	case FMODGMS_TAGTYPE_PLAYLIST: return "Playlist tag";
    	case FMODGMS_TAGTYPE_FMOD: return "FMODGMS tag";
    	case FMODGMS_TAGTYPE_USER: return "User tag";
    	case FMODGMS_TAGTYPE_MAX: return "Max Number of Tag Types";
    	default: return "Unknown Tag Type";
	}
}

function FMODGMS_Snd_TypeToString(sound_type_index) {
	switch (sound_type_index) {
	    case FMODGMS_SOUND_TYPE_UNKNOWN: return "Unknown";
	    case FMODGMS_SOUND_TYPE_AIFF: return "AIFF";
	    case FMODGMS_SOUND_TYPE_ASF: return "ASF - Microsoft Advanced Systems Format";
	    case FMODGMS_SOUND_TYPE_DLS: return "DLS - SoundFont / Dowloadable Sound Bank";
	    case FMODGMS_SOUND_TYPE_FLAC: return "FLAC lossless codec";
	    case FMODGMS_SOUND_TYPE_FSB: return "FMOD Sample Bank";
	    case FMODGMS_SOUND_TYPE_IT: return "IT - Impluse Tracker module";
	    case FMODGMS_SOUND_TYPE_MIDI: return "MIDI Sequence";
	    case FMODGMS_SOUND_TYPE_MOD: return "MOD - Protracker / Fasttracker module";
	    case FMODGMS_SOUND_TYPE_MPEG: return "MP2/MP3 - MPEG";
	    case FMODGMS_SOUND_TYPE_OGGVORBIS: return "OGG - Ogg Vorbis";
	    case FMODGMS_SOUND_TYPE_PLAYLIST: return "Playlist - ASX/PLS/M3U/WAX";
	    case FMODGMS_SOUND_TYPE_RAW: return "RAW - Raw PCM data";
	    case FMODGMS_SOUND_TYPE_S3M: return "S3M - ScreamTracker 3 module";
	    case FMODGMS_SOUND_TYPE_USER: return "User-created";
	    case FMODGMS_SOUND_TYPE_WAV: return "WAV - Microsoft Wave";
	    case FMODGMS_SOUND_TYPE_XM: return "XM - FastTracker 2 module";
	    case FMODGMS_SOUND_TYPE_XMA: return "Xbox 360 XMA";
	    case FMODGMS_SOUND_TYPE_AUDIOQUEUE: return "iPhone hardware decoder";
	    case FMODGMS_SOUND_TYPE_AT9: return "PS4 / PSVita ATRAC 9";
	    case FMODGMS_SOUND_TYPE_VORBIS: return "Vorbis";
	    case FMODGMS_SOUND_TYPE_MEDIA_FOUNDATION: return "Windows Store Application built-in system codecs";
	    case FMODGMS_SOUND_TYPE_MEDIA_CODEC: return "Android MediaCodec";
	    case FMODGMS_SOUND_TYPE_FADPCM: return "FMOD Adaptive Differential PCM";
	    case FMODGMS_SOUND_TYPE_MAX: return "Max Number of Formats";
	    default: return "Unknown Format";
	}
}

function FMODGMS_Util_BeatsToSamples(beats, bpm, rate) {
	// Converts time measured in beats to samples, assuming a constant BPM. Can be used in conjuction with FMODGMS_Snd_Set_LoopPoints
	// for precise loop point control.
	return rate * beats / bpm * 60;
}

function FMODGMS_Util_SamplesToBeats(samples, bpm, rate) {

	// Converts time measured in samples to beats, assuming a constant BPM.
	return samples / bpm * rate / 60;
}

function FMODGMS_Util_SamplesToSeconds(samples, rate) {
	// Converts time measured in samples to seconds.
	return samples * rate;
}

function FMODGMS_Util_SecondsToSamples(seconds, rate) {
	// Converts time measured in seconds to samples. Can be used in conjuction with FMODGMS_Snd_Set_LoopPoints
	// for precise loop point control.
	return seconds * rate;
}