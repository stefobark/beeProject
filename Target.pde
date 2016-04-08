class Target extends Obstacle {
  
  int rotate = 0;
  int counter = 0;
  int fColor = 0;
  int fSize = 0;
  float size = 0;
  int grow = 0;
    Target(float x, float y, float w_, float h_) {
    super(x,y,w_,h_);
  }
  
  void display() {
    stroke(.01);
    
    counter++;
    fColor = counter % 155;
    fSize = count % 20;
    size = 200;
    
    
    pushMatrix();
    
    translate(location.x,location.y);
    
    
    fill(255,size,0,152);
    ellipse(0,0,size*.3,size*.3);
    
    popMatrix();
  }
  
}