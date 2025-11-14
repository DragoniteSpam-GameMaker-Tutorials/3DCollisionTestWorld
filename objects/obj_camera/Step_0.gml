if (self.tree_count_last != self.tree_count) {
    self.tree_count_last = self.tree_count;
    self.tree_count_last_update = current_time;
}

if (array_length(self.tree_objects) != self.tree_count) {
    if (current_time - self.tree_count_last_update > 500) {
        self.SpawnTrees(self.tree_count);
    }
}

with (player) {
    if (window_mouse_get_locked()) {
        #region regular movement
        direction -= window_mouse_get_delta_x() / 10;
        pitch -= window_mouse_get_delta_y() / 10;
        pitch = clamp(pitch, -85, 85);
        
        if (keyboard_check_direct(vk_escape)) {
            game_end();
        }
        
        var move_speed = 1;
        var dx = 0;
        var dy = 0;
        
        var xlast = x;
        var ylast = y;
        
        if (keyboard_check(ord("A"))) {
            dx += dsin(direction) * move_speed;
            dy += dcos(direction) * move_speed;
        }
        
        if (keyboard_check(ord("D"))) {
            dx -= dsin(direction) * move_speed;
            dy -= dcos(direction) * move_speed;
        }
        
        if (keyboard_check(ord("W"))) {
            dx -= dcos(direction) * move_speed;
            dy += dsin(direction) * move_speed;
        }
        
        if (keyboard_check(ord("S"))) {
            dx += dcos(direction) * move_speed;
            dy -= dsin(direction) * move_speed;
        }
        
        if (keyboard_check_pressed(vk_space)) {
            zspeed = 2;
        }
        
        zspeed -= 0.075;
        
        shape.Set(shape.position.Add(new Vector3(dx, dy, zspeed)));
        
        var displaced_location = obj_camera.collision_world.DisplaceSphere(self.object);
        if (displaced_location != undefined) {
            shape.Set(displaced_location);
        }
        
        self.x = self.shape.position.x;
        self.y = self.shape.position.y;
        self.z = self.shape.position.z - 8;
        
        shape.position.z -= 0.01;
        
        if (obj_camera.collision_world.CheckObject(self.object)) {
            zspeed = 0;
        }
        
        shape.position.z += 0.01;
        
        if (point_distance(xlast, ylast, x, y) > 0.01) {
            frame = (frame + 0.075) % 3;
            face_direction = point_direction(xlast, ylast, x, y);
        } else {
            frame = 0;
        }
        
        if (mouse_wheel_up()) {
            distance = max(40, distance - 5);
        }
        if (mouse_wheel_down()) {
            distance = min(160, distance + 5);
        }
        #endregion
        
        if (keyboard_check_pressed(ord("T"))) {
            var velocity = 1;
            var xto = self.x;
            var yto = self.y;
            var zto = self.z + 16;
            var xfrom = xto + self.distance * dcos(self.direction) * dcos(self.pitch);
            var yfrom = yto - self.distance * dsin(self.direction) * dcos(self.pitch);
            var zfrom = zto - self.distance * dsin(self.pitch);
            obj_camera.ball = new BallObject(
                new Vector3(self.x, self.y, self.z),
                new Vector3(xto - xfrom, yto - yfrom, 0).Normalize().Mul(velocity)
            );
        }
    }
    
    if (keyboard_check_pressed(vk_tab)) {
        window_mouse_set_locked(!window_mouse_get_locked());
    }
}

if (keyboard_check_pressed(ord("C"))) {
    draw_debug_shapes = !draw_debug_shapes;
}

if (keyboard_check_pressed(ord("F"))) {
    draw_frustum_view = !draw_frustum_view;
}

if (self.ball) {
    self.ball.Update();
    if ((current_time - self.ball.time) > 30_000) {
        self.ball = undefined;
    }
}

var ww = os_browser == browser_not_a_browser ? window_get_width() : display_get_width();
var hh = os_browser == browser_not_a_browser ? window_get_height() : display_get_height();

if (surface_get_width(application_surface) != ww || surface_get_height(application_surface) != hh) {
    surface_resize(application_surface, ww, hh);
}

display_set_gui_size(ww, hh);