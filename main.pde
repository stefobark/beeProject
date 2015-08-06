// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Smart Rockets w/ Genetic Algorithms

// Each Rocket's DNA is an array of PVectors
// Each PVector acts as a force for each frame of animation
// Imagine an booster on the end of the rocket that can point in any direction
// and fire at any strength every frame

// The Rocket's fitness is a function of how close it gets to the target as well as how fast it gets there

// This example is inspired by Jer Thorp's Smart Rockets
// http://www.blprnt.com/smartrockets/

Population population;  // Population

int recordtime;         // Fastest time to target
int count;
int success;

Target target;        // Target location

//int diam = 24;          // Size of target

ArrayList<Obstacle> obstacles;  //an array list to keep track of all the obstacles!
ArrayList<Population> hives;

void setup() {
  size(1000, 1000);
 

  
  
  
  target = new Target(width/2-12, height/2-100, 24, 24);

  // Create a population with a mutation rate. no longer a limit to population. i changed it to an array list in order to start making game
  float mutationRate = 0.088;
  hives = new ArrayList<Population>();
  hives.add(new Population(mutationRate, 20,width/2,200,600));
  hives.add(new Population(mutationRate, 20,width/2,height-200,600));

  // Create the obstacle course  
  obstacles = new ArrayList<Obstacle>();
  //obstacles.add(new Obstacle(width*.38, height/2, width/4, 10));
}

void draw() {
  background(255);
  
  
  
  count++;
  target.location.x += random(-2,2);
  target.location.y += random(-2,2);

  // Draw the start and target locations
  target.display();

  //draw home circle
  for(int i = 0; i < hives.size(); i++){
    Population hive = hives.get(i);
    hive.drawHome();
    
    // If the generation hasn't ended yet
    if (hive.lifecycle < hive.lifetime) {
      hive.lifecycle++;
      hive.live(obstacles);
      if ((hive.targetReached()) && (hive.lifecycle < hive.recordtime)) {
        hive.recordtime = hive.lifecycle;
      }
      // one third of the population must make it home before a new bee can be added to the hive
        if(hive.madeHome > hive.popNum/3){
          hive.popNum++;
        }
      // Otherwise a new generation
     }
    else {
        hive.lifecycle = 0;
        hive.fitness();
        hive.selection();
        hive.reproduction(hive.getHome());
    }
  
  }

  // Draw the obstacles
  for (Obstacle obs : obstacles) {
    obs.display();
  }
  
}

// Move the target if the mouse is pressed
// System will adapt to new target
void mousePressed() {
  target.location.x = mouseX;
  target.location.y = mouseY;
  population.recordtime = population.lifecycle;
}
