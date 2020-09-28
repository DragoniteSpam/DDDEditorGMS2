/// @description smf_light_add_lights_from_model(modelIndex)
/// @param modelIndex
function smf_light_add_lights_from_model(argument0) {
    var light;
    var i = (array_length(SMF_lights) div 8) * 8;
    var modelIndex = argument0;
    var nodeList = modelIndex[| SMF_model.NodeList];
    var lightList = modelIndex[| SMF_model.LightList];
    for (var k = 0; k < ds_list_size(lightList); k ++)
    {
        light = nodeList[| lightList[| k]];
        var j = 0;
        repeat 8{SMF_lights[i++] = light[j++];}
    }
    SMF_ambientColor = modelIndex[| SMF_model.AmbientColor];


}
