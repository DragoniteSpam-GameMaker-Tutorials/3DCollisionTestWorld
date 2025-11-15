self.dbg_things_drawn_text = $"Things drawn: {self.things_drawn}/{self.tree_count} things in world";
self.dbg_frustum_time_text = $"Frustum time: {self.frustum_time} us";
self.dbg_fps_text = $"FPS: {fps}/{fps_real}";

self.history_buffer[# self.history_address, EHistoryBufferValues.FPS] = fps_real;
self.history_buffer[# self.history_address, EHistoryBufferValues.FRUSTUM_TIME] = self.frustum_time;
self.history_buffer[# self.history_address, EHistoryBufferValues.STEP_TIME] = self.dbg_player_step_time_value;
self.history_buffer[# self.history_address, EHistoryBufferValues.THINGS_DRAWN] = self.things_drawn;
self.history_address = ++self.history_address % ds_grid_width(self.history_buffer);
self.history_address_max = max(self.history_address, self.history_address_max);

if (self.draw_frustum_view) {
    var ww = surface_get_width(self.preview_surface);
    var hh = surface_get_height(self.preview_surface);
    var xx = 40;
    var yy = window_get_height() - hh - 40;
    draw_surface(self.preview_surface, xx, yy);
    draw_rectangle_colour(xx + 1, yy + 1, xx + ww, yy + hh, c_white, c_white, c_white, c_white, true);
}

if (self.draw_debug_graphs) {
    var n = ds_grid_width(self.history_buffer);
    
    var ww = n;
    var h_base = 220;
    var h_base_span = h_base - 40;
    var hh = h_base * 3;
    
    var xx = window_get_width() - ww - 40;
    var yy = window_get_height() - hh - 40;
    
    var yy_fps = yy + 40;
    var yy_frame_times = yy + h_base + 40;
    var yy_things = yy + h_base * 2 + 40;
    
    n = min(n, self.history_address_max);
    
    var fps_min = ds_grid_get_min(self.history_buffer, 0, EHistoryBufferValues.FPS, n, EHistoryBufferValues.FPS);
    var fps_max = ds_grid_get_max(self.history_buffer, 0, EHistoryBufferValues.FPS, n, EHistoryBufferValues.FPS);
    var frustum_min = ds_grid_get_min(self.history_buffer, 0, EHistoryBufferValues.FRUSTUM_TIME, n, EHistoryBufferValues.FRUSTUM_TIME);
    var frustum_max = ds_grid_get_max(self.history_buffer, 0, EHistoryBufferValues.FRUSTUM_TIME, n, EHistoryBufferValues.FRUSTUM_TIME);
    var step_min = ds_grid_get_min(self.history_buffer, 0, EHistoryBufferValues.STEP_TIME, n, EHistoryBufferValues.STEP_TIME);
    var step_max = ds_grid_get_max(self.history_buffer, 0, EHistoryBufferValues.STEP_TIME, n, EHistoryBufferValues.STEP_TIME);
    var things_min = ds_grid_get_min(self.history_buffer, 0, EHistoryBufferValues.THINGS_DRAWN, n, EHistoryBufferValues.THINGS_DRAWN);
    var things_max = ds_grid_get_max(self.history_buffer, 0, EHistoryBufferValues.THINGS_DRAWN, n, EHistoryBufferValues.THINGS_DRAWN);
    
    fps_min = floor(fps_min / 100) * 100;
    fps_max = ceil(fps_max / 100) * 100;
    
    var times_min = floor(min(frustum_min, step_min) / 100) * 100;
    var times_max = ceil(max(frustum_max, step_max) / 100) * 100;
    
    things_min = floor(things_min / 100) * 100;
    things_max = ceil(things_max / 100) * 100;
    
    draw_rectangle_colour(xx, yy, xx + ww, yy + hh, c_black, c_black, c_black, c_black, false);
    
    var fps_diff = fps_max - fps_min;
    var frustum_diff = frustum_max - frustum_min;
    var step_diff = step_max - step_min;
    var things_diff = things_max - things_min;
    
    var times_diff = times_max - times_min;
    
    var fps_last = undefined;
    var frustum_last = undefined;
    var step_last = undefined;
    var things_last = undefined;
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_bottom);
    draw_set_font(fnt_demo);
    draw_text_colour(xx + 10, yy_fps - 4, "FPS", c_fps, c_fps, c_fps, c_fps, 1);
    draw_text_colour(xx + 10, yy_frame_times - 4, "Frustum time", c_frustum, c_frustum, c_frustum, c_frustum, 1);
    draw_text_colour(xx + 10 + string_width("Frustum time") + 10, yy_frame_times - 4, "Step time", c_step, c_step, c_step, c_step, 1);
    draw_text_colour(xx + 10, yy_things - 4, "Things drawn", c_things, c_things, c_things, c_things, 1);
    
    draw_line_width_colour(xx, yy_fps, xx + ww, yy_fps, 3, c_white, c_white);
    draw_line_width_colour(xx, yy_fps + h_base_span, xx + ww, yy_fps + h_base_span, 3, c_white, c_white);
    
    draw_line_width_colour(xx, yy_frame_times, xx + ww, yy_frame_times, 3, c_white, c_white);
    draw_line_width_colour(xx, yy_frame_times + h_base_span, xx + ww, yy_frame_times + h_base_span, 3, c_white, c_white);
    
    draw_line_width_colour(xx, yy_things, xx + ww, yy_things, 3, c_white, c_white);
    draw_line_width_colour(xx, yy_things + h_base_span, xx + ww, yy_things + h_base_span, 3, c_white, c_white);
    
    for (var i = n - 1; i >= 0; i--) {
        var value_fps = self.history_buffer[# (i + self.history_address) % n, EHistoryBufferValues.FPS];
        var value_frustum = self.history_buffer[# (i + self.history_address) % n, EHistoryBufferValues.FRUSTUM_TIME];
        var value_step = self.history_buffer[# (i + self.history_address) % n, EHistoryBufferValues.STEP_TIME];
        var value_things = self.history_buffer[# (i + self.history_address) % n, EHistoryBufferValues.THINGS_DRAWN];
        
        var value_fps_y = yy_fps + h_base_span - ((value_fps - fps_min) / fps_diff) * h_base_span;
        var value_frustum_y = yy_frame_times + h_base_span - ((value_frustum - times_min) / times_diff) * h_base_span;
        var value_step_y = yy_frame_times + h_base_span - ((value_step - times_min) / times_diff) * h_base_span;
        var value_things_y = yy_things + h_base_span - ((value_things - things_min) / things_diff) * h_base_span;
        
        if (fps_diff == 0) value_fps_y = yy_fps + h_base / 2;
        if (times_diff == 0) value_frustum_y = yy_frame_times + h_base / 2;
        if (times_diff == 0) value_step_y = yy_frame_times + h_base / 2;
        if (things_diff == 0) value_things_y = yy_things + h_base / 2;
        
        if (fps_last != undefined) {
            draw_line_width_colour(xx + i - 1, fps_last, xx + i, value_fps_y, 2, c_fps, c_fps);
            draw_line_width_colour(xx + i - 1, frustum_last, xx + i, value_frustum_y, 2, c_frustum, c_frustum);
            draw_line_width_colour(xx + i - 1, step_last, xx + i, value_step_y, 2, c_step, c_step);
            draw_line_width_colour(xx + i - 1, things_last, xx + i, value_things_y, 2, c_things, c_things);
        }
        
        fps_last = value_fps_y;
        frustum_last = value_frustum_y;
        step_last = value_step_y;
        things_last = value_things_y;
    }
    
    draw_set_halign(fa_right);
    draw_text(xx + ww - 10, yy_fps - 4, fps_max);
    draw_text(xx + ww - 10, yy_fps + h_base_span - 4, fps_min);
    
    draw_text(xx + ww - 10, yy_frame_times - 4, $"{times_max} us");
    draw_text(xx + ww - 10, yy_frame_times + h_base_span - 4, $"{times_min} us");
    
    draw_text(xx + ww - 10, yy_things - 4, things_max);
    draw_text(xx + ww - 10, yy_things + h_base_span - 4, things_min);
    
    draw_rectangle_colour(xx, yy, xx + ww, yy + hh, c_white, c_white, c_white, c_white, true);
}

#macro c_fps c_lime
#macro c_frustum c_yellow
#macro c_step c_red
#macro c_things c_aqua