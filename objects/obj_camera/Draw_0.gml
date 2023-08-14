var xto = player.x;
var yto = player.y;
var zto = player.z + 16;
var xfrom = xto + player.distance * dcos(player.direction) * dcos(player.pitch);
var yfrom = yto - player.distance * dsin(player.direction) * dcos(player.pitch);
var zfrom = zto - player.distance * dsin(player.pitch);

view_mat = matrix_build_lookat(xfrom, yfrom, zfrom, xto, yto, zto, 0, 0, 1);
proj_mat = matrix_build_projection_perspective_fov(-60, -16 / 9, 1, 800);

var cam = camera_get_active();
camera_set_view_mat(cam, view_mat);
camera_set_proj_mat(cam, proj_mat);
camera_apply(cam);

draw_all_the_things(view_mat, proj_mat);

return;

if (!surface_exists(self.preview_surface)) {
    self.preview_surface = surface_create(480, 320);
}

surface_set_target(self.preview_surface);
draw_clear(c_black);
var d = 1600;
camera_set_view_mat(cam, matrix_build_lookat(d * dcos(current_time / 100), -d * dsin(current_time / 100), 500, 0, 0, 0, 0, 0, 1));
camera_set_proj_mat(cam, matrix_build_projection_perspective_fov(-60, -480 / 320, 1, 10000));
camera_apply(cam);

draw_all_the_things(view_mat, proj_mat);

surface_reset_target();
/*
if (keyboard_check(vk_f1)) {
    obj_camera.collision_world.DebugDraw();
}
*/