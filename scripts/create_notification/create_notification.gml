/// @description  UINotification create_notification(text);
/// @param text

// you can do *some* formatting with the returned object but you'll
// probably have to mess with the render script to make it do anything

with (instance_create(32, 64+32*instance_number(UINotification), UINotification)){
    text=argument0;
    
    return id;
}
