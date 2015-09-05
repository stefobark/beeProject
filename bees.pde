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
ArrayList<PVector> graphArray = new ArrayList<PVector>();

ArrayList<Float> avgMRates = new ArrayList<Float>();
ArrayList<Float> avgMForce = new ArrayList<Float>();
ArrayList<Float> avgLife = new ArrayList<Float>();

Graph highGraph;

Target target;        // Target location

int homeCount;
int firstToFive;
ArrayList<Obstacle> obstacles;  //an array list to keep track of all the obstacles!
ArrayList<Integer> trackHigh = new ArrayList<Integer>(); //keep track of the highest number of bees to return in one meta-generation (10,000 frames)
Ecosystem eco; //an ecosystem is a collection of hives
int ecoLife =  1000; //the lifetime of the ecosystem. this will influence the optimal value of the hive's "lifetime"
ArrayList<PVector> startLocs = new ArrayList<PVector>();

void setup() {
  size(1000, 1000);
  
  startLocs.add(new PVector(width/2+100,250));
  startLocs.add(new PVector(150+250,300));
  startLocs.add(new PVector(width/2+100,height-250));
  startLocs.add(new PVector(100+300,height-300));
  startLocs.add(new PVector(100+250,height/2));
  startLocs.add(new PVector(width-200,height-300));
  startLocs.add(new PVector(width-150,height/2));
  startLocs.add(new PVector(width-200,300));
  
  eco =  new Ecosystem(startLocs);
  target = new Target(width/2+100, height/2, 24, 24);
  highGraph = new Graph(new PVector(20,height-20)); // (TO DO) make a graph of the best scores of each ecosystem generation

   
  obstacles = new ArrayList<Obstacle>(); // Create the obstacle course 
  //obstacles.add(new Obstacle(width*.38, height/2, width/4, 10));
}

void draw() {
  background(255);
  count++;
   if(graphArray.size() > 0){
      highGraph.drawLine(graphArray);
    }
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
    translate(0,15);
   
    int trackHighSize = trackHigh.size()-1;
    
    for(int i = 0; i <= trackHighSize; i++){
      int h = trackHigh.get(i);
      genHigh = h;
      
      int f = i - trackHighSize;
      
      translate(0,15);
      text(f + " :: " + h, 25, 18,20);
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
      text(a, 25, 18);
      translate(0,15);
    }
  }
  if(avgMForce.size() > 0){
    translate(0,15);
    text("Average max force: \n",13,18);
    translate(0,15);
    for(float a : avgMForce){
      text(a, 25, 18);
      translate(0,15);
    }
  }
  
  if(avgMRates.size() > 0){
    translate(0,15);
    text("Average lifetime: \n",13,18);
    translate(0,15);
    for(float a : avgLife){
      text(a, 25, 18);
      translate(0,15);
    }
  }
  
  popMatrix();
  if(trackHigh.size() > 10){
      trackHigh.remove(0);
  }
  if(avgMRates.size() > 10){
    avgMRates.remove(0);
  }
  if(avgMForce.size() > 10){
    avgMForce.remove(0);
  }
  if(avgLife.size() > 10){
    avgLife.remove(0);
  }
  
  //this will reset the whole ecosystem every "ecoLife" number of frames.
  if(count > ecoLife){
    hiveGen++;
    
    eco.collectHiveStats(mostHome,highestEver);
    avgMRates.add(eco.avgMRate);
    avgMForce.add(eco.avgMForce);
    avgLife.add(eco.avgLife);
    //use the highest score ever to evaluate whether or not to apply the big or small mutation rate
    eco.selection();
    trackHigh.add(mostHome);
    graphArray.add(new PVector(10,mostHome));
    highGraph.drawLine(graphArray);
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
