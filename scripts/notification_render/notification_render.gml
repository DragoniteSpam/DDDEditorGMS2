if (t<1){
    var a=t;
} else if (t<(1+lifespan)){
    var a=1;
} else {
    var a=max(1-(t-lifespan-1), 0);
}

draw_text_colour(x, y, string(text), color, color, color, color, a);

t=t+delta_time/MILLION;

if (t>(lifespan+2)){
    instance_destroy();
}
