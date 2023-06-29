draw_text(32, 64, "Is ghost: " + string(self.player.is_ghost));

draw_surface(self.preview_surface, 0, window_get_height() - surface_get_height(self.preview_surface));