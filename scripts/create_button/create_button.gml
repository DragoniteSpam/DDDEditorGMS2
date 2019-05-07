/// @description  UIButton create_button(x, y, text, width, height, alignment, onmouseup, root, [help], [anchor horizontal], [anchor vertical]);
/// @param x
/// @param  y
/// @param  text
/// @param  width
/// @param  height
/// @param  alignment
/// @param  onmouseup
/// @param  root
/// @param  [help]
/// @param  [anchor horizontal]
/// @param  [anchor vertical]

with (instance_create(argument[0], argument[1], UIButton)){
    text=argument[2];
    width=argument[3];
    height=argument[4];

    alignment=argument[5];
    onmouseup=argument[6];
    root=argument[7];
    
    switch (argument_count){
        case 11:
            switch (argument[10]){
                case fa_top:
                    break;
                case fa_middle:
                    y=y-height/2;
                    break;
                case fa_bottom:
                    y=y-height;
                    break;
            }
        case 10:
            switch (argument[9]){
                case fa_left:
                    break;
                case fa_center:
                    x=x-width/2;
                    break;
                case fa_right:
                    x=x-width;
                    break;
            }
        case 9:
            help=argument[8];
            break;
    }
    
    return id;
}
