/// @param [name]

var name = (argument_count > 0) ? argument[0] : "";

return get_save_filename("Anything valid|*.d3d;*.gmmod;*.obj|Game Maker model files|*.d3d;*.gmmod|Object files|*.obj", name);