/// @param objectMap
/// @param effectArray
/// @param imageNameField
/// @param textureField

var _object_map    = argument0;
var _effect        = argument1;
var _name_field    = argument2;
var _texture_field = argument3;

var _name = _effect[_name_field];
if (_name != undefined)
{
    var _effect_params = _effect[eDotDaeEffect.Parameters];
    var _param = _effect_params[? _name];
        _name  = _param[eDotDaeParameter.Value];
        _param = _effect_params[? _name];
        _name  = _param[eDotDaeParameter.Value];
    var _image = _object_map[? _name];
    
    _effect[@ _texture_field] = _image[eDotDaeImage.Texture];
}
else
{
    _effect[@ _texture_field] = -1;
}