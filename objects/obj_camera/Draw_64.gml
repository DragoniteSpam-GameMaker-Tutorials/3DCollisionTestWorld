draw_text(32, 64, "Is ghost: " + string(self.player.is_ghost));
draw_text(32, 80, "Things drawn: " + string(self.things_drawn));

draw_surface(self.preview_surface, 0, window_get_height() - surface_get_height(self.preview_surface));
draw_rectangle_colour(1, window_get_height() - surface_get_height(self.preview_surface), surface_get_width(self.preview_surface), window_get_height() - 2, c_white, c_white, c_white, c_white, true);