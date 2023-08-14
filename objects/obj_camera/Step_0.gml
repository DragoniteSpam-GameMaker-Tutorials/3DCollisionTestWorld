/// @description Insert description here

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
            obj_camera.ball = new BallObject(
                new Vector3(self.x, self.y, self.z),
                new Vector3(-4 * dcos(self.direction) * dcos(self.pitch), -4 * -dsin(self.direction) * dcos(self.pitch), max(0, 4 * dsin(self.pitch)))
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
}

var ww = window_get_width();
var hh = window_get_height();

if (surface_get_width(application_surface) != ww || surface_get_height(application_surface) != hh) {
    surface_resize(application_surface, ww, hh);
}