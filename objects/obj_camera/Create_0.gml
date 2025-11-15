#macro BUILD_FOR_WEB                    (os_browser != browser_not_a_browser)

#macro COLLISION_GROUP_PLAYER           0x01
#macro COLLISION_GROUP_BALL             0x02
#macro COLLISION_GROUP_GHOST            0x04

self.preview_surface = -1;
self.things_drawn = 0;
self.frustum_time = 0;

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_texcoord();
vertex_format_add_colour();
format = vertex_format_end();

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

enum EWorldTypes {
    QUADTREE,
    OCTREE
}

self.tree_count = (BUILD_FOR_WEB ? 1500 : 2000);
self.tree_count_last = self.tree_count;
self.world_setup_time = 0;
self.tree_count_last_update = -1000;
self.world_type = EWorldTypes.OCTREE;
self.world_type_last = self.world_type;
self.world_partition_depth = 3;
self.world_partition_depth_last = self.world_partition_depth;
self.world_partition_depth_last_update = -1000;
self.world_partition_depth_live = self.world_partition_depth;

self.SpawnTrees = function(tree_count, type, depth) {
    self.tree_count = tree_count;
    self.world_partition_depth_live = depth;
    
    var bounds = NewColAABBFromMinMax(new Vector3(-2000, -2000, -25), new Vector3(2000, 2000, 250));
    var quadtree = new ColWorldQuadtree(bounds, 3);
    var octree = new ColWorldOctree(bounds, 3);
    var sph = new ColWorldSpatialHash(32);
    
    switch (type) {
    case EWorldTypes.QUADTREE:
        collision_world = new ColWorld(quadtree);
        break;
    case EWorldTypes.OCTREE:
        collision_world = new ColWorld(octree);
        break;
    }
    
    var t0 = get_timer();
    tree_objects = array_create(tree_count);
    tree_objects[0] = new FloorObject(vb_floor);

    collision_world.Add(new ColObject(tree_objects[0].shape, tree_objects[0], COLLISION_GROUP_PLAYER | COLLISION_GROUP_BALL | COLLISION_GROUP_GHOST));
    
    random_set_seed(1337);
    for (var i = 1; i < tree_count; i++) {
        tree = new TreeObject(tree_models[irandom(array_length(tree_models) - 1)]);
        tree_objects[i] = tree;
        collision_world.Add(new ColObject(tree.shape, tree, COLLISION_GROUP_PLAYER | COLLISION_GROUP_BALL));
    }
    var t1 = get_timer();
    self.world_setup_time = (t1 - t0) / 1000;
    self.dbg_setup_time_text = $"Setup time: {self.world_setup_time} ms";
}

self.SpawnTrees(self.tree_count, self.world_type, self.world_partition_depth);
// if you bring this back you need to add it to SpawnTrees too
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
draw_frustum_view = false;
self.draw_debug_graphs = false;
#endregion

ball = undefined;

window_mouse_set_locked(true);

font_enable_effects(fnt_demo, true, {
    outlineEnable: true,
    outlineDistance: 2,
    outlineColour: c_black,
    outlineAlpha: 1
});

self.dbg_setup_time_text = $"Setup time: {self.world_setup_time} ms";
self.dbg_things_drawn_text = "";
self.dbg_frustum_time_text = "";
self.dbg_player_step_time_text = "";
self.dbg_fps_text = "";

self.dbg_player_step_time_value = 0;

enum EHistoryBufferValues {
    FPS,
    FRUSTUM_TIME,
    STEP_TIME,
    THINGS_DRAWN
}

self.history_buffer = ds_grid_create(300, 4);
self.history_address = 0;
self.history_address_max = 0;

dbg_view("General", true, -1, -1, 400, 320);
dbg_text(ref_create(self, "dbg_setup_time_text"));
dbg_text(ref_create(self, "dbg_things_drawn_text"));
dbg_text(ref_create(self, "dbg_frustum_time_text"));
dbg_text(ref_create(self, "dbg_player_step_time_text"));
dbg_text(ref_create(self, "dbg_fps_text"));

dbg_text("Press Tab to toggle mouse lock");
dbg_text("Press T to throw a ball");

dbg_checkbox(ref_create(self, "draw_debug_shapes"), "Draw collision shapes (C)")
dbg_checkbox(ref_create(self, "draw_frustum_view"), "Culling visualization (F)")
dbg_checkbox(ref_create(self, "draw_debug_graphs"), "Performance readouts")

dbg_slider_int(ref_create(self, "tree_count"), 500, 5000);
dbg_drop_down(ref_create(self, "world_type"), "Quadtree:0,Octree:1");
dbg_slider_int(ref_create(self, "world_partition_depth"), 0, 4);
