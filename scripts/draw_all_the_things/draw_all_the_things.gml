function draw_all_the_things(objects) {
    gpu_set_cullmode(cull_counterclockwise);
    gpu_set_zwriteenable(true);
    gpu_set_ztestenable(true);
    shader_set(shd_demo);
    draw_clear(c_black);

    vertex_submit(vb_floor, pr_trianglelist, -1);

    var duck_angle = ((player.direction - player.face_direction) + 360) % 360;
    if (duck_angle >= 310 || duck_angle < 50) {
        var zrot = 90;
        var spr = duck_front;
    } else if (duck_angle >= 230) {
        var zrot = 0;
        var spr = duck_right;
    } else if (duck_angle >= 130) {
        var zrot = 90;
        var spr = duck_back;
    } else if (duck_angle >= 50) {
        var zrot = 180;
        var spr = duck_left;
    }

    matrix_set(matrix_world, matrix_build(player.x, player.y, player.z, 0, 0, player.face_direction + zrot, 1, 1, 1));
    vertex_submit(vb_player, pr_trianglelist, sprite_get_texture(spr, floor(player.frame)));
    if (draw_debug_shapes) {
        vertex_submit(vb_collision_sphere, pr_trianglelist, -1);
    }

    var cutoff = dcos(60);
    self.things_drawn = 0;
    
    for (var i = 0, n = array_length(objects); i < n; i++) {
        var tree = objects[i]//.reference;
        matrix_set(matrix_world, tree.transform);
        vertex_submit(tree.model, pr_trianglelist, -1);
        self.things_drawn++;
        if (self.draw_debug_shapes && i > 0) {
            vertex_submit(vb_collision_block, pr_trianglelist, -1);
        }
    }

    if (self.ball != undefined) {
        matrix_set(matrix_world, matrix_build(self.ball.position.x, self.ball.position.y, self.ball.position.z, 0, 0, 0, 0.25, 0.25, 0.25));
        vertex_submit(self.vb_collision_sphere, pr_trianglelist, -1);
        matrix_set(matrix_world, matrix_build_identity());
    }
    
    gpu_set_cullmode(cull_noculling);
    shader_reset();
    matrix_set(matrix_world, matrix_build_identity());
    
    gpu_set_zwriteenable(false);
    gpu_set_ztestenable(false);
}