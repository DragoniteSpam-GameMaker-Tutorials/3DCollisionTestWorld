draw_set_font(fnt_demo);
draw_text(32, 32, $"Setup time: {self.setup_time}, ms");
draw_text(32, 64, $"Things drawn: {self.things_drawn}/{TREE_COUNT}");
draw_text(32, 96, $"World type: {instanceof(self.collision_world.accelerator)}");
draw_text(32, 128, $"FPS: {fps}/{fps_real}");
draw_text(32, 160, "Press Tab to toggle mouse lock");
draw_text(32, 192, "Press C to toggle collision shapes");

if (self.draw_frustum_view) {
    draw_surface(self.preview_surface, 0, window_get_height() - surface_get_height(self.preview_surface));
    draw_rectangle_colour(1, window_get_height() - surface_get_height(self.preview_surface), surface_get_width(self.preview_surface), window_get_height() - 2, c_white, c_white, c_white, c_white, true);
    draw_text(32, window_get_height() - surface_get_height(self.preview_surface) + 32, "Frustum culling visualization (toggle with F)");
}