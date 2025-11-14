self.dbg_things_drawn_text = $"Things drawn: {self.things_drawn}/{TREE_COUNT} things in world";
self.dbg_frustum_time_text = $"Frustum time: {self.frustum_time} ms";
self.dbg_world_type_text = $"World type: {instanceof(self.collision_world.accelerator)}";
self.dbg_fps_text = $"FPS: {fps}/{fps_real}";

if (self.draw_frustum_view) {
    var ww = surface_get_width(self.preview_surface);
    var hh = surface_get_height(self.preview_surface);
    var xx = window_get_width() - ww - 40;
    var yy = 40;
    draw_surface(self.preview_surface, xx, yy);
    draw_rectangle_colour(xx + 1, yy + 1, xx + ww, yy + hh, c_white, c_white, c_white, c_white, true);
}