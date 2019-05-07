/// @description  void event_connect_node(source, destination, [index]);
/// @param source
/// @param  destination
/// @param  [index]

var index=0;
switch (argument_count){
    case 3:
        index=argument[2];
        break;
}

// because this would be silly
if (argument[0]!=argument[1]){
    var old_node=argument[0].outbound[| index];
    if (old_node!=noone){
        ds_map_delete(old_node.parents, argument[0]);
    }
    
    argument[1].parents[? argument[0]]=true;
    argument[0].outbound[| index]=argument[1];
}
