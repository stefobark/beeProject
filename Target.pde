class Target extends Obstacle {
  
  int rotate = 0;
  int counter = 0;
  int fColor = 0;
  int fSize = 0;
  
    Target(float x, float y, float w_, float h_) {
    super(x,y,w_,h_);
  }
  
  void display() {
    stroke(.5);
    
    counter++;
    fColor = counter % 155;
    fSize = count % 20;
    
    if(rotate < 360){
      rotate++;
    } else {
      rotate = 0;
    }
    
    
    
    noStroke();
    pushMatrix();
    
    translate(location.x,location.y);
    rotate(radians(rotate));
    
    rotate(radians(-rotate+(rotate/2)));
    //accent on small petals
    fill(fColor/2,rotate,100,90);
    ellipse(5,5,rotate*.15,rotate*.15);
    ellipse(-5,-5,rotate*.15,rotate*.15);
    ellipse(5,-5,rotate*.15,rotate*.15);
    ellipse(-5,5,rotate*.15,rotate*.15);
    
    //center
    fill(255,rotate,rotate,92);
    ellipse(0,0,rotate*.5,rotate*.5);
    
    fill(255,rotate,0,152);
    ellipse(0,0,rotate*.3,rotate*.3);
    
    fill(255,0,rotate,152);
    ellipse(0,0,rotate*.1,rotate*.1);
    
    popMatrix();
  }
  
}
