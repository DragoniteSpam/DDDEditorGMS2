/// @param map
/// @param context
function __dotdae_model_load_inner(argument0, argument1) {

    var _map     = argument0;
    var _context = argument1;

    var _tag            = _map[? "-name"    ];
    var _children       = _map[? "-children"];
    var _content        = _map[? "-content" ];
    var _id             = _map[? "id"       ];
    var _parse_children = true;
    var _return         = undefined;
    var _stack_size     = ds_list_size(global.__dae_stack);

    switch(_tag)
    {
        case "xml prolog":                     break;
        case "COLLADA":                        break;
        case "asset":      _context = "asset"; break;
    
        #region Libraries
    
        case "library_effects":       _context = "effect";                                break;
        case "library_materials":     _context = "material";                              break;
        case "library_images":        _context = "image";                                 break;
        case "library_geometries":    _context = "geometry";                              break;
        case "library_visual_scenes": _context = "visual scene"; _parse_children = false; break; //Unsupported for now
        case "library_lights":        _context = "light";        _parse_children = false; break; //Unsupported for now
        case "library_cameras":       _context = "camera";       _parse_children = false; break; //Unsupported for now
        case "library_animations":    _context = "animation";    _parse_children = false; break; //Unsupported for now
        case "library_controllers":   _context = "controller";                            break;
    
        #endregion
    
        #region Images
    
        case "image":
            var _object = __dotdae_object_new_push(_id, _tag, eDotDaeImage.__Size, global.__dae_images_list);
        
            var _i = 0;
            repeat(ds_list_size(_children))
            {
                __dotdae_model_load_inner(_children[| _i], _context);
                ++_i;
            }
        
            _parse_children = false;
        
            var _relative_path = _object[eDotDaeImage.RelativePath];
            _relative_path = string_replace_all(_relative_path, "/", "\\");
            if (string_char_at(_relative_path, 1) == "\\") _relative_path = string_delete(_relative_path, 1, 1);
        
            if (_relative_path != undefined)
            {
                var _existing_data = global.dae_image_library[? _relative_path];
                if (is_array(_existing_data))
                {
                    _object[@ eDotDaeImage.Sprite  ] = _existing_data[eDotDaeImage.Sprite  ];
                    _object[@ eDotDaeImage.Texture ] = _existing_data[eDotDaeImage.Texture ];
                    _object[@ eDotDaeImage.External] = _existing_data[eDotDaeImage.External];
                
                    if (DOTDAE_OUTPUT_DEBUG) __dotdae_trace("Image \"", _id, "\" from \"", _relative_path, "\" was previously added (sprite=", _object[eDotDaeImage.Sprite], ", texture=", _object[eDotDaeImage.Texture], ")");
                }
                else
                {
                    var _sprite = sprite_add(_relative_path, 0, false, false, 0, 0);
                    if (_sprite < 0)
                    {
                        __dotdae_trace("ERROR! Image \"", _id, "\" is sourced from \"", _relative_path, "\", but the file could not be found");
                        _object[@ eDotDaeImage.Texture ] = -1;
                        _object[@ eDotDaeImage.External] = false;
                    }
                    else
                    {
                        var _texture = sprite_get_texture(_sprite, 0);
                        if (DOTDAE_OUTPUT_DEBUG) __dotdae_trace("Image \"", _id, "\" added from \"", _relative_path, "\" (sprite=", _sprite, ", texture=", _texture, ")");
                    
                        _object[@ eDotDaeImage.Sprite  ] = _sprite;
                        _object[@ eDotDaeImage.Texture ] = sprite_get_texture(_sprite, 0);
                        _object[@ eDotDaeImage.External] = true;
                        global.dae_image_library[? _relative_path] = _object;
                    }
                }
            }
        break;
    
        #endregion
    
        #region Controllers
    
        case "controller":
            var _object = __dotdae_object_new_push(_id, _tag, eDotDaeController.__Size, global.__dae_controllers_list);
            _object[@ eDotDaeController.DisplayName] = _map[? "name"];
            _object[@ eDotDaeController.SourceArray] = [];
        
            if (DOTDAE_OUTPUT_DEBUG) __dotdae_trace("Controller \"", _id, "\" added");
        break;
    
        case "skin":
            var _source = _map[? "source"];
            if (string_char_at(_source, 1) == "#") _source = string_delete(_source, 1, 1);
        
            var _polylist = global.__dae_object_map[? _source];
            _polylist[@ eDotDaePolyList.SkinController] = global.__dae_object_on_stack[__DOTDAE_NAME_INDEX];
        
            global.__dae_object_on_stack[eDotDaeController.ControllerType] = "skin";
            global.__dae_object_on_stack[eDotDaeController.PolyList      ] = _source;
            if (DOTDAE_OUTPUT_DEBUG) __dotdae_trace("            ^-- bound to polylist \"", _source, "\"");
        break;
    
        case "joints":
            //TODO - We can ignore this for now probably
            _parse_children = false;
        break;
    
        case "vertex_weights":
            var _parent = global.__dae_object_on_stack;
        
            var _object = __dotdae_object_new_push(_id, _tag, eDotDaeVertexWeights.__Size, undefined);
            _object[@ eDotDaeVertexWeights.Count     ] = real(_map[? "count"]);
            _object[@ eDotDaeVertexWeights.InputArray] = [];
        
            _parent[@ eDotDaeController.VertexWeights] = _object;
        break;
    
        case "v":
            global.__dae_object_on_stack[@ eDotDaeVertexWeights.VString] = _content;
        break;
    
        #endregion
    
        #region Common
    
        case "name_array":
        case "Name_array": //Weird case insensitive tag name
            if (_context == "controller")
            {
                var _object = __dotdae_object_new(_id, _tag, eDotDaeFloatArray.__Size, undefined);
                _object[@ eDotDaeFloatArray.List] = __dotdae_string_decompose_list(_content, false);
                global.__dae_object_on_stack[@ eDotDaeSource.FloatArray] = _object;
            }
        break;
    
        case "float_array":
            if (_context == "geometry")
            {
                var _object = __dotdae_object_new(_id, _tag, eDotDaeFloatArray.__Size, undefined);
                _object[@ eDotDaeFloatArray.List] = __dotdae_string_decompose_list(_content, true);
                global.__dae_object_on_stack[@ eDotDaeSource.FloatArray] = _object;
            }
            else if (_context == "controller")
            {
                var _object = __dotdae_object_new(_id, _tag, eDotDaeFloatArray.__Size, undefined);
                _object[@ eDotDaeFloatArray.List] = __dotdae_string_decompose_list(_content, true);
                global.__dae_object_on_stack[@ eDotDaeSource.FloatArray] = _object;
            }
        break;
    
        case "source":
            if (_context == "geometry")
            {
                var _parent = global.__dae_object_on_stack;
                var _object = __dotdae_object_new_push(_id, _tag, eDotDaeSource.__Size, undefined);
            
                var _parent_source_array = _parent[eDotDaeMesh.SourceArray];
                _parent_source_array[@ array_length(_parent_source_array)] = _object;
            }
            else if (_context == "controller")
            {
                var _parent = global.__dae_object_on_stack;
                var _object = __dotdae_object_new_push(_id, _tag, eDotDaeSource.__Size, undefined);
            
                var _parent_source_array = _parent[eDotDaeController.SourceArray];
                _parent_source_array[@ array_length(_parent_source_array)] = _object;
            }
            else if (_context == "effect")
            {
                global.__dae_parameter[@ eDotDaeParameter.Value] = _content;
            }
        break;
    
        case "vcount":
            if (_context == "geometry")
            {
                //TODO - Support flexible vcount
            }
            else if (_context == "controller")
            {
                global.__dae_object_on_stack[@ eDotDaeVertexWeights.VCountString] = _content;
            }
        break;
    
        case "input":
            if (_context == "geometry")
            {
                var _parent = global.__dae_object_on_stack;
            
                var _object = __dotdae_object_new(_id, _tag, eDotDaeInput.__Size, undefined);
                _object[@ eDotDaeInput.Semantic] = _map[? "semantic"];
                _object[@ eDotDaeInput.Source  ] = _map[? "source"  ];
                _object[@ eDotDaeInput.Offset  ] = _map[? "offset"  ];
            
                if (_parent[__DOTDAE_TYPE_INDEX] == "vertices")
                {
                    var _parent_source_array = _parent[eDotDaeVertices.InputArray];
                    _parent_source_array[@ array_length(_parent_source_array)] = _object;
                }
                else if ((_parent[__DOTDAE_TYPE_INDEX] == "triangles") || (_parent[__DOTDAE_TYPE_INDEX] == "polylist"))
                {
                    var _parent_source_array = _parent[eDotDaePolyList.InputArray];
                    _parent_source_array[@ array_length(_parent_source_array)] = _object;
                }
            }
            else if (_context == "controller")
            {
                //TODO - Actually use this data for something
                var _parent = global.__dae_object_on_stack;
            
                var _object = __dotdae_object_new(_id, _tag, eDotDaeInput.__Size, undefined);
                _object[@ eDotDaeInput.Semantic] = _map[? "semantic"];
                _object[@ eDotDaeInput.Source  ] = _map[? "source"  ];
                _object[@ eDotDaeInput.Offset  ] = _map[? "offset"  ];
            
                var _parent_source_array = _parent[eDotDaeVertexWeights.InputArray];
                _parent_source_array[@ array_length(_parent_source_array)] = _object;
            }
        break;
    
        #endregion
    
        case "init_from":
            if (_context == "image")
            {
                global.__dae_object_on_stack[@ eDotDaeImage.RelativePath] = _content;
            }
            else if (_context == "effect")
            {
                global.__dae_parameter[@ eDotDaeParameter.Value] = _content;
            }
        break;
    
        #region Effect
    
        case "effect":
            var _object = __dotdae_object_new_push(_id, _tag, eDotDaeEffect.__Size, global.__dae_effects_list);
            _object[@ eDotDaeEffect.Parameters] = ds_map_create();
        
            if (DOTDAE_OUTPUT_DEBUG) __dotdae_trace("Adding effect \"", _id, "\"");
        break;
    
        case "phong":
            global.__dae_object_on_stack[@ eDotDaeEffect.Technique] = "phong";
        break;
    
        case "emission":            _context = "emission";            break;
        case "ambient":             _context = "ambient";             break;
        case "diffuse":             _context = "diffuse";             break;
        case "specular":            _context = "specular";            break;
        case "shininess":           _context = "shininess";           break;
        case "index_of_refraction": _context = "index_of_refraction"; break;
    
        case "color":
            var _colour_array = __dotdae_string_decompose_array(_content, true);
            var _rgba = (255*_colour_array[3])<<24 + (255*_colour_array[2])<<16 + (255*_colour_array[1])<<8 + (255*_colour_array[0]);
        
            switch(_context)
            {
                case "emission":            global.__dae_object_on_stack[@ eDotDaeEffect.Emission  ] = _rgba; break;
                case "ambient":             global.__dae_object_on_stack[@ eDotDaeEffect.Ambient   ] = _rgba; break;
                case "diffuse":             global.__dae_object_on_stack[@ eDotDaeEffect.Diffuse   ] = _rgba; break;
                case "specular":            global.__dae_object_on_stack[@ eDotDaeEffect.Specular  ] = _rgba; break;
                case "shininess":           global.__dae_object_on_stack[@ eDotDaeEffect.Shininess ] = _rgba; break;
                case "index_of_refraction": global.__dae_object_on_stack[@ eDotDaeEffect.Refraction] = _rgba; break;
            }
        break;
    
        case "texture":
            var _texture_name  = _map[? "texture" ];
            var _texcoord_name = _map[? "texcoord"]; //Not used at the moment
            switch(_context)
            {
                case "emission":  global.__dae_object_on_stack[@ eDotDaeEffect.EmissionImageName ] = _texture_name; break;
                case "ambient":   global.__dae_object_on_stack[@ eDotDaeEffect.AmbientImageName  ] = _texture_name; break;
                case "diffuse":   global.__dae_object_on_stack[@ eDotDaeEffect.DiffuseImageName  ] = _texture_name; break;
                case "specular":  global.__dae_object_on_stack[@ eDotDaeEffect.SpecularImageName ] = _texture_name; break;
                case "shininess": global.__dae_object_on_stack[@ eDotDaeEffect.ShininessImageName] = _texture_name; break;
            }
        break;
    
        case "float":
            switch(_context)
            {
                case "emission":            global.__dae_object_on_stack[@ eDotDaeEffect.Emission  ] = real(_content); break;
                case "ambient":             global.__dae_object_on_stack[@ eDotDaeEffect.Ambient   ] = real(_content); break;
                case "diffuse":             global.__dae_object_on_stack[@ eDotDaeEffect.Diffuse   ] = real(_content); break;
                case "specular":            global.__dae_object_on_stack[@ eDotDaeEffect.Specular  ] = real(_content); break;
                case "shininess":           global.__dae_object_on_stack[@ eDotDaeEffect.Shininess ] = real(_content); break;
                case "index_of_refraction": global.__dae_object_on_stack[@ eDotDaeEffect.Refraction] = real(_content); break;
            }
        break;
    
        case "newparam":
            var _sid = _map[? "sid"];
            var _object = array_create(eDotDaeParameter.__Size, undefined);
            _object[@ eDotDaeParameter.Name] = _sid;
            _object[@ eDotDaeParameter.Type] = _tag;
        
            var _parameter_map = global.__dae_object_on_stack[eDotDaeEffect.Parameters];
            _parameter_map[? _sid] = _object;
        
            global.__dae_parameter = _object;
        break;
    
        case "surface":
        case "sampler2D":
            global.__dae_parameter[@ eDotDaeParameter.ParameterType] = _tag;
        break;
    
        #endregion
    
        #region Material
    
        case "material":
            var _object = __dotdae_object_new_push(_id, _tag, eDotDaeMaterial.__Size, global.__dae_materials_list);
            _object[@ eDotDaeMaterial.DisplayName] = _map[? "name"];
        break;
    
        case "instance_effect":
            var _url = _map[? "url"];
            if (string_char_at(_url, 1) == "#") _url = string_delete(_url, 1, 1);
        
            //TODO - Error handling for when the effect can't be found
            global.__dae_object_on_stack[@ eDotDaeMaterial.InstanceOf] = global.__dae_object_map[? _url];
        
            if (DOTDAE_OUTPUT_DEBUG) __dotdae_trace("Material \"", global.__dae_object_on_stack[eDotDaeMaterial.Name], "\" added, instance of effect \"", _url, "\"");
        break;
    
        #endregion
    
        #region Geometry
    
        case "geometry":
            var _object = __dotdae_object_new_push(_id, _tag, eDotDaeGeometry.__Size, global.__dae_geometries_list);
            _object[@ eDotDaeGeometry.MeshArray] = [];
        
            if (DOTDAE_OUTPUT_DEBUG) __dotdae_trace("Geometry \"", _id, "\" added");
        break;
    
        case "mesh":
            var _parent = global.__dae_object_on_stack;
        
            var _object = __dotdae_object_new_push(_parent[__DOTDAE_NAME_INDEX], _tag, eDotDaeMesh.__Size, undefined);
            _object[@ eDotDaeMesh.SourceArray      ] = [];
            _object[@ eDotDaeMesh.VertexBufferArray] = [];
        
            var _parent_mesh_array = _parent[eDotDaeGeometry.MeshArray];
            _parent_mesh_array[@ array_length(_parent_mesh_array)] = _object;
        break;
    
        case "accessor":
            //We don't care about the accessor definition
        break;
    
        case "vertices":
            var _object = __dotdae_object_new_push(_id, _tag, eDotDaeVertices.__Size, undefined);
            _object[@ eDotDaeVertices.InputArray] = [];
        break;
    
        case "triangles":
        case "polylist":
            var _parent = global.__dae_object_on_stack;
            var _vbuff_array = _parent[eDotDaeMesh.VertexBufferArray];
        
            var _object = __dotdae_object_new_push(_parent[__DOTDAE_NAME_INDEX], _tag, eDotDaePolyList.__Size, global.__dae_vertex_buffers_list);
            _object[@ eDotDaePolyList.Count     ] = real(_map[? "count"]);
            _object[@ eDotDaePolyList.Material  ] = _map[? "material"];
            _object[@ eDotDaePolyList.InputArray] = [];
        
            _vbuff_array[@ array_length(_vbuff_array)] = _object;
        break;
    
        case "p":
            global.__dae_object_on_stack[@ eDotDaePolyList.PString] = _content;
        break;
    
        #endregion
    }

    if (_parse_children && (_children != undefined))
    {
        var _i = 0;
        repeat(ds_list_size(_children))
        {
            __dotdae_model_load_inner(_children[| _i], _context);
            ++_i;
        }
    }

    //If the stack size has changed, pop the object we pushed!
    if (_stack_size != ds_list_size(global.__dae_stack))
    {
        ds_list_delete(global.__dae_stack, ds_list_size(global.__dae_stack)-1);
        global.__dae_object_on_stack = global.__dae_stack[| ds_list_size(global.__dae_stack)-1];
    }

    return _return;


}
