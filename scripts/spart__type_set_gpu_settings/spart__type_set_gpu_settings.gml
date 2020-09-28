/// @description spart__type_set_gpu_settings(partType);
/// @param partType
function spart__type_set_gpu_settings(argument0) {
    /*
        Sets the GPU settings for the given particle type
    
        Script created by TheSnidr
        www.TheSnidr.com
    */
    var partType = argument0;

    //Set GPU settings
    gpu_set_cullmode(partType[| sPartTyp.CullMode]);
    gpu_set_zwriteenable(partType[| sPartTyp.Zwrite]);
    gpu_set_blendenable(partType[| sPartTyp.BlendEnable]);
    if partType[| sPartTyp.BlendEnable]
    {
        gpu_set_blendmode_ext(partType[| sPartTyp.BlendSrc], partType[| sPartTyp.BlendDst]);
    }


}
