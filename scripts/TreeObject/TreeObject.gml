function TreeObject(model) constructor {
    var dist = random(500) + 100;
    var angle = random(2 * pi);
    self.x = dist * cos(angle);
    self.y = -dist * sin(angle);
    self.model = model;
    self.shape = NewColAABBFromMinMax(new Vector3(self.x - 8, self.y - 8, 0), new Vector3(self.x + 8, self.y + 8, 32));
}

function FloorObject(model) constructor {
    self.x = 0;
    self.y = 0;
    self.model = model;
    self.shape = new ColPlane(new Vector3(0, 0, 1), 0);
}