/// @description  UIBitField create_bitfield(x, y, text, width, height, onvaluechange, default, root, [help]);
/// @param x
/// @param  y
/// @param  text
/// @param  width
/// @param  height
/// @param  onvaluechange
/// @param  default
/// @param  root
/// @param  [help]

with (instance_create_depth(argument[0], argument[1], 0, UIBitField)){
    text=argument[2];
    width=argument[3];
    height=argument[4];
    
    onvaluechange=argument[5];
    value=argument[6];
    
    root=argument[7];
    
    switch (argument_count){
        case 9:
            help=argument[8];
            break;
    }
    
    return id;
}
