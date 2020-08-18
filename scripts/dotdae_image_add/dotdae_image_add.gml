/// @param sprite
/// @param fakeRelativePath
function dotdae_image_add(argument0, argument1) {

	var _sprite        = argument0;
	var _relative_path = argument1;

	var _texture = sprite_get_texture(_sprite, 0);
	var _uvs     = sprite_get_uvs(_sprite, 0);
	if ((_uvs[0] != 0.0) || (_uvs[1] != 0.0) || (_uvs[2] != 1.0) || (_uvs[3] != 1.0))
	{
	    __dotdae_trace("WARNING! Check \"", sprite_get_name(_sprite), "\" is set to Separate Texture Page");
	}

	_relative_path = string_replace_all(_relative_path, "/", "\\");
	if (string_char_at(_relative_path, 1) == "\\") _relative_path = string_delete(_relative_path, 1, 1);

	var _object = array_create(eDotDaeImage.__Size, undefined);
	_object[@ eDotDaeImage.Name        ] = sprite_get_name(_sprite);
	_object[@ eDotDaeImage.Type        ] = "image";
	_object[@ eDotDaeImage.RelativePath] = _relative_path;
	_object[@ eDotDaeImage.Sprite      ] = _sprite;
	_object[@ eDotDaeImage.Texture     ] = _texture;
	_object[@ eDotDaeImage.External    ] = false;

	global.dae_image_library[? _relative_path] = _object;

	if (DOTDAE_OUTPUT_DEBUG) __dotdae_trace("Sprite \"", sprite_get_name(_sprite), "\" added as image, spoofing \"", _relative_path, "\" (sprite=", _sprite, ", texture=", _texture, ")");


}
