class EcoRules{
  
  ArrayList<Float> genes = new ArrayList<Float>();
  
  
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
  EcoRules crossover(EcoRules partner) {
    ArrayList<Float> child = new ArrayList<Float>();
    
    // Pick a midpoint
    int crossover = int(random(genes.size()));
    float mutate = random(.85,1.15);
    // Take "half" from one and "half" from the other
    for (int i = 0; i < genes.size(); i++) {
      
      if (i > crossover) child.add(genes.get(i)*mutate);
      else               child.add(partner.genes.get(i)*mutate);
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
  
