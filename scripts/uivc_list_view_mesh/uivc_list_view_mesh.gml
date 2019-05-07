/// @description  uivc_list_view_mesh(UIList);
/// @param UIList
// at this point, the list already knows what's been selected,
// it just behaves accordingly.

if (data_vra_exists()&&ds_map_size(argument0.selected_entries)==1){
    var data=Stuff.vra_data[? Stuff.all_mesh_names[| ui_list_selection(argument0)]];
    argument0.root.el_bounds_xmin.text="  xmin: "+string(data[MeshArrayData.XMIN]);
    argument0.root.el_bounds_ymin.text="  ymin: "+string(data[MeshArrayData.YMIN]);
    argument0.root.el_bounds_zmin.text="  zmin: "+string(data[MeshArrayData.ZMIN]);
    argument0.root.el_bounds_xmax.text="  xmax: "+string(data[MeshArrayData.XMAX]);
    argument0.root.el_bounds_ymax.text="  ymax: "+string(data[MeshArrayData.YMAX]);
    argument0.root.el_bounds_zmax.text="  zmax: "+string(data[MeshArrayData.ZMAX]);
    argument0.root.el_preview.interactive=true;
} else {
    argument0.root.el_bounds_xmin.text="";
    argument0.root.el_bounds_ymin.text="";
    argument0.root.el_bounds_zmin.text="";
    argument0.root.el_bounds_xmax.text="";
    argument0.root.el_bounds_ymax.text="";
    argument0.root.el_bounds_zmax.text="";
    argument0.root.el_preview.interactive=false;
}
