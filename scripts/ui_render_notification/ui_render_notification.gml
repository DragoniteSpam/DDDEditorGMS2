scribble_draw(x, y, scribble);

t = t + Stuff.dt;

if (t > (lifespan + 2)) {
    instance_destroy();
}