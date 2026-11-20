function ColHeightmap(buffer, w, h, scale) constructor {
    self.buffer = buffer;
    self.w = w;
    self.h = h;
    self.scale = scale;
    
    static GetHeight = function(x, y) {
        x /= self.scale;
        y /= self.scale;
        
        x = clamp(x, 0, self.w - 1);
        y = clamp(y, 0, self.h - 1);
        
        var data_type_size = buffer_sizeof(buffer_f32);
        
        var x0 = floor(x);
        var y0 = floor(y);
        var x1 = ceil(x);
        var y1 = ceil(y);
        
        var index00 = x0 * self.h + y0;
        var index01 = x0 * self.h + y1;
        var index10 = x1 * self.h + y0;
        var index11 = x1 * self.h + y1;
        
        var z00 = buffer_peek(self.buffer, index00 * data_type_size, buffer_f32);
        var z01 = buffer_peek(self.buffer, index01 * data_type_size, buffer_f32);
        var z10 = buffer_peek(self.buffer, index10 * data_type_size, buffer_f32);
        var z11 = buffer_peek(self.buffer, index11 * data_type_size, buffer_f32);
        
        var z_top =         lerp(z00, z10, frac(x));
        var z_bottom =      lerp(z01, z11, frac(x));
        var z_final =       lerp(z_top, z_bottom, frac(y));
        
        return z_final * self.scale;
    };
    
    static Delete = function() {
        buffer_delete(self.buffer);
    };
}