function TreeObject(model) constructor {
    var dist = random(1600) + 100;
    var angle = random(2 * pi);
    self.x = dist * cos(angle);
    self.y = -dist * sin(angle);
    self.model = model;
    self.shape = new ColAABB(new Vector3(self.x, self.y, 16), new Vector3(8, 8, 16));
    self.transform = matrix_build(self.x, self.y, 0, 0, 0, 0, 1, 1, 1);
}

function FloorObject(model) constructor {
    self.x = 0;
    self.y = 0;
    self.model = model;
    self.shape = new ColPlane(new Vector3(0, 0, 1), 0);
    self.transform = matrix_build(self.x, self.y, 0, 0, 0, 0, 1, 1, 1);
}

function PlayerObject() constructor {
    self.x = 50;
    self.y = 50;
    self.z = 0;
    self.zspeed = 0;
    self.direction = 0;
    self.pitch = -30;
    self.face_direction = 180;
    self.distance = 40;
    self.mouse_lock = true;
    self.frame = 0;
    self.shape = new ColSphere(new Vector3(self.x, self.y, 0 + 8), 8);
};

function BallObject(position, direction) constructor {
    self.position = position;
    self.direction = direction;
    
    static Update = function() {
        var ray = new ColRay(self.position, self.direction);
        var raycast_result = obj_camera.collision_world.CheckRay(ray);
        
        if (raycast_result != undefined) {
            if (raycast_result.distance < self.direction.Magnitude()) {
                self.position = raycast_result.point;
                self.direction = new Vector3(0, 0, 0);
            } else {
                self.position = self.position.Add(self.direction);
            }
        } else {
            self.position = self.position.Add(self.direction);
        }
    };
}