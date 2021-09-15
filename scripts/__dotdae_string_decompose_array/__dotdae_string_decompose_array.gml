/// @param string
/// @param outputReal
function __dotdae_string_decompose_array(argument0, argument1) {

    var _string      = argument0;
    var _output_real = argument1;

    var _size = string_byte_length(_string) + 1;
    var _buffer = buffer_create(_size, buffer_fixed, 1);
    buffer_write(_buffer, buffer_text, _string);
    buffer_seek(_buffer, buffer_seek_start, 0);

    var _array = [];

    var _substring_start = 0;
    repeat(_size)
    {
        var _value = buffer_read(_buffer, buffer_u8);
        if (_value <= 32)
        {
            buffer_poke(_buffer, buffer_tell(_buffer)-1, buffer_u8, 0x0);
            buffer_seek(_buffer, buffer_seek_start, _substring_start);
            var _substring = buffer_read(_buffer, buffer_string);
            if (_substring != "")
            {
                if (_output_real) _substring = real(_substring);
                _array[@ array_length(_array)] = _substring;
            }
            _substring_start = buffer_tell(_buffer);
        }
    }

    buffer_delete(_buffer);

    return _array;


}
