var cam = camera_get_active();
var xto = player.x;
var yto = player.y;
var zto = player.z + 16;
var xfrom = xto + player.distance * dcos(player.direction) * dcos(player.pitch);
var yfrom = yto - player.distance * dsin(player.direction) * dcos(player.pitch);
var zfrom = zto - player.distance * dsin(player.pitch);

view_mat = matrix_build_lookat(xfrom, yfrom, zfrom, xto, yto, zto, 0, 0, 1);
proj_mat = matrix_build_projection_perspective_fov(-60, -16 / 9, 1, 10000);
camera_set_view_mat(cam, view_mat);
camera_set_proj_mat(cam, proj_mat);
camera_apply(cam);

gpu_set_cullmode(cull_counterclockwise);
gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);
shader_set(shd_demo);

vertex_submit(vb_floor, pr_trianglelist, -1);

var duck_angle = ((player.direction - player.face_direction) + 360) % 360;
if (duck_angle >= 315 || duck_angle < 45) {
    var zrot = 90;
    var spr = duck_front;
} else if (duck_angle >= 225) {
    var zrot = 0;
    var spr = duck_right;
} else if (duck_angle >= 135) {
    var zrot = 90;
    var spr = duck_back;
} else if (duck_angle >= 45) {
    var zrot = 180;
    var spr = duck_left;
}

matrix_set(matrix_world, matrix_build(player.x, player.y, player.z, 0, 0, player.face_direction + zrot, 1, 1, 1));
vertex_submit(vb_player, pr_trianglelist, sprite_get_texture(spr, floor(player.frame)));
if (draw_debug_shapes) {
    vertex_submit(vb_collision_sphere, pr_trianglelist, -1);
}

var cutoff = dcos(60);

for (var i = 0,n = array_length(self.tree_objects); i < n; i++) {
    var tree = self.tree_objects[i];
    if (dot_product_normalized(xto - xfrom, yto - yfrom, tree.x - xfrom, tree.y - yfrom) > cutoff || point_distance(self.x, self.y, tree.x, tree.y) < 50) {
        matrix_set(matrix_world, tree.transform);
        vertex_submit(tree.model, pr_trianglelist, -1);
        if (draw_debug_shapes && i > 0) {
            vertex_submit(vb_collision_block, pr_trianglelist, -1);
        }
    }
}

if (self.ball != undefined) {
    matrix_set(matrix_world, matrix_build(self.ball.position.x, self.ball.position.y, self.ball.position.z, 0, 0, 0, 0.25, 0.25, 0.25));
    vertex_submit(self.vb_collision_sphere, pr_trianglelist, -1);
    matrix_set(matrix_world, matrix_build_identity());
}

gpu_set_cullmode(cull_noculling);
gpu_set_zwriteenable(false);
gpu_set_ztestenable(false);
shader_reset();
matrix_set(matrix_world, matrix_build_identity());