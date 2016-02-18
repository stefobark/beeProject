// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Rocket class -- this is just like our Boid / Particle class
// the only difference is that it has DNA & fitness

class Bee {

  // All of our physics stuff
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  int R = 255;
  int G = 0;
  int B = 0;

  // Size
  float r;

  // How close did it get to the target
  float recordDist;

  // Fitness and DNA
  float fitness;
  DNA dna;
  
  // To count which force we're on in the genes
  int geneCounter = 0;

  boolean hitObstacle = false;    // Am I stuck on an obstacle?
  boolean hitTarget = false;   // Did I reach the target
  boolean hitHome = false;   // Did I reach the target
  boolean tooFar = false;   // Am I too far from home?
  int finishDist;              // What was my finish time?
  int finishTime;              // What was my finish time?
  PVector home;
  int targetTime;
  
  int hiveNum;

  //constructor
  Bee(PVector l, DNA dna_, int h) {
    acceleration = new PVector();
    velocity = new PVector();
    location = l.get();
    home = l.get();
    hiveNum = h;
    r = 4;
    dna = dna_;
    finishTime = 0;          // We're going to count how long it takes to reach target
    recordDist = 10000;
  }
	
  public void rotate(float theta) {
  float temp = x;
  // Might need to check for rounding errors like with angleBetween function?
  x = x*PApplet.cos(theta) - y*PApplet.sin(theta);
  y = temp*PApplet.sin(theta) + y*PApplet.cos(theta);
	}

  // FITNESS FUNCTION 
  
  void fitness() {
    if (recordDist < 1) recordDist = 1;
    
    float tDist = dist(location.x, location.y, target.location.x, target.location.y);
    
    if(!hitTarget) targetTime++;
    
    if(hitTarget){
      // Reward finishing faster and getting close to home
      fitness = 1/(finishTime*recordDist);
    } else {
      fitness = 1/(targetTime*tDist*100);
    }
    
    // Make the function exponential
    fitness = pow(fitness, 4);

    if (hitObstacle) fitness *= 0.5;
    if(hitHome) fitness *=15;
  }
  
  void checkEdges() {
    if (location.x > width) {
      location.x = width;
      velocity.x *= -1;
    } else if (location.x < 0) {
      velocity.x *= -1;
      location.x = 0;
    }

    if (location.y > height) {
      // Even though we said we shouldn't touch location and velocity directly, there are some exceptions.
      // Here we are doing so as a quick and easy way to reverse the direction of our object when it reaches the edge.
      velocity.y *= -1;
      location.y = height;
    }
  }

  // Run in relation to all the obstacles
  // If I'm stuck, don't bother updating or checking for intersection
  void run() {
    
    if (!hitObstacle && !hitHome) {
      applyForce(dna.genes[geneCounter]);
      geneCounter = (geneCounter + 1) % dna.genes.length;
      update();
      
      // If I hit an edge or an obstacle
      //obstacles(os);
      
    }
    // Draw me! if the bee hasn't hit the bad obstacle, if it hasn't reached home, and if it isn't too far away.
    if (!hitObstacle) {
      display();
    }
  }

  // Did I make it to the target?
  void checkTarget() {
    float d = dist(location.x, location.y, target.location.x, target.location.y);
    float homeDist = dist(location.x, location.y, home.x, home.y);
    
    
    
    if (location.x > width || location.x < 0 || location.y > height || location.y < 0){
      R = 0;
      G = 255;
      B = 0;
      tooFar = true;
    }
    
    //turn blue when it hits the target
    if (hitTarget){
      if(homeDist < recordDist) recordDist = homeDist;
      B = 255;
      R= 0;
    }
    if (hitTarget && homeDist < 20) hitHome = true;
    if (d < 20) hitTarget = true;
    
    else if (!hitHome) {
      finishTime++;
    }
  }
  
  boolean checkHome() {
    if(hitHome){
      return true;
    } else { 
      return false;
    }
  }

  // Did I hit an obstacle?
  void obstacles(ArrayList<Obstacle> os) {
    for (Obstacle obs : os) {
      if (obs.contains(location)) {
        hitObstacle = true;
      }
    }
  }

  void applyForce(PVector f) {
    acceleration.add(f);
  }


  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }

  void display() {
    //background(255,0,0);
    float theta = velocity.heading2D() + PI/2;
    fill(255,60);
    stroke(10);
    strokeWeight(1);
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    
    //if I want the bees to be colored according to their hive
    /*
    if(hiveNum == 0) fill(255,0,0,50);
    if(hiveNum == 1) fill(155,155,0,50);
    if(hiveNum == 2) fill(0,255,0,50);
    if(hiveNum == 3) fill(0,155,155,50);
    if(hiveNum == 4) fill(0,0,255,50);
    if(hiveNum == 5) fill(155,0,155,50);
    if(hiveNum == 6) fill(255,255,0,50);
    if(hiveNum == 7) fill(0,255,255,50);
    */
    
    //upper body
    fill(255,255,0,60);
    ellipse(0,-2,4,5);
    ellipse(0,-6,4,3);
    ellipse(0,0,4,5);
    ellipse(0,-2,5,6);
    ellipse(0,5,4,5);
    
    
    //wings
    fill(255,255,255,60);
    ellipse(6,0,7,5);
    ellipse(-6,0,7,5);
    
    
    //tail segment
    fill(255,255,0,60);
    ellipse(0,6,6,9);

    popMatrix();
  }

  float getFitness() {
    return fitness;
  }

  DNA getDNA() {
    return dna;
  }

  boolean stopped() {
    return hitObstacle;
  }
}
