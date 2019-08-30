/// @param name
/// @param home-row
/// @param root
/// @param [help]

with (instantiate(UITab)) {
    text = argument[0];
    home_row = argument[1];
    
    root = argument[2];
    
    help = (argument_count > 3) ? argument[3] : help;
    
    return id;
}