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