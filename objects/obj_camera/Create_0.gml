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

var bounds = NewColAABBFromMinMax(new Vector3(-2000, -2000, -25), new Vector3(2000, 2000, 250));
var quadtree = new ColWorldQuadtree(bounds, 3);
var octree = new ColWorldOctree(bounds, 3);
var sph = new ColWorldSpatialHash(32);
collision_world = new ColWorld(quadtree);

#region floor
var x1 = -10000;
var y1 = -10000;
var x2 = 10000;
var y2 = 10000;

vb_floor = vertex_create_buffer();
vertex_begin(vb_floor, format);
vertex_position_3d(vb_floor, x1, y1, 0); vertex_normal(vb_floor, 0, 0, 1); vertex_texcoord(vb_floor, 0, 0); vertex_colour(vb_floor, c_green, 1);
vertex_position_3d(vb_floor, x2, y1, 0); vertex_normal(vb_floor, 0, 0, 1); vertex_texcoord(vb_floor, 0, 0); vertex_colour(vb_floor, c_green, 1);
vertex_position_3d(vb_floor, x2, y2, 0); vertex_normal(vb_floor, 0, 0, 1); vertex_texcoord(vb_floor, 0, 0); vertex_colour(vb_floor, c_green, 1);
vertex_position_3d(vb_floor, x2, y2, 0); vertex_normal(vb_floor, 0, 0, 1); vertex_texcoord(vb_floor, 0, 0); vertex_colour(vb_floor, c_green, 1);
vertex_position_3d(vb_floor, x1, y2, 0); vertex_normal(vb_floor, 0, 0, 1); vertex_texcoord(vb_floor, 0, 0); vertex_colour(vb_floor, c_green, 1);
vertex_position_3d(vb_floor, x1, y1, 0); vertex_normal(vb_floor, 0, 0, 1); vertex_texcoord(vb_floor, 0, 0); vertex_colour(vb_floor, c_green, 1);
vertex_end(vb_floor);
#endregion

#region trees
var load = function(name, format) {
    var data = buffer_load(name);
    var vb = vertex_create_buffer_from_buffer(data, format);
    vertex_freeze(vb);
    buffer_delete(data);
    return vb;
};

vb_tree_simple = load("tree_simple.vbuff", format);
vb_tree_cone = load("tree_cone.vbuff", format);
vb_tree_cone_dark = load("tree_cone_dark.vbuff", format);
vb_tree_detailed = load("tree_detailed.vbuff", format);
vb_tree_fat = load("tree_fat.vbuff", format);
vb_tree_fat_dark = load("tree_fat_dark.vbuff", format);
vb_tree_plateau_dark = load("tree_plateau_dark.vbuff", format);

var data = buffer_load("tree_plateau.vbuff");
vb_tree_plateau = vertex_create_buffer_from_buffer(data, format);
vertex_freeze(vb_tree_plateau);

vb_tree_plateau_data = array_create(buffer_get_size(data) / (36 * 3));

var index = 0;
for (var i = 0, n = buffer_get_size(data); i < n; i += 36 * 3) {
    vb_tree_plateau_data[index++] = new ColTriangle(
        new Vector3(buffer_peek(data, i +  0, buffer_f32), buffer_peek(data, i +  4, buffer_f32), buffer_peek(data, i +  8, buffer_f32)),
        new Vector3(buffer_peek(data, i + 36, buffer_f32), buffer_peek(data, i + 40, buffer_f32), buffer_peek(data, i + 44, buffer_f32)),
        new Vector3(buffer_peek(data, i + 72, buffer_f32), buffer_peek(data, i + 76, buffer_f32), buffer_peek(data, i + 80, buffer_f32)),
    );
}

buffer_delete(data);

tree_models = [
    vb_tree_simple, vb_tree_cone, vb_tree_cone_dark, vb_tree_detailed,
    vb_tree_fat, vb_tree_fat_dark, vb_tree_plateau, vb_tree_plateau_dark
];

#macro TREE_COUNT 2000
#macro web:TREE_COUNT 1500

var t0 = get_timer();
tree_objects = array_create(TREE_COUNT);
tree_objects[0] = new FloorObject(vb_floor);

collision_world.Add(new ColObject(tree_objects[0].shape, tree_objects[0], COLLISION_GROUP_PLAYER | COLLISION_GROUP_BALL | COLLISION_GROUP_GHOST));

for (var i = 1; i < TREE_COUNT; i++) {
    tree = new TreeObject(tree_models[irandom(array_length(tree_models) - 1)]);
    tree_objects[i] = tree;
    collision_world.Add(new ColObject(tree.shape, tree, COLLISION_GROUP_PLAYER | COLLISION_GROUP_BALL));
}
/*
tree_mesh = new TreeObject(vb_tree_plateau);
tree_mesh.x = 0;
tree_mesh.y = 0;
tree_mesh.shape = new ColMesh(vb_tree_plateau_data);
tree_mesh.transform = matrix_build(0, 0, 0, 0, 0, 0, 1, 1, 1);
array_push(tree_objects, tree_mesh)
collision_world.Add(new ColObject(tree_mesh.shape, tree_mesh, COLLISION_GROUP_BALL));
*/
#endregion

#region player
player = new PlayerObject();
player.object = new ColObject(player.shape, player, COLLISION_GROUP_PLAYER | COLLISION_GROUP_BALL, COLLISION_GROUP_PLAYER);

vb_player = load("player.vbuff", format);
#endregion

#region debug draw
vb_collision_sphere = load("collision_sphere.vbuff", format);
vb_collision_block = load("collision_block.vbuff", format);

draw_debug_shapes = false;
draw_frustum_view = true;
#endregion

ball = undefined;

var t1 = get_timer();
setup_time = (t1 - t0) / 1000;
show_debug_message($"adding all the things took {setup_time} ms");

window_mouse_set_locked(true);

font_enable_effects(fnt_demo, true, {
    outlineEnable: true,
    outlineDistance: 2,
    outlineColour: c_black,
    outlineAlpha: 1
});