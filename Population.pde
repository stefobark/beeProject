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

   // Initialize the population
   Population(float m, int num, float w, float h, int l) {
    mutationRate = m;
    population = new ArrayList<Rocket>();
    matingPool = new ArrayList<Rocket>();
    generations = 0;
    home = new PVector(w,h);
    lifetime = l;
    oLife = l;
    popNum = num;
    //make a new set of creatures
    for (int i = 0; i < popNum; i++) {
      
      population.add(new Rocket(home, new DNA(lifetime)));
    }
  }
  
  void drawHome(){
    fill(255,0,0,100);
    ellipse(home.x,home.y, 100,100);
  }
  
  PVector getHome(){
    return home;
  }

  void live (ArrayList<Obstacle> os) {
    // For every creature
    for (int i=0;i < population.size(); i++) {
      Rocket rocket = population.get(i);
      rocket.checkTarget();
      //check if they make it home
      if( rocket.checkHome()){
        madeHome++;
      }
       rocket.run(os);
    }
  }

  // Did anything finish?
  boolean targetReached() {
    for (Rocket r : population) {
      if (r.hitTarget) return true;
        if(r.checkHome()) success++;
    }
    return false;
  }

  // Calculate fitness for each creature
  void fitness() {
    for (Rocket r : population) {
      r.fitness(r.home);
    }
  }

  // Generate a mating pool
  void selection() {
  
  if(matingPool.size() > 0){
     for(int i = matingPool.size() - 1; i <= 0; i--){
        matingPool.remove(0);
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
      int n = (int) (fitnessNormal * 100);  // Arbitrary multiplier
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
     for (int i = 0; i < population.size(); i++) {
      population.remove(i);
    }
    
    // Refill the population with children from the mating pool
    for (int i = 0; i < popNum; i++){
      
      // Spin the wheel of fortune to pick two parents
      
      int mom = int(random(population.size()));
      int dad = int(random(population.size()));

      //this keeps failing! the matingPool is sometimes 0... why!?
      //must be something in selection()
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
      generations++;
    }
  }

  int getGenerations() {
    return generations;
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

}
