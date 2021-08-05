function TreeObject(model) constructor {
    var dist = random(500) + 100;
    var angle = random(2 * pi);
    self.x = dist * cos(angle);
    self.y = -dist * sin(angle);
    self.model = model;
}