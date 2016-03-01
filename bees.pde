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
//this bee hive's generation's max successful bees
int genHigh;

//to display the bar graph at the bottom
ArrayList<PVector> graphArray = new ArrayList<PVector>();
//average mutation rates of all bees
ArrayList<Float> avgMRates = new ArrayList<Float>();
//average max force of all bees
ArrayList<Float> avgMForce = new ArrayList<Float>();
//average lifespan of all bees
ArrayList<Float> avgLife = new ArrayList<Float>();

//graph is the class I wrote all the graph stuff in
Graph highGraph;

Target target;

int homeCount;
int firstToFive;
ArrayList<Obstacle> obstacles;  //an array list to keep track of all the obstacles!
ArrayList<Integer> trackHigh = new ArrayList<Integer>(); //keep track of the highest number of bees to return in one meta-generation (10,000 frames)
Ecosystem eco; //an ecosystem is a collection of hives
int ecoLife =  2000; //the lifetime of the ecosystem. this will influence the optimal value of the hive's "lifetime"
ArrayList<PVector> startLocs = new ArrayList<PVector>();
ArrayList<PVector> targets = new ArrayList<PVector>();


void setup() {
  size(600, 600);
  //hive 0
  startLocs.add(new PVector(width/2+100,50));
  //hive 1
  startLocs.add(new PVector(width/2+200, 100));
  //hive 2
  startLocs.add(new PVector(width/2,100));
  //hive 3
  startLocs.add(new PVector(width/2+200,height/2));
  //hive 4
  startLocs.add(new PVector(width/2-50,height/2-100));
  //hive 5
  startLocs.add(new PVector(width-300,height/2));
  //hive 6
  startLocs.add(new PVector(width-50,height/2-100));
  //hive 7
  startLocs.add(new PVector(width-200,height/2+50));
  
  eco =  new Ecosystem(startLocs);
  target = new Target(width/2+100, height/2-100, 24, 24);
  highGraph = new Graph(new PVector(20,height-20));
  
  
    
}

void draw() {
  background(255);
  count++;
   if(graphArray.size() > 0){
      highGraph.drawLine(graphArray);
    }
    
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
  
  if(avgLife.size() > 0){ //<>//
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
  if(graphArray.size() > width/10){
      graphArray.remove(0);
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
    eco.newNBee();
    trackHigh.add(mostHome);
    graphArray.add(new PVector(10,mostHome));
    highGraph.drawLine(graphArray);
    count = 0;
    mostHome = 0;
    mostHomeHive = 0;
  }
  
  for(int i=0; i <= eco.hives.size()-1; i++){
      
      Population r = eco.hives.get(i);
      if(r.madeHome > mostHome){
          mostHome = r.madeHome;
          mostHomeHive = i;
      }
  }
  
  eco.displayHives();
  eco.stats(); //display hive stats
  target.display();
  eco.nBeeLive();

}