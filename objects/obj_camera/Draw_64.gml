draw_text(32, 40, $"Setup time: {self.setup_time}, ms");
draw_text(32, 60, $"Things drawn: {self.things_drawn}/{TREE_COUNT}");
draw_text(32, 80, $"World type: {instanceof(self.collision_world.accelerator)}");
draw_text(32, 100, $"FPS: {fps}/{fps_real}");
draw_text(32, 120, "Press Tab to toggle mouse lock");
draw_text(32, 140, "Press Z to draw debug shapes");

draw_surface(self.preview_surface, 0, window_get_height() - surface_get_height(self.preview_surface));
draw_rectangle_colour(1, window_get_height() - surface_get_height(self.preview_surface), surface_get_width(self.preview_surface), window_get_height() - 2, c_white, c_white, c_white, c_white, true);