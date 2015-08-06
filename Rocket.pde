// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Rocket class -- this is just like our Boid / Particle class
// the only difference is that it has DNA & fitness

class Rocket {

  // All of our physics stuff
  PVector location;
  PVector velocity;
  PVector acceleration;

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

  //constructor
  Rocket(PVector l, DNA dna_) {
    acceleration = new PVector();
    velocity = new PVector();
    location = l.get();
    home = l.get();
    r = 4;
    dna = dna_;
    finishTime = 0;          // We're going to count how long it takes to reach target
    recordDist = 10000;      // Some high number that will be beat instantly
  }

  // FITNESS FUNCTION 
  // distance = distance from target
  // finish = what order did i finish (first, second, etc. . .)
  // f(distance,finish) =   (1.0f / finish^1.5) * (1.0f / distance^6);
  // a lower finish is rewarded (exponentially) and/or shorter distance to target (exponetially)
  void fitness(PVector home) {
    if (recordDist < 1) recordDist = 1;
    float homeDist = dist(location.x, location.y, home.x, home.y);
    
    // Reward finishing faster and getting close to home AFTER hitting target. 
    // recordDist is the record distance from the hive AFTER a bee hits the target
    fitness = ((1/(finishTime*recordDist))*(1/(finishTime*recordDist)));
 

    // Make the function exponential
    fitness = pow(fitness, 4);
    
    if (hitObstacle) fitness *= 0.01;
    if(hitTarget) fitness *= 1.1;
    if (tooFar){
      float hD = map(homeDist, 0, 500, 0, 1);
      fitness *= hD;
    }
    if (hitHome) fitness *= 3; 
     println(fitness);
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
  void run(ArrayList<Obstacle> os) {
    
    if (!hitObstacle && !hitHome) {
      applyForce(dna.genes[geneCounter]);
      geneCounter = (geneCounter + 1) % dna.genes.length;
      update();
      // If I hit an edge or an obstacle
      obstacles(os);
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
    if (d > 600 || homeDist > 800){
      tooFar = true;
    }
    
    if (hitTarget) recordDist = homeDist;
    
    if (hitTarget && homeDist < 10) hitHome = true;
    if (d < 30) hitTarget = true;

    else if (!hitTarget && !hitHome) {
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
    strokeWeight(2);
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);

    // Thrusters
    rectMode(CENTER);
    rect(-r/2, r*2, r/2, r);
    rect(r/2, r*2, r/2, r);

    // Rocket body
    fill(255,255,0,80);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();

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
