/// @param Entity
function safa_delete(argument0) {

	var entity = argument0;

	if (entity.modification == Modifications.NONE) {
	    entity.modification = Modifications.REMOVE;
	    ds_list_add(Stuff.map.changes, entity);
	}


}
