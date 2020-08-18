/// @description smf_dualquat_create_identity()
function smf_dualquat_create_identity() {
	//Creates an identity dual quaternion
	gml_pragma("forceinline");

	return [0, 0, 0, 1, 0, 0, 0, 0];


}
