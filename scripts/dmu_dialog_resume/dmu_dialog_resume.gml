/// @param UIButton
function dmu_dialog_resume(argument0) {

    var button = argument0;

    if (Stuff.fmod_sound) {
        FMODGMS_Chan_ResumeChannel(Stuff.fmod_channel);
        Stuff.fmod_paused = false;
    }


}
