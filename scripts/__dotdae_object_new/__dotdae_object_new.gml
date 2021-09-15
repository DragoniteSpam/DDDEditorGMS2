/// @param name
/// @param type
/// @param size
/// @param trackingList
function __dotdae_object_new(argument0, argument1, argument2, argument3) {

    var _name = argument0;
    var _type = argument1;
    var _size = argument2;
    var _list = argument3;

    var _array = array_create(_size, undefined);
    _array[@ __DOTDAE_NAME_INDEX] = (_name == undefined)? "<unnamed>" : _name;
    _array[@ __DOTDAE_TYPE_INDEX] = _type;

    if (_name != undefined) global.__dae_object_map[? _name] = _array;
    if (_list != undefined) ds_list_add(_list, _array);

    return _array;


}
