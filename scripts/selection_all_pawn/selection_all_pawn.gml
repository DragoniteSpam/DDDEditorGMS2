/// @description  boolean selection_all_pawn();

var list=selection_all();

for (var i=0; i<ds_list_size(list); i++){
    if (!instanceof(list[| i], EntityPawn)){
        return false;
    }
}

return true;
