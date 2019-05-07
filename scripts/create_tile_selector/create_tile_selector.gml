/// @description  UITileSelector create_tile_selector(x, y, width, height, onvaluechange, onvaluechangebackwards, root, [help]);
/// @param x
/// @param  y
/// @param  width
/// @param  height
/// @param  onvaluechange
/// @param  onvaluechangebackwards
/// @param  root
/// @param  [help]

with (instance_create(argument[0], argument[1], UITileSelector)){
    width=argument[2];
    height=argument[3];
    
    onvaluechange=argument[4];
    onvaluechangebackwards=argument[5];
    root=argument[6];
    
    switch (argument_count){
        case 8:
            help=argument[7];
            break;
    }
    
    return id;
}
