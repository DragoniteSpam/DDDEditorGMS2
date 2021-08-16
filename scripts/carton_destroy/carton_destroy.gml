/// @param carton

function carton_destroy(_carton)
{
	buffer_delete(_carton.buffer);
    
	//Invalidate this carton so that we can't accidentally re-reference it
	_carton.buffer = undefined;
	_carton.layout = undefined;
}