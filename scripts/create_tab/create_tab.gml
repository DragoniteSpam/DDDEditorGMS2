/// @description  UITab create_tab(name, home row, root, [help]);
/// @param name
/// @param  home row
/// @param  root
/// @param  [help]

with (instantiate(UITab)){
    text=argument[0];
    home_row=argument[1];
    
    root=argument[2];
    
    switch (argument_count){
        case 4:
            help=argument[3];
            break;
    }
    return id;
}
