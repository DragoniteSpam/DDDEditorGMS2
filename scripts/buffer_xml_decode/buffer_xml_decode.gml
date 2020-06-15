/// Decodes an XML string stored in a buffer and outputs a sorta-JSON equivalent
///
/// This script was written for the dotdae library, but it's usable in lots of other contexts too
///
/// @param buffer
/// @param offset
/// @param size
///
/// @jujuadams
/// 2020-06-14

var _buffer = argument0;
var _offset = argument1;
var _size   = argument2;

var _old_tell = buffer_tell(_buffer);
buffer_seek(_buffer, buffer_seek_start, _offset);

var _skip_whitespace = true;

var _in_key    = false;
var _key_start = -1;
var _key       = "";

var _in_value     = false;
var _in_string    = false;
var _string_start = 0;
var _value        = "";

var _in_content            = false;
var _content               = "";
var _content_has_ampersand = false;
var _content_start         = 0;

var _in_tag                 = false;
var _tag                    = "";
var _tag_terminating        = false;
var _tag_self_terminating   = false;
var _tag_is_prolog          = false;
var _tag_is_comment         = false;
var _tag_terminating        = false;
var _tag_start              = 0;
var _tag_reading_attributes = false;
var _tag_has_attributes     = false;

var _stack_map = ds_map_create();
_stack_map[? "-name"] = "xml prolog";

var _stack = ds_list_create();
ds_list_add(_stack, _stack_map);

var _root = _stack_map;

repeat(_size)
{
    var _value = buffer_read(_buffer, buffer_u8);
    
    if (_skip_whitespace && (_value > 32)) _skip_whitespace = false;
    
    if (!_skip_whitespace)
    {
        if (_in_tag)
        {
            if (_in_key)
            {
                if ((_value == ord("/")) || (_value == ord("?")))
                {
                    _in_key = false;
                }
                else if ((_value == ord(" ")) || (_value == ord("=")))
                {
                    buffer_poke(_buffer, buffer_tell(_buffer)-1, buffer_u8, 0x0);
                    buffer_seek(_buffer, buffer_seek_start, _key_start);
                    _key = buffer_read(_buffer, buffer_string);
                    
                    _in_key   = false;
                    _in_value = true;
                }
                else if (_key_start < 0)
                {
                    _key_start = buffer_tell(_buffer) - 1;
                }
            }
            else if (_in_value)
            {
                if (_in_string)
                {
                    if (_value == ord("&")) //Check for ampersands so we can trigger a find-replace on the output value
                    {
                        _content_has_ampersand = true;
                    }
                    else if (_value == ord("\"")) //End string
                    {
                        buffer_poke(_buffer, buffer_tell(_buffer)-1, buffer_u8, 0x0);
                        buffer_seek(_buffer, buffer_seek_start, _string_start);
                        _value = buffer_read(_buffer, buffer_string);
                        
                        if (_content_has_ampersand) //Only run these checks if we found an ampersand
                        {
                            _value = string_replace_all(_value, "&lt;"  , "<");
                            _value = string_replace_all(_value, "&gt;"  , ">");
                            _value = string_replace_all(_value, "&amp;" , "&");
                            _value = string_replace_all(_value, "&apos;", "'");
                            _value = string_replace_all(_value, "&quot;", "\"");
                        }
                        
                        if (_tag_is_prolog)
                        {
                            _root[? _key] = _value;
                        }
                        else if (!_tag_is_comment)
                        {
                            _stack_map[? _key] = _value;
                        }
                        
                        _in_key          = true;
                        _key_start       = -1;
                        _in_string       = false;
                        _skip_whitespace = true;
                    }
                }
                else if (_value == ord("\"")) //Start the value reading at the quote mark
                {
                    _in_string    = true;
                    _string_start = buffer_tell(_buffer);
                }
            }
            else
            {
                switch(_value)
                {
                    case ord("?"): //Prolog indicator
                        if (buffer_tell(_buffer) == _tag_start + 1) _tag_is_prolog = true;
                    break;
                
                    case ord("!"): //Comment indicator
                        if (buffer_tell(_buffer) == _tag_start + 1) _tag_is_comment = true;
                    break;
                
                    case ord("/"): //Close tag indicator
                        if (buffer_tell(_buffer) == _tag_start + 1) _tag_terminating = true;
                    break;
                
                    case ord(" "):
                        buffer_poke(_buffer, buffer_tell(_buffer)-1, buffer_u8, 0x0);
                        buffer_seek(_buffer, buffer_seek_start, _tag_start);
                        _tag = buffer_read(_buffer, buffer_string);
                        
                        if (!_tag_is_prolog && !_tag_is_comment)
                        {
                            var _parent_map = _stack_map;
                            var _children = _parent_map[? "-children"];
                            if (_children == undefined)
                            {
                                _children = ds_list_create();
                                ds_map_add_list(_parent_map, "-children", _children);
                            }
                            
                            _stack_map = ds_map_create();
                            _stack_map[? "-name"] = _tag;
                            ds_list_add(_children, _stack_map);
                            ds_list_mark_as_map(_children, ds_list_size(_children)-1);
                        }
                        
                        _in_key                 = true;
                        _key_start              = -1;
                        _tag_reading_attributes = true;
                        _skip_whitespace        = true;
                    break;
                }
            }
        
            if (!_in_string && (_value == ord(">")))
            {
                if (!_tag_reading_attributes && !_tag_is_prolog && !_tag_is_comment)
                {
                    buffer_poke(_buffer, buffer_tell(_buffer)-1, buffer_u8, 0x0);
                    buffer_seek(_buffer, buffer_seek_start, _tag_start);
                    _tag = buffer_read(_buffer, buffer_string);
                    
                    if (!_tag_terminating)
                    {
                        var _parent_map = _stack_map;
                        var _children = _parent_map[? "-children"];
                        if (_children == undefined)
                        {
                            _children = ds_list_create();
                            ds_map_add_list(_parent_map, "-children", _children);
                        }
                        
                        _stack_map = ds_map_create();
                        _stack_map[? "-name"] = _tag;
                        ds_list_add(_children, _stack_map);
                        ds_list_mark_as_map(_children, ds_list_size(_children)-1);
                    }
                }
                
                var _previous_value = buffer_peek(_buffer, buffer_tell(_buffer)-2, buffer_u8);
                if ((_previous_value == ord("?")) || (_previous_value == ord("/"))) //Detect /> or ?> method to close a tag
                {
                    _tag_terminating      = true;
                    _tag_self_terminating = true;
                }
                
                if (!_tag_is_prolog && !_tag_is_comment && !_tag_self_terminating)
                {
                    if (_tag_terminating)
                    {
                        ds_list_delete(_stack, 0);
                        _stack_map = _stack[| 0];
                    }
                    else
                    {
                        ds_list_insert(_stack, 0, _stack_map);
                        
                        _in_content            = true;
                        _content_has_ampersand = false;
                        _content_start         = buffer_tell(_buffer);
                    }
                }
                
                _in_tag   = false;
                _in_key   = false;
                _in_value = false;
            }
        }
        else if ((_value == 10) || (_value == 13)) //Newline
        {
            _in_content      = false;
            _skip_whitespace = true;
        }
        else if (_value == ord("<")) //Open a tag
        {
            if (_in_content)
            {
                _in_content = false;
                buffer_poke(_buffer, buffer_tell(_buffer)-1, buffer_u8, 0x0);
                buffer_seek(_buffer, buffer_seek_start, _content_start);
                _content = buffer_read(_buffer, buffer_string);
                
                _stack_map[? "-content"] = _content;
            }
            
            _in_tag                 = true;
            _tag_terminating        = false;
            _tag_self_terminating   = false;
            _tag_is_prolog          = false;
            _tag_is_comment         = false;
            _tag_terminating        = false;
            _tag_reading_attributes = false;
            _tag_has_attributes     = false;
            _tag_start              = buffer_tell(_buffer);
        }
    }
}

ds_list_destroy(_stack);
buffer_seek(_buffer, buffer_seek_start, _old_tell);

return _root