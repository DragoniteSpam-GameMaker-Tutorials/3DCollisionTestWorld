/// these two matrices are going to be Matrix4 instances
function ColCameraFrustum(view_mat, proj_mat) constructor {
    var vp = view_mat.Mul(proj_mat);
    
    var c1 = new Vector3(vp.x.x, vp.x.y, vp.x.z);
    var c2 = new Vector3(vp.y.x, vp.y.y, vp.y.z);
    var c3 = new Vector3(vp.z.x, vp.z.y, vp.z.z);
    var c4 = new Vector3(vp.w.x, vp.w.y, vp.w.z);
    
    self.left =         new ColPlane(c4.Add(c1), vp.w.w + vp.x.w).Normalize();
    self.right =        new ColPlane(c4.Sub(c1), vp.w.w - vp.x.w).Normalize();
    self.bottom  =      new ColPlane(c4.Add(c2), vp.w.w + vp.y.w).Normalize();
    self.top =          new ColPlane(c4.Sub(c2), vp.w.w - vp.y.w).Normalize();
    self.near =         new ColPlane(c4.Add(c3), vp.w.w + vp.z.w).Normalize();
    self.far =          new ColPlane(c4.Sub(c3), vp.w.w - vp.z.w).Normalize();
}