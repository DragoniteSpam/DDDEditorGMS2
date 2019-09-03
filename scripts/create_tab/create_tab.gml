/// @param name
/// @param home-row
/// @param root

with (instantiate(UITab)) {
    text = argument[0];
    home_row = argument[1];
    
    root = argument[2];
    
    return id;
}