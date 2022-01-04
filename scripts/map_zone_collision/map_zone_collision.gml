function map_zone_collision(zone) {
    var maxx = max(zone.x1, zone.x2);
    var maxy = max(zone.y1, zone.y2);
    var maxz = max(zone.z1, zone.z2);
    var minx = min(zone.x1, zone.x2);
    var miny = min(zone.y1, zone.y2);
    var minz = min(zone.z1, zone.z2);
    
    zone.x1 = minx;
    zone.y1 = miny;
    zone.z1 = minz;
    zone.x2 = maxx;
    zone.y2 = maxy;
    zone.z2 = maxz;
    
    var ww = (zone.x2 - zone.x1 + 1);
    var hh = (zone.y2 - zone.y1 + 1);
    var dd = (zone.z2 - zone.z1 + 1);
    zone.zz = zone.z1;
}
