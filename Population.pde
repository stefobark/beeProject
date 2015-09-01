// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Pathfinding w/ Genetic Algorithms

// A class to describe a population of "creatures"

class Population {

  float mutationRate;          // Mutation rate
  ArrayList<Rocket> population;         // Array to hold the current population
  ArrayList<Rocket> matingPool;    // ArrayList which we will use for our "mating pool"
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
  
  // Fitness and DNA
  float hiveFitness;
  EcoRules dna;
  
  
   // Initialize the population
   Population(float m, int num, float x, float y, int l, float mF) {
     
    //mutation rate will start off as a random number between 1 and 0.
    mutationRate = m;
    dna = new EcoRules(l,m,x,y,mF); 
    population = new ArrayList<Rocket>();
    matingPool = new ArrayList<Rocket>();
    generations = 0;
    home = new PVector(x,y);
    lifetime = l;
    oLife = l;
    maxForce = mF;
    popNum = num;
    //make a new set of creatures
    for (int i = 0; i < popNum; i++) {
      population.add(new Rocket(home, new DNA(lifetime,mF)));
    }
  }
  
  void drawHome(){
    
    fill(R,G,B,100);
    ellipse(home.x,home.y, 140,140);
  }

  void live (ArrayList<Obstacle> os) {
    // For every creature
    for (int i=0;i < population.size(); i++) {
      Rocket rocket = population.get(i);
      rocket.checkTarget();
      //check if they make it home
       rocket.run(os);
    }
  }

  // Did anything finish?
  boolean targetReached() {
    for (int i = population.size() -1; i >= 0; i--) {
      Rocket r = population.get(i);
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
      Rocket r = population.get(i);
      if(r.hitTarget){
        madeTarget++;
      }
      if(r.checkHome()){
        madeHome++;
        B = 255;
        R = 0;
      }
    }
  }

  // Calculate fitness for each creature
  void fitness() {
    for (int i = population.size() - 1; i >= 0; i--) {
      Rocket r = population.get(i);
      
      r.fitness(r.home);
    }
    
    //count all the winners, add to "success". 
    //i put this here because fitness() only gets called at the end of the generation
    //this way i don't count the winners over and over and over
    success();
  }
  
  // Find highest fintess for the population
  float getMaxFitness() {
    float record = 0;
   for (Rocket r : population) {
       if(r.getFitness() > record) {
         record = r.getFitness();
       }
    }
    return record;
  }

  // Generate a mating pool
  void selection() {
  
 hiveFitness = .5;
    
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
      Rocket r = population.get(i); 
      float fitnessNormal = map(r.getFitness(),0,maxFitness,0,1);
      int n = (int) (fitnessNormal * 10);  // Arbitrary multiplier
      
      for (int j = 0; j < n; j++) {
        matingPool.add(r);
      }
    }
    println("mating pool size", matingPool.size());
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
        Rocket mR = matingPool.get(mom);
        Rocket dR = matingPool.get(dad);
      
        // Get their genes
        DNA momgenes = mR.getDNA();
        DNA dadgenes = dR.getDNA();
        
        // Mate their genes
        DNA child = momgenes.crossover(dadgenes);
        
        // Mutate their genes
        child.mutate(mutationRate);
        // Fill the new population with the new child
        PVector location = new PVector(home.x,home.y);
        population.add(new Rocket(home, child));
      }
     
    }
     generations++;
  }

  int getGenerations() {
    return generations;
  }

  void hiveFitness(){
    //simple fitness. moving the decimal over so that the number of bees that return will turn into a float between 0 and 1
    hiveFitness += madeHome * 2;
    hiveFitness += madeTarget * .5;
    println("made target", madeTarget);
  }
  
  float getFitness() {
    return hiveFitness;
  }
  
}
