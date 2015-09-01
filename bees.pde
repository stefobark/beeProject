// Steve's Bees inspired by:

// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// ...inspired by Jer Thorp's Smart Rockets
// http://www.blprnt.com/smartrockets/

Population population;  // Population

int recordtime;         // Fastest time to target
int count;
int success;
int hiveGen;

Target target;        // Target location

//int diam = 24;          // Size of target

ArrayList<Obstacle> obstacles;  //an array list to keep track of all the obstacles!

//an ecosystem is a collection of hives
Ecosystem eco;

void setup() {
  size(800, 800);
  eco =  new Ecosystem();
  target = new Target(width/2-12, height/2, 24, 24);
  

  // Create the obstacle course  
  obstacles = new ArrayList<Obstacle>();
  //obstacles.add(new Obstacle(width*.38, height/2, width/4, 10));
}

void draw() {
  background(255);
  count++;
  
  fill(0);
  pushMatrix();
  text("Timer: " + count, 13, 18);
  translate(0,15);
  text("Hive Generation: " + hiveGen, 13, 18);
  popMatrix();
  if(count > 10000){
    hiveGen++;
    eco.selection();
    count = 0;
  }
  eco.stats();
  eco.runHives();
  // Draw the start and target locations
  target.display();
  
  

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
}
