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
        
        shape.position.x = (x + dx);
        for (var i = 0; i < TREE_COUNT; i++) {
            var tree = obj_camera.tree_objects[i];
            if (tree.shape.CheckSphere(shape)) {
                dx = 0;
                break;
            }
        }
        
        x += dx;
        shape.position.x = x;
        
        shape.position.y = (y + dy);
        for (var i = 0; i < TREE_COUNT; i++) {
            var tree = obj_camera.tree_objects[i];
            if (tree.shape.CheckSphere(shape)) {
                dy = 0;
                break;
            }
        }
        
        y += dy;
        shape.position.y = y;
        
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
    }
    
    if (keyboard_check_pressed(vk_tab)) {
        mouse_lock = !mouse_lock;
    }
}

if (keyboard_check_pressed(ord("Z"))) {
    draw_debug_shapes = !draw_debug_shapes;
}