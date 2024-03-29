/// @description Insert description here

with (player) {
    if (mouse_lock) {
        #region regular movement
        direction -= (window_mouse_get_x() - window_get_width() / 2) / 10;
        pitch -= (window_mouse_get_y() - window_get_height() / 2) / 10;
        pitch = clamp(pitch, -85, 85);
        
        window_mouse_set(window_get_width() / 2, window_get_height() / 2);
        
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
        
        shape.position = shape.position.Add(new Vector3(dx, dy, zspeed));
        
        var displaced_location = obj_camera.collision_world.DisplaceSphere(self.object);
        if (displaced_location != undefined) {
            shape.position = displaced_location;
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
        
        if (mouse_check_button_pressed(mb_left)) {
            obj_camera.ball = new BallObject(
                new Vector3(self.x, self.y, self.z),
                new Vector3(-4 * dcos(self.direction) * dcos(self.pitch), -4 * -dsin(self.direction) * dcos(self.pitch), max(0, 4 * dsin(self.pitch)))
            );
        }
    }
    
    if (keyboard_check_pressed(vk_tab)) {
        mouse_lock = !mouse_lock;
    }
    
    if (keyboard_check_pressed(vk_enter)) {
        self.is_ghost = !self.is_ghost;
        if (self.is_ghost) {
            self.object.group = COLLISION_GROUP_GHOST;
        } else {
            self.object.group = COLLISION_GROUP_PLAYER;
        }
    }
}

if (keyboard_check_pressed(ord("Z"))) {
    draw_debug_shapes = !draw_debug_shapes;
}

if (self.ball) {
    self.ball.Update();
}