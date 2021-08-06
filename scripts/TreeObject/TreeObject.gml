function TreeObject(model) constructor {
    var dist = random(500) + 100;
    var angle = random(2 * pi);
    self.x = dist * cos(angle);
    self.y = -dist * sin(angle);
    self.model = model;
    self.shape = NewColAABBFromMinMax(new Vector3(self.x - 8, self.y - 8, 0), new Vector3(self.x + 8, self.y + 8, 32));
}