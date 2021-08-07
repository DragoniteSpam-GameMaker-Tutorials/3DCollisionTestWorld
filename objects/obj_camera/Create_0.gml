vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_texcoord();
vertex_format_add_colour();
format = vertex_format_end();

show_debug_overlay(true);

#region floor
var x1 = -10000;
var y1 = -10000;
var x2 = 10000;
var y2 = 10000;

vb_floor = vertex_create_buffer();
vertex_begin(vb_floor, format);

vertex_position_3d(vb_floor, x1, y1, 0);
vertex_normal(vb_floor, 0, 0, 1);
vertex_texcoord(vb_floor, 0, 0);
vertex_colour(vb_floor, c_green, 1);

vertex_position_3d(vb_floor, x2, y1, 0);
vertex_normal(vb_floor, 0, 0, 1);
vertex_texcoord(vb_floor, 0, 0);
vertex_colour(vb_floor, c_green, 1);

vertex_position_3d(vb_floor, x2, y2, 0);
vertex_normal(vb_floor, 0, 0, 1);
vertex_texcoord(vb_floor, 0, 0);
vertex_colour(vb_floor, c_green, 1);

vertex_position_3d(vb_floor, x2, y2, 0);
vertex_normal(vb_floor, 0, 0, 1);
vertex_texcoord(vb_floor, 0, 0);
vertex_colour(vb_floor, c_green, 1);

vertex_position_3d(vb_floor, x1, y2, 0);
vertex_normal(vb_floor, 0, 0, 1);
vertex_texcoord(vb_floor, 0, 0);
vertex_colour(vb_floor, c_green, 1);

vertex_position_3d(vb_floor, x1, y1, 0);
vertex_normal(vb_floor, 0, 0, 1);
vertex_texcoord(vb_floor, 0, 0);
vertex_colour(vb_floor, c_green, 1);

vertex_end(vb_floor);
#endregion

#region trees
var data = buffer_load("tree_simple.vbuff");
vb_tree_simple = vertex_create_buffer_from_buffer(data, format);
buffer_delete(data);

var data = buffer_load("tree_cone.vbuff");
vb_tree_cone = vertex_create_buffer_from_buffer(data, format);
buffer_delete(data);

var data = buffer_load("tree_cone_dark.vbuff");
vb_tree_cone_dark = vertex_create_buffer_from_buffer(data, format);
buffer_delete(data);

var data = buffer_load("tree_detailed.vbuff");
vb_tree_detailed = vertex_create_buffer_from_buffer(data, format);
buffer_delete(data);

var data = buffer_load("tree_fat.vbuff");
vb_tree_fat = vertex_create_buffer_from_buffer(data, format);
buffer_delete(data);

var data = buffer_load("tree_fat_dark.vbuff");
vb_tree_fat_dark = vertex_create_buffer_from_buffer(data, format);
buffer_delete(data);

var data = buffer_load("tree_plateau.vbuff");
vb_tree_plateau = vertex_create_buffer_from_buffer(data, format);
buffer_delete(data);

var data = buffer_load("tree_plateau_dark.vbuff");
vb_tree_plateau_dark = vertex_create_buffer_from_buffer(data, format);
buffer_delete(data);

tree_models = [
    vb_tree_simple, vb_tree_cone, vb_tree_cone_dark, vb_tree_detailed,
    vb_tree_fat, vb_tree_fat_dark, vb_tree_plateau, vb_tree_plateau_dark
];

#macro TREE_COUNT 250

tree_objects = array_create(TREE_COUNT);
tree_objects[0] = new FloorObject(vb_floor);
for (var i = 1; i < TREE_COUNT; i++) {
    tree_objects[i] = new TreeObject(tree_models[irandom(array_length(tree_models) - 1)]);
}
#endregion

#region player
player = {
    x: 0, y: 0, z: 0,
    zspeed: 0,
    direction: 0, pitch: -30, face_direction: 180,
    distance: 40,
    mouse_lock: true,
    frame: 0,
    shape: new ColSphere(new Vector3(0, 0, 0 + 8), 8),
};

var data = buffer_load("player.vbuff");
vb_player = vertex_create_buffer_from_buffer(data, format);
buffer_delete(data);
#endregion

#region debug draw
var data = buffer_load("collision_sphere.vbuff");
vb_collision_sphere = vertex_create_buffer_from_buffer(data, format);
buffer_delete(data);

var data = buffer_load("collision_block.vbuff");
vb_collision_block = vertex_create_buffer_from_buffer(data, format);
buffer_delete(data);

draw_debug_shapes = false;
#endregion

window_mouse_set(window_get_width() / 2, window_get_height() / 2);