draw_text(32, 32, $"Setup time: {self.setup_time}, ms things drawn: {self.things_drawn}/{TREE_COUNT}, world type: {instanceof(self.collision_world.accelerator)}");

draw_surface(self.preview_surface, 0, window_get_height() - surface_get_height(self.preview_surface));
draw_rectangle_colour(1, window_get_height() - surface_get_height(self.preview_surface), surface_get_width(self.preview_surface), window_get_height() - 2, c_white, c_white, c_white, c_white, true);