class Ecosystem {
  
ArrayList<Population> hives = new ArrayList<Population>();
ArrayList<Population> matingPool; 
int popNum;
float mutationRate;
ArrayList<Float> homeX = new ArrayList<Float>();
ArrayList<Float> homeY = new ArrayList<Float>();
float hMRate; 
 float nMRate;
float mutRate;
float genPerformance;
int genHighHome;
float avgMRate;
float avgMForce;
float avgLife;
ArrayList<PVector> targets = new ArrayList<PVector>();

ArrayList<NeuralBees> v = new ArrayList<NeuralBees>();

PVector desired;

Ecosystem(ArrayList<PVector> startLocs){
   int countHives = 0;
   // The NeuralBee's desired location
  desired = new PVector(width/2,height/2);
  
    for(PVector s : startLocs){
      countHives++;
      
      //dont want to give it a mutation rate higher than .2
      //or a lifetime bigger than 2000 or smaller than 300
      //and a possible max force of up to 2
      hives.add(new Population(random(0,.2),40,s.x,s.y,int(random(300,2000)), random(0,2), countHives));
    }
    popNum = hives.size();
    matingPool = new ArrayList<Population>();
    mutationRate = .01;
    
    // Create the NeuralBee (it has to know about the number of targets
    // in order to configure its brain)
    println(targets.size());
    float distFromCenter;
    PVector center = new PVector(width/2,height/2);
    for(Population h : hives){
      for(Rocket r : h.population){
          targets.add(r.location);
      }
      //create the neural bee
      v.add(new NeuralBees(targets.size(), random(width), random(height)));
    }
    
   
  }
  
   void genPerf(int highest){
    genPerformance = highest;
  }
  
  void getGenHigh(int high){
    genHighHome = high;
    println("genHighHome!!!", genHighHome);
  }
  
  void stats(){
    
    for(int i = 0; i < hives.size(); i++){
      Population hive = hives.get(i);
      //writing out stats for each hive
      fill(0);
      pushMatrix();
      translate(hive.home.x-45,hive.home.y-45);
      textSize(14);
      text("Hive # " + i, 15, 20);
      textSize(10);
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
    for(NeuralBees b : v){
      // Update the Vehicle
      b.steer(targets);
      b.update();
      b.display();
    }
    
    
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
  
  void collectHiveStats(int mostHome, int highestEver){
     getGenHigh(mostHome);
     genPerf(highestEver);
     
     for (int i =  0; i <= hives.size()-1 ; i++) {
       Population h = hives.get(i);
       
       //get average mutation rates
       avgMRate += h.mutationRate;
       
       //get average max force
       avgMForce += h.maxForce;
       
       //get average lifetime
       avgLife += h.lifetime;
     }  
     
     avgMRate = avgMRate / hives.size();
     avgMForce = avgMForce / hives.size();
     avgLife = avgLife / hives.size();
     }
  
  int firstToFive(){
    int winner = 99;
     for (int i =  0; i <= hives.size()-1 ; i++) {
       Population r = hives.get(i);
      if(r.madeHome > 4){
        winner = i;
      } 
     }
     return winner;
  }
  
  // Making the next generation
  void reproduction() {
    //clear old hives from previous ecosystem and remember their locations in homeX and homeY
     for (int i = hives.size() -1; i >= 0 ; i--) {
      homeX.add(hives.get(i).home.x);
      homeY.add(hives.get(i).home.y);
      hives.remove(i);
     }
     
    println("mating pool size: ", matingPool.size());
    // Refill the population with children from the mating pool
    for (int i = 0; i < popNum; i++){
      println(" \n                    Child Hive #", i, "\n");
      // Spin the wheel of fortune to pick two parents
      
      int mom = int(random(hives.size()));
      println("Picked Mom #", mom);
      int dad = int(random(hives.size()));
      println("Picked Dad #", dad);
      
      println("hive mating pool size: ", matingPool.size());
      if(matingPool.size() > mom && matingPool.size() > dad){
        Population mR = matingPool.get(mom);
        Population dR = matingPool.get(dad);
      
        // Get their genes
        EcoRules momgenes = mR.getDNA();
        EcoRules dadgenes = dR.getDNA();
        
        println("mom life: ", momgenes.genes.get(0));
        println("dad life: ", dadgenes.genes.get(0));
        
        EcoRules child = momgenes.crossover(dadgenes, mR.madeHome, dR.madeHome, genHighHome, genPerformance);
        
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
        
        hives.add(new Population(newMRate, 40, thisHomeX, thisHomeY, newLife, mForce, i));
      }
    }
  }
  
}
