class Target extends Obstacle {
  
  int rotate = 0;
  
    Target(float x, float y, float w_, float h_) {
    super(x,y,w_,h_);
  }
  
  void display() {
    stroke(.5);
    if(rotate < 360){
      rotate++;
    } else {
      rotate = 0;
    }
    
    strokeWeight(.5);
    pushMatrix();
    
    translate(location.x,location.y);
    rotate(radians(rotate));
    
    //bigger petals
    fill(255,220,0,250);
    ellipse(40,0,40,40);
    ellipse(-40,0,40,40);
    ellipse(0,40,40,40);
    ellipse(0,-40,40,40);
    
    //smaller petals
    fill(255,10,80,190);
    ellipse(20,20,40,40);
    ellipse(-20,-20,40,40);
    ellipse(20,-20,40,40);
    ellipse(-20,20,40,40);
    
    //accent on bigger petals
    fill(255,100,0,250);
    ellipse(40,0,20,20);
    ellipse(-40,0,20,20);
    ellipse(0,40,20,20);
    ellipse(0,-40,20,20);
    
    //accent on small petals
    fill(100,10,100,190);
    ellipse(20,20,30,30);
    ellipse(-20,-20,30,30);
    ellipse(20,-20,30,30);
    ellipse(-20,20,30,30);
    
    //center
    fill(255,255,0);
    ellipse(0,0,80,80);
    
    popMatrix();
  }
  
}
