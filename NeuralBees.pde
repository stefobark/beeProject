// Seek
// Daniel Shiffman <http://www.shiffman.net>

// The "NeuralBees" class

class NeuralBees {
  
  // Vehicle now has a brain!
  Perceptron brain;
  PVector desired = new PVector(width/2+100, height/2-100);
  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  //ArrayList<ArrayList<PVector>> targets = new ArrayList<ArrayList<PVector>>();

  NeuralBees(int n, float x, float y) {
    brain = new Perceptron(n,0.001);
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
    location = new PVector(x,y);
    r = 3.0;
    maxspeed = 2;
    maxforce = 3;
  }

  // Method to update location
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    // Reset accelerationelertion to 0 each cycle
    acceleration.mult(0);
    
    location.x = constrain(location.x,0,width);
    location.y = constrain(location.y,0,height);
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }
  
  // Here is where the brain processes everything
  void steer(ArrayList<Bee> targets, PVector worstHiveLoc) {
    // Make an array of forces
    PVector[] forces = new PVector[targets.size()];
    println(worstHiveLoc);
    // Steer towards targets
    for (int i = 0; i < forces.length; i++) {
      Bee b = targets.get(i);
      PVector t = b.location;
       forces[i] = seek(t);
    }
    // That array of forces is the input to the brain
    PVector result1 = brain.feedforward(forces);
    // Use the results to steer the vehicle
    applyForce(result1);
    PVector desired = worstHiveLoc;
    PVector error = PVector.sub(desired, location);
    brain.train(forces,error);
    
  }
  
  // A method that calculates a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target,location);  // A vector pointing from the location to the target
    if(location.dist(target) < 100){
      // Normalize desired and scale to maximum speed
      desired.normalize();
      desired.mult(maxspeed);
      // Steering = Desired minus velocity
      PVector steer = PVector.sub(desired,velocity);
      steer.limit(maxforce);  // Limit to maximum steering force
      return steer;
    } else {
      PVector steer = new PVector(0,0);
      return steer;
    }
  }
  
  PVector separate(PVector target) {
    PVector desired = PVector.sub(target,location);
    float distance = desired.mag();
    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus velocity
    PVector steer = PVector.sub(desired,velocity);
    //reverse it for seperate
    steer.limit(maxforce);  // Limit to maximum steering force
    
    if(distance < 50){
      steer.mult(-2);
    } else {
      steer.mult(0);
    }
    
    return steer;
  }
    
  void display() {
    strokeWeight(1);
    pushMatrix();
    translate(location.x,location.y);
    fill(255,0,0);
    ellipse(0,0,20,20);
    popMatrix();
  }
}