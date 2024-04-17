var xto = player.x;
var yto = player.y;
var zto = player.z + 16;
var xfrom = xto + player.distance * dcos(player.direction) * dcos(player.pitch);
var yfrom = yto - player.distance * dsin(player.direction) * dcos(player.pitch);
var zfrom = zto - player.distance * dsin(player.pitch);

view_mat = matrix_build_lookat(xfrom, yfrom, zfrom, xto, yto, zto, 0, 0, 1);
proj_mat = matrix_build_projection_perspective_fov(-60, -16 / 9, 1, 800);

var t = get_timer();
var frustum = new ColCameraFrustum(view_mat, proj_mat);
var objects = self.collision_world.GetObjectsInFrustum(frustum);
show_debug_message($"Getting all the things in the frustum took {(get_timer() - t) / 1000} ms");

var cam = camera_get_active();
camera_set_view_mat(cam, view_mat);
camera_set_proj_mat(cam, proj_mat);
camera_apply(cam);

draw_all_the_things(objects);

if (!surface_exists(self.preview_surface)) {
    self.preview_surface = surface_create(360, 240);
}

if (draw_frustum_view) {
    surface_set_target(self.preview_surface);
    draw_clear(c_black);
    var d = 1600;
    camera_set_view_mat(cam, matrix_build_lookat(d * dcos(current_time / 100), -d * dsin(current_time / 100), 500, 0, 0, 0, 0, 0, 1));
    camera_set_proj_mat(cam, matrix_build_projection_perspective_fov(-60, -360 / 240, 1, 10000));
    camera_apply(cam);
    draw_all_the_things(objects);
    surface_reset_target();
}