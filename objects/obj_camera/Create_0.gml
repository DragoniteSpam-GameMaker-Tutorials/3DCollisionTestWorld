#macro COLLISION_GROUP_PLAYER           0x01
#macro COLLISION_GROUP_BALL             0x02
#macro COLLISION_GROUP_GHOST            0x04

self.preview_surface = -1;
self.things_drawn = 0;

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_texcoord();
vertex_format_add_colour();
format = vertex_format_end();

//show_debug_overlay(true);

var bounds = NewColAABBFromMinMax(new Vector3(-2000, -2000, 0), new Vector3(2000, 2000, 250));
var quadtree = new ColWorldQuadtree(bounds, 3);
collision_world = new ColWorld(quadtree);

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
vertex_freeze(vb_tree_simple);
buffer_delete(data);

var data = buffer_load("tree_cone.vbuff");
vb_tree_cone = vertex_create_buffer_from_buffer(data, format);
vertex_freeze(vb_tree_cone);
buffer_delete(data);

var data = buffer_load("tree_cone_dark.vbuff");
vb_tree_cone_dark = vertex_create_buffer_from_buffer(data, format);
vertex_freeze(vb_tree_cone_dark);
buffer_delete(data);

var data = buffer_load("tree_detailed.vbuff");
vb_tree_detailed = vertex_create_buffer_from_buffer(data, format);
vertex_freeze(vb_tree_detailed);
buffer_delete(data);

var data = buffer_load("tree_fat.vbuff");
vb_tree_fat = vertex_create_buffer_from_buffer(data, format);
vertex_freeze(vb_tree_fat);
buffer_delete(data);

var data = buffer_load("tree_fat_dark.vbuff");
vb_tree_fat_dark = vertex_create_buffer_from_buffer(data, format);
vertex_freeze(vb_tree_fat_dark);
buffer_delete(data);

var data = buffer_load("tree_plateau.vbuff");
vb_tree_plateau = vertex_create_buffer_from_buffer(data, format);
vertex_freeze(vb_tree_plateau);

vb_tree_plateau_data = [];

for (var i = 0; i < buffer_get_size(data); i += 36 * 3) {
    array_push(vb_tree_plateau_data,
        new ColTriangle(
            new Vector3(buffer_peek(data, i +  0, buffer_f32), buffer_peek(data, i +  4, buffer_f32), buffer_peek(data, i +  8, buffer_f32)),
            new Vector3(buffer_peek(data, i + 36, buffer_f32), buffer_peek(data, i + 40, buffer_f32), buffer_peek(data, i + 44, buffer_f32)),
            new Vector3(buffer_peek(data, i + 72, buffer_f32), buffer_peek(data, i + 76, buffer_f32), buffer_peek(data, i + 80, buffer_f32)),
        )
    );
}

buffer_delete(data);

var data = buffer_load("tree_plateau_dark.vbuff");
vb_tree_plateau_dark = vertex_create_buffer_from_buffer(data, format);
vertex_freeze(vb_tree_plateau_dark);
buffer_delete(data);

tree_models = [
    vb_tree_simple, vb_tree_cone, vb_tree_cone_dark, vb_tree_detailed,
    vb_tree_fat, vb_tree_fat_dark, vb_tree_plateau, vb_tree_plateau_dark
];

#macro TREE_COUNT 3000

var t0 = get_timer();
window_set_fullscreen(true)
surface_resize(application_surface, window_get_width(), window_get_height())

tree_objects = array_create(TREE_COUNT);
tree_objects[0] = new FloorObject(vb_floor);

collision_world.Add(new ColObject(tree_objects[0].shape, tree_objects[0], COLLISION_GROUP_PLAYER | COLLISION_GROUP_BALL | COLLISION_GROUP_GHOST));

for (var i = 1; i < TREE_COUNT; i++) {
    tree = new TreeObject(tree_models[irandom(array_length(tree_models) - 1)]);
    tree_objects[i] = tree;
    collision_world.Add(new ColObject(tree.shape, tree, COLLISION_GROUP_PLAYER | COLLISION_GROUP_BALL));
}

tree_mesh = new TreeObject(vb_tree_plateau);
tree_mesh.x = 0;
tree_mesh.y = 0;
tree_mesh.shape = new ColMesh(vb_tree_plateau_data);
tree_mesh.transform = matrix_build(0, 0, 0, 0, 0, 0, 1, 1, 1);
array_push(tree_objects, tree_mesh)
collision_world.Add(new ColObject(tree_mesh.shape, tree_mesh, COLLISION_GROUP_BALL));

#endregion

#region player
player = new PlayerObject();
player.object = new ColObject(player.shape, player, COLLISION_GROUP_PLAYER | COLLISION_GROUP_BALL, COLLISION_GROUP_PLAYER);

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

ball = undefined;
#endregion

var t1 = get_timer();
show_debug_message($"adding all the things took {(t1 - t0) / 1000} ms");

window_mouse_set(window_get_width() / 2, window_get_height() / 2);