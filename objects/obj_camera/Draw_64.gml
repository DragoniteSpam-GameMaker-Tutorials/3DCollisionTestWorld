draw_set_font(fnt_demo);
var n = 0;
var s = 28;
draw_text(32, 32 + s * n++, $"Setup time: {self.setup_time} ms");
draw_text(32, 32 + s * n++, $"Things drawn: {self.things_drawn}/{TREE_COUNT} things in world");
draw_text(32, 32 + s * n++, $"World type: {instanceof(self.collision_world.accelerator)}");
draw_text(32, 32 + s * n++, $"FPS: {fps}/{fps_real}");
draw_text(32, 32 + s * n++, "Press Tab to toggle mouse lock");
draw_text(32, 32 + s * n++, "Press C to toggle collision shapes");
draw_text(32, 32 + s * n++, "Press T to throw a ball");

if (self.draw_frustum_view) {
    var xx = 0;
    var yy = 256;
    var ww = surface_get_width(self.preview_surface);
    var hh = surface_get_height(self.preview_surface);
    draw_surface(self.preview_surface, xx, yy);
    draw_rectangle_colour(xx + 1, yy + 1, xx + ww, yy + hh, c_white, c_white, c_white, c_white, true);
    draw_text(xx + 16, yy + 16, "Culling visualization (toggle with F)");
}