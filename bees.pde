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
int mostHome;
int mostHomeHive;
int highestEver = 0;
int last;
int genHigh;

ArrayList<Float> avgMRates = new ArrayList<Float>();

Graph highGraph;

Target target;        // Target location

int homeCount;
int firstToFive;
ArrayList<Obstacle> obstacles;  //an array list to keep track of all the obstacles!
ArrayList<Integer> trackHigh = new ArrayList<Integer>(); //keep track of the highest number of bees to return in one meta-generation (10,000 frames)
Ecosystem eco; //an ecosystem is a collection of hives
int ecoLife =  10000; //the lifetime of the ecosystem. this will influence the optimal value of the hive's "lifetime"

void setup() {
  size(1000, 800);
  eco =  new Ecosystem();
  target = new Target(width/2+100, height/2, 24, 24);
  highGraph = new Graph(new PVector(20,height-20)); // (TO DO) make a graph of the best scores of each ecosystem generation

   
  obstacles = new ArrayList<Obstacle>(); // Create the obstacle course 
  //obstacles.add(new Obstacle(width*.38, height/2, width/4, 10));
}

void draw() {
  background(255);
  count++;
  
  
  //in the following messy chunk of code, I'm just printing some stats about the ecosystem
  
  fill(0); //make the text black
  
  //we're going to be doing a lot of "translate()"ing. so, remember pushMatrix() and popMatrix()
  pushMatrix();
  textSize(26);
  translate(0,10);
  text("::Ecosystem Stats::", 8, 18);
  translate(0,20);
  textSize(11);
  text("Timer: " + count, 13, 18);
  translate(0,15);
  text("Eco Generation: " + hiveGen, 13, 18);
  if(eco.firstToFive() < 98){
     translate(0,15);
     text("First to Five: " + firstToFive, 13, 18);
  }
  translate(0,15);
  text("Winner: Hive #" + mostHomeHive + " with " + mostHome + " returning bees.", 13, 18);
  translate(0,15);
  text("Highest Ever: " + highestEver, 13, 18);
 
  if(trackHigh.size() > 0){
    translate(0,35);
    text("Max returners:", 13, 18);
    int trackHighSize = trackHigh.size()-1;
    for(int i = 0; i <= trackHighSize; i++){
      int h = trackHigh.get(i);
      genHigh = h;
      
      if(trackHighSize > 30){
        trackHigh.remove(0);
      }
      
      int f = i - trackHighSize;
      
      translate(0,15);
      text("-----> " + f + " :: " + h, 18, 18,20);
      if(h > highestEver){
        highestEver = h;
      }
    }
  }
    translate(0,15);
 
  if(avgMRates.size() > 0){
    translate(0,15);
    text("Average mutation rates: \n",13,18);
    translate(0,15);
    for(float a : avgMRates){
      text(a, 13, 18);
      translate(0,15);
    }
  }
  popMatrix();
  
  //this will reset the whole ecosystem every "ecoLife" number of frames.
  if(count > ecoLife){
    hiveGen++;
    eco.collectHiveStats(mostHome,highestEver);
    avgMRates.add(eco.avgMRate);
    //use the highest score ever to evaluate whether or not to apply the big or small mutation rate
    eco.selection();
    trackHigh.add(mostHome);
    count = 0;
    mostHome = 0;
    mostHomeHive = 0;
  }
  
  eco.firstToFive(); //this doesn't really tell us anything useful. I might get rid of it.
   
  for(int i=0; i <= eco.hives.size()-1; i++){
      
      Population r = eco.hives.get(i);
      
      if(r.madeHome > mostHome){
          mostHome = r.madeHome;
          mostHomeHive = i;
      }
  }
      
  if(eco.firstToFive() < 98){
   
    firstToFive = eco.firstToFive();
    
    Population winningHive = eco.hives.get(mostHomeHive);
    
  }
  
  eco.stats(); //display hive stats
  eco.runHives(); //run all the hive stuff
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
