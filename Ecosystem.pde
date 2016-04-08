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
ArrayList<Float> avgPerfArray = new ArrayList<Float>();
int genHighHome;
float avgMRate;
float avgMForce;
float avgLife;
NeuralBees nBee; 
ArrayList<Bee> nTargets = new ArrayList<Bee>();
PVector desired;
int countHives = 0;
   
Ecosystem(ArrayList<PVector> startLocs){

   // The NeuralBee's desired location
  desired = new PVector(width/2+50,height/2-50);
  
  for(PVector s : startLocs){
    countHives++;
    hives.add(new Population(random(0,.2),40,s.x,s.y,int(random(300,2000)), random(0,2), countHives));
  }
  
  //get the predator bee's targets, build the predator bee. but!! we need to update the target list every time a 
  //hive produces a new generation!
  nTargets = getTargets();
  nBee = new NeuralBees(nTargets.size(), random(width), random(height));
  popNum = hives.size();
  println(nTargets.size());
  matingPool = new ArrayList<Population>();
  mutationRate = .01;
}
  
   void genPerf(int highest){
    float avg = 0;
    avgPerfArray.add(float(highest));
    for(float a : avgPerfArray){
     avg += a;
    }
    genPerformance = avgPerfArray.size() / avg;
   }
  
  void getGenHigh(int high){
    genHighHome = high;
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

//let's make the predator bee go after the worst performing hive
PVector worstHiveLoc(){
  PVector worstHiveLoc = new PVector();
  float w = 9999;
  ArrayList<Float> perf = new ArrayList<Float>();
  for(int i = 0; i < hives.size(); i++){
      Population hive = hives.get(i);
      if(hive.madeHome == 0) perf.add(hive.madeTarget*.1);
      else perf.add(float(hive.madeHome));
  }
  for(int j = 0; j < perf.size(); j++){
      float check = perf.get(j);
      if(check < w) w = check;
      Population worstHive = hives.get(j);
      worstHiveLoc = worstHive.home;
  }
  return worstHiveLoc;
}

void nBeeLive(){
  PVector wL = worstHiveLoc();
  nBee.steer(nTargets,wL);
  nBee.update();
  nBee.display();
}
 
ArrayList<Bee> getTargets(){
  nTargets.clear();
  for(Population p : hives){
    for(Bee b : p.population){
      nTargets.add(b);
    }
  }
  return nTargets;
}
      
 void displayHives(){
  //draw home circle
  for(int i = 0; i < eco.hives.size(); i++){
    Population hive = eco.hives.get(i);
    hive.drawHome();
  }
  
  for(int i = 0; i < eco.hives.size();i++){
    Population hive = eco.hives.get(i);
    
    // If the generation hasn't ended yet
    if (hive.lifecycle < hive.lifetime) {
      hive.lifecycle++;
      hive.live();
      if ((hive.targetReached()) && (hive.lifecycle < hive.recordtime)) {
        hive.recordtime = hive.lifecycle;
      }
      if(hive.madeHome > hive.popNum/5){
        hive.B=255;
        hive.R=0;
      }
      // Otherwise a new generation
     } else {
        /* 
        / HERE, I SOLVED THAT NEURAL BEE TARGET PROBLEM. IT WAS SIMPLE!
        */
        
        //remove dead bees from neural bee targets
        for(int x = 1; x < nTargets.size(); x++){
          Bee oldBee = nTargets.get(x);
          if(oldBee.hiveNum == hive.hiveNum) nTargets.remove(oldBee);
        }
        
        hive.lifecycle = 0;
        hive.fitness();
        hive.selection();
        hive.reproduction(hive.home);
        
        //add new bees to neural bee targets
        for(Bee newBee : hive.population){
          nTargets.add(newBee);
        }
        
    }
  }
}

  void newNBee(){
      nTargets = getTargets();
      nBee = new NeuralBees(nTargets.size(), random(width), random(height));
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
    
    for (int i=0; i<hives.size(); i++) {
      Population r = hives.get(i);
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
     
    // Refill the population with children from the mating pool
    for (int i = 0; i < popNum; i++){
      int mom = int(random(hives.size()));
      int dad = int(random(hives.size()));
      
      if(matingPool.size() > mom && matingPool.size() > dad){
        Population mR = matingPool.get(mom);
        Population dR = matingPool.get(dad);
      
        // Get their genes
        EcoRules momgenes = mR.getDNA();
        EcoRules dadgenes = dR.getDNA();
        
        EcoRules child = momgenes.crossover(dadgenes, genHighHome, genPerformance);
        
        
        float mForce = child.genes.get(4);
        float newMRate = child.genes.get(1);
        int newLife = int(child.genes.get(0));;
        float thisHomeX = homeX.get(i);
        float thisHomeY = homeY.get(i);
        
        hives.add(new Population(newMRate, 40, thisHomeX, thisHomeY, newLife, mForce, i));
      }
    }
  }
  
}