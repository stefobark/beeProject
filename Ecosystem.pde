//this class is just like population except that instead of keeping track of a population of bees it keeps track
//of a population of hives. it uses the a modified version of the same genetic algorithm employed to teach bees
//but, instead of using the DNA class which is used for individual bees, I created a EcoRules class that does similar stuff.

class Ecosystem {
  
ArrayList<Population> hives = new ArrayList<Population>();
ArrayList<Population> matingPool; 
int popNum;
float mutationRate;
ArrayList<Float> homeX = new ArrayList<Float>();
ArrayList<Float> homeY = new ArrayList<Float>();

  
  Ecosystem(){
    hives.add(new Population(random(0,.4),80,width/2,100,int(random(300,2000)), random(0,1)));
    hives.add(new Population(random(0,.4),80,width/2,height-100,int(random(300,2000)), random(0,1)));
    hives.add(new Population(random(0,.4),80,100,height/2,int(random(300,2000)), random(0,1)));
    hives.add(new Population(random(0,.4),80,width-100,height/2,int(random(300,2000)), random(0,1)));
    popNum = hives.size();
    matingPool = new ArrayList<Population>();
    mutationRate = .01;
  }
  
  void stats(){
    
    for(int i = 0; i < hives.size(); i++){
      Population hive = hives.get(i);
      //writing out stats for each hive
      fill(0);
      pushMatrix();
      translate(hive.home.x-45,hive.home.y-35);
      text("Hive # " + i, 15, 20);
      translate(0,20);
      text("G # " + hive.getGenerations(), 10, 18);
      translate(0,10);
      text("S #: " + hive.madeHome, 10, 18);
      translate(0,10);
      text("M R: " + hive.mutationRate, 10, 18);
      translate(0,10);
      text("L: " + hive.lifetime, 10, 18);
      translate(0,10);
      text("MF: " + hive.maxForce, 10, 18);
      popMatrix();
    }
  }
  
 void displayHives(){
  //draw home circle
  for(int i = 0; i < eco.hives.size(); i++){
    Population hive = eco.hives.get(i);
    hive.drawHome();
  }
 }
  
  void runHives(){
    
    displayHives();
    
    for(int i = 0; i < eco.hives.size(); i++){
      Population hive = eco.hives.get(i);
      // If the generation hasn't ended yet
      if (hive.lifecycle < hive.lifetime) {
        hive.lifecycle++;
        hive.live(obstacles);
        if ((hive.targetReached()) && (hive.lifecycle < hive.recordtime)) {
          hive.recordtime = hive.lifecycle;
        }
        
          if(hive.madeHome > hive.popNum/5){
            hive.B=255;
            hive.R=0;
          }
        // Otherwise a new generation
       }
      else {
          hive.lifecycle = 0;
          hive.fitness();
          hive.selection();
          hive.reproduction(hive.home);
      }
    }
  
  }

// Generate a mating pool
  void selection() {
  
  if(matingPool.size() > 0){
     for(int i = matingPool.size() - 1; i >= 0; i--){
        matingPool.remove(i);
     }
  }
    
    // Calculate total fitness of whole population
    float maxFitness = getMaxFitness();
    println("number of hives: ", hives.size());
    
    // Calculate fitness for each member of the population (scaled to value between 0 and 1)
    // Based on fitness, each member will get added to the mating pool a certain number of times
    // A higher fitness = more entries to mating pool = more likely to be picked as a parent
    // A lower fitness = fewer entries to mating pool = less likely to be picked as a parent
    
    for (int i=0; i<hives.size(); i++) {
      Population r = hives.get(i); 
      println("hive ", i, " fitness: ", r.getFitness());
      
      float fitnessNormal = map(r.getFitness(),0,maxFitness,0,1);
      
      int n = (int) (fitnessNormal * 10);  // Arbitrary multiplier
      for (int j = 0; j < n; j++) {
        matingPool.add(r);
      }
    }
 
     reproduction();
  }
  
    // Find highest fintess for the population
  float getMaxFitness() {
    float record = 0;
   for (Population r : hives) {
       r.hiveFitness();
       if(r.getFitness() > record) {
         record = r.getFitness();
       }
    }
    return record;
  }
  
  // Making the next generation
  void reproduction() {
      
      
    //clear old hives from previous ecosystem
     for (int i = hives.size() -1; i >= 0 ; i--) {
      homeX.add(hives.get(i).home.x);
      homeY.add(hives.get(i).home.y);
      hives.remove(i);
     }
    println("mating pool size: ", matingPool.size());
    // Refill the population with children from the mating pool
    for (int i = 0; i < popNum; i++){
      
      // Spin the wheel of fortune to pick two parents
      
      int mom = int(random(hives.size()));
      int dad = int(random(hives.size()));
      
      if(matingPool.size() > mom && matingPool.size() > dad){
        Population mR = matingPool.get(mom);
        Population dR = matingPool.get(dad);
      
        // Get their genes
        EcoRules momgenes = mR.getDNA();
        EcoRules dadgenes = dR.getDNA();
        
        println("mom life: ", momgenes.genes.get(0));
        println("dad life: ", dadgenes.genes.get(0));
        
        // Mate their genes
        EcoRules child = momgenes.crossover(dadgenes);
        
        println("moms mRate: ", momgenes.genes.get(1));
        println("dads mRate: ", dadgenes.genes.get(1));
        
        println("child lifetime: ", child.genes.get(0));
        println("child mRate: ", child.genes.get(1));
        println("child mForce; ", child.genes.get(4));
        
        float mForce = child.genes.get(4);
        
        float newMRate = child.genes.get(1);
        if(newMRate < 0) newMRate = .0001;
        if(newMRate > 4) newMRate = 0.4;
        
        int newLife = int(child.genes.get(0));
        if(newLife < 100) newLife = int(random(100,120));
        if(newLife > 1000) newLife = int(random(900,1000));
        
        float thisHomeX = homeX.get(i);
        float thisHomeY = homeY.get(i);
        
        hives.add(new Population(newMRate, 80, thisHomeX, thisHomeY, newLife, mForce));
      }
    }
  }
  
}
