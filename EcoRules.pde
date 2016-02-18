class EcoRules{
  
  ArrayList<Float> genes = new ArrayList<Float>();
  float nMRate;
  float hMRate;
  float vHMRate;
  float sMRate;
  float mutRate;
  int mutLimit = 10;
  
  EcoRules(float lifetime, float mRate, float x, float y, float mForce) {
    genes.add(lifetime);
    genes.add(mRate);
    genes.add(x);
    genes.add(y);
    genes.add(mForce);
  }
  
   // Constructor #2, creates the instance based on an existing array
  EcoRules(ArrayList<Float> newgenes) {
    // We could make a copy if necessary
    // genes = (PVector []) newgenes.clone();
    genes = newgenes;
  }
  
  // CROSSOVER
  // Creates new DNA sequence from two (this & and a partner)
  EcoRules crossover(EcoRules partner, float genHighHome, float last) {
    ArrayList<Float> child = new ArrayList<Float>();
    
    // Pick a midpoint, the point where we will stop taking from one parent and start taking from another
    // here, because this is a hive, we aren't talking about PVectors-- our genes are characteristics like
    // lifetime, mutation rate, and max force. eventually we may work location into the genes too.
    int crossover = int(random(genes.size()));
    
    // Take "half" from one and "half" from the other. As we walk through the genes, depending on the performance
    // of this child's parents, we will mutate the genes at a high or low rate. 
    // the value of mutRate is set by comparing the last generation's max number of successful bees with this generation's
    for (int i = 0; i < genes.size(); i++) {
      
      //high rate
      hMRate = random(.85,1.15);
      
      //very high rate
      vHMRate  = random(.5,1.5);
      
      //normal
      nMRate  = random(.9,1.1);
      
      //small.. for very successful generations
      sMRate  = random(.99,1.01); 
    
   if(genHighHome / last > 1){
        mutRate = sMRate;
        println("used sMRate");
      } else if(genHighHome / last < .30 || genHighHome < 1){
        // if bees are not returning to any of the hives we know we need to change some values. 
        // so, we use a bigger mutation rate.
        mutRate = vHMRate;
        println("used vHMRate");
      } else if( genHighHome / last < .50 ){
      
        mutRate = hMRate;
        println("used hMRate");
        
      } else{
        mutRate = nMRate;
        println("used nMRate");
        
        //or if it was higher than the highest so far
      } 
      
      
      if (i > crossover) child.add(genes.get(i)*mutRate);
      else               child.add(partner.genes.get(i)*mutRate);
    }    
    
    EcoRules newgenes = new EcoRules(child);
    return newgenes;
  }
  
    
  float getMRate(){
    return genes.get(1);
  }
  
  float getLifetime(){
    return genes.get(0);
  }
 
}
  