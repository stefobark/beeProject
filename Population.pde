// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Pathfinding w/ Genetic Algorithms

// A class to describe a population of "creatures"

class Population {

  float mutationRate;          // Mutation rate
  ArrayList<Bee> population;         // Array to hold the current population
  ArrayList<Bee> matingPool;    // ArrayList which we will use for our "mating pool"
  int generations;             // Number of generations
  PVector home;
  int popNum;
  int madeHome;
  int lifetime;
  int lifecycle = 0;
  int recordtime = 0;
  int oLife;
  int R = 255;
  int G = 0;
  int B = 0;
  int madeTarget;
  float maxForce;
  int sWeight;
  int hiveNum;
  
  // Fitness and DNA
  float hiveFitness;
  EcoRules dna;
  
   // Initialize the population
   Population(float m, int num, float x, float y, int l, float mF, int h) {
    //limits
    if(m <=0) m = .01;
    if(m >=1) m = .999;
    if(mF <= 0) mF = .1;
    if(mF >= 1) mF = .999;
    if(l > 1000) l = 1000;
    if(l < 100) l = 100;
    //mutation rate will start off as a random number between 1 and 0.
    mutationRate = m;
    dna = new EcoRules(l,m,x,y,mF); 
    population = new ArrayList<Bee>();
    matingPool = new ArrayList<Bee>();
    generations = 0;
    home = new PVector(x,y);
    lifetime = l;
    oLife = l;
    maxForce = mF;
    hiveNum = h;
    popNum = num;
   
     //make a new set of creatures
    for (int i = 0; i < popNum; i++) {
      population.add(new Bee(home, new DNA(lifetime,mF),hiveNum));
    }
  }
  void drawHome(){
    fill(R,G,B,60);
    strokeWeight(sWeight);
    ellipse(home.x,home.y, 80,80);
  }
 
  void live () {
    for (int i=0; i < population.size(); i++) {
      Bee b = population.get(i);
      b.checkTarget();
      b.run();
    }
  }

  // Did anything finish?
  boolean targetReached() {
    for (int i = population.size() -1; i >= 0; i--) {
      Bee r = population.get(i);
      if(r.hitTarget){
        madeTarget++;
      }
      if(r.checkHome()){
        return true;
      }
    }
    return false;
  }
  
  EcoRules getDNA() {
    return dna;
  }
  
  void success(){
    for (int i = population.size() -1; i >= 0; i--) {
      Bee r = population.get(i);
      
      //when one bee hits the hive after hitting the target, the hive will turn blue
      if(r.checkHome()){
        madeHome++;
        B = 255;
        R = 0;
      }
      
      /*
        this will count the number of bees to hit the target, 
        "madeTarget" will be used for the hive's fitness until 
        one bee from the hive hits the target
      */
      targetReached();
    }
  }

  // Calculate fitness for each creature
  void fitness() {
    for (int i = population.size() - 1; i >= 0; i--) {
      Bee r = population.get(i);
      r.fitness();
    }
    
    /*
      count all the bees that were able to return home throughout the course of this hive's lifetime
      add to "success". i put this here because fitness() only gets called at the end of the generation
      this way i don't count the winners each frame (this produces big numbers because if there is a bee on the hive
      success gets incremented each frame-- I could use that to count the amount of time it took 
      for the first bee to come home.
    */
    success();
  }
  
  // Find highest fintess for the population
  float getMaxFitness() {
    float record = 0;
   for (Bee r : population) {
      
       if(r.getFitness() > record) {
         record = r.getFitness();
       }
    }
    return record;
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

    // Calculate fitness for each member of the population (scaled to value between 0 and 1)
    // Based on fitness, each member will get added to the mating pool a certain number of times
    // A higher fitness = more entries to mating pool = more likely to be picked as a parent
    // A lower fitness = fewer entries to mating pool = less likely to be picked as a parent
    for (int i=0;i<population.size();i++) {
      Bee r = population.get(i); 
      float fitnessNormal = map(r.getFitness(),0,maxFitness,0,1);
      int n = (int) (fitnessNormal * 10);  // Arbitrary multiplier
      
      for (int j = 0; j < n; j++) {
        matingPool.add(r);
      }
    }
  }
  
  void resetLifetime(){
    lifetime = oLife;
  }

  // Making the next generation
  void reproduction(PVector home) {
    
    //clear old bees from previous generation
     for (int i = population.size() -1; i >= 0 ; i--) {
      population.remove(i);
    }
    
    // Refill the population with children from the mating pool
    for (int i = 0; i < popNum; i++){
      
      // Spin the wheel of fortune to pick two parents
      
      int mom = int(random(population.size()));
      int dad = int(random(population.size()));
      
      if(matingPool.size() > mom && matingPool.size() > dad){
        Bee mR = matingPool.get(mom);
        Bee dR = matingPool.get(dad);
      
        // Get their genes
        DNA momgenes = mR.getDNA();
        DNA dadgenes = dR.getDNA();
        
        // Mate their genes
        DNA child = momgenes.crossover(dadgenes);
        
        // Mutate their genes
        child.mutate(mutationRate);
        // Fill the new population with the new child
       
        population.add(new Bee(home, child, hiveNum));
        
        
      }
     
    }
     generations++;
  }

  int getGenerations() {
    return generations;
  }

  /*
    this determines the fitness of a hive.
  */
  void hiveFitness(){
    
    hiveFitness = madeHome * 3;
    
    //if no bees have made it home
    if(hiveFitness <= 0){
      //use the number of bees that hit the target, but reduce it a bunch so it doesn't end up outweighing
      //the fitness of hives that have had bees return
      //and remember that the fitness gets 'normalized'-- it gets changed to a number 
      //between 0 and 1 with the map() function
      hiveFitness = madeTarget * .000001;
    }
  }
  
  float getFitness() {
    return hiveFitness;
  }
  
}