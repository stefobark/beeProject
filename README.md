# steve's bees

A "bee hive" simulation based on the genetic algorithm chapter from [Nature of Code](http://natureofcode.com), which, in turn, was inspired by 'Smart Rockets'.

![BEEEES](http://s3pics.s3.amazonaws.com/2015/09/btetter.png)

##the idea

Some number of beehives send out bees to find a flower. They eventually learn to return home after finding the flower. The bees that get to the target and back home the fastest are rewarded with a higher "fitness"-- a higher probability of spreading their genes (their genes are the path they take throughout their lifetime-- its an array of PVectors managed by a class called DNA). Magically, each generation gets better at finding the flower and returning home. 

But, there are a few variables that can be manipulated to help the bees learn faster.

These variables are (so far):

* lifetime (the length of a generation)
* mutation rate (how much the new generation deviates from the old)
* max force (how much force can be applied to shift the path of the bee at any given point)
 
##the meta idea

Instead of playing around to find the optimal value of each of the above mentioned variables, I just use the same kind of genetic algorith employed to teach bees, but instead of an array of PVectors, the hive genes are characteristics like "lifetime", "mutation rate" and "max force". I want to add location and population size eventually as well-- but I have to introduce more interaction between the hives first.. so they don't all just go to the best location or all just make huge populations. There has to be something that limits population size and something that makes it so that hives somehow exert a kind of repelling force on each other.

The hives get better at producing bees that are good at learning how to find the flower. They evolve. The bees learn to find the target and the hives learn to create the best conditions for their bees.

The best hives are the ones that produce the most number of bees that are able to go to the flower and return home in the course of 10,000 frames. 

The best hives get the biggest fitness scores. Hives with the biggest fitness scores occupy more space in the mating pool and therefore their genes are more likely to end up being present in the next generation. The values of the various characteristics are shuffled around and eventually we get some very productive bee hives!

##Bee Mutation

In Shiffman's example, there is mutate().
```
// Based on a mutation probability, picks a new random Vector

  void mutate(float m) {
    for (int i = 0; i < genes.length; i++) {
      if (random(1) < m) {
        float angle = random(TWO_PI);
        genes[i] = new PVector(cos(angle), sin(angle));
        genes[i].mult(random(0, maxforce));
      }
    }
  }
```  
You give it a float, your desired mutation rate, and for each of the steps (vectors) in the bee's genes, it decides whether or not to change the direction and force by gettting a random number between 0 and 1 and evaluating that against the value of your desired mutation rate. 

##Mutation Rate: High or Low?

With really low mutation rates, the children bees will follow paths very close to their parents-- and! their parents are likely to be the most fit bees so the children will end up being fairly 'fit' themselves. 

But! If no bees come close to the flower in the first generation, hives with really low mutation rates will have a hard time finding the flower in subsequent generations. 

This is why the question of 'the best mutation rate' came to mind. Hives with higher mutation rates are able to adjust in case the first generation didn't find the flower. Big mutation rates will create children that deviate from the paths of their parents-- and sometimes this is helpful.

So, there has to be a middle path. And that middle path will probably be different under different circumstances. Finding that path manually would be tedious and time consuming. So, we should just let the program do it for us.

##Hive Mutation

I approached hive mutation a bit differently. I don't use a separate function, mutation is applied to every gene for every generation in crossover().. and hive genes aren't PVectors-- they are characteristics.

Mutation is now a random float within one of three ranges (very high, high and low) that adjusts the value of other floats (the genes). If parent hives are successful, it's children's genes will not be adjusted very much-- but, if the parents are not so successful, their children's genes will deviate to a larger degree.

It works like this:
```
  // CROSSOVER
  // Creates new DNA sequence from two (this & and a partner)
  EcoRules crossover(EcoRules partner, float momMadeHome, float dadMadeHome, float genHighHome, float last) {
    ArrayList<Float> child = new ArrayList<Float>();
    
    // Pick a midpoint, the point where we will stop taking from one parent and start taking from another
    // here, because this is a hive, we aren't talking about PVectors-- our genes are characteristics like
    // lifetime, mutation rate, and max force. eventually we may work location into the genes too.
    int crossover = int(random(genes.size()));
    
    // Take "half" from one and "half" from the other. As we walk through the genes, depending on the performance
    // of this child's parents, we will mutate the genes at a high or low rate. 
    // the value of mutRate is set by comparing the last generation's max number of successful bees with this generation's
    for (int i = 0; i < genes.size(); i++) {
      
      //these are three different mutation rates. we use a very wide vHMRate mutation range 
      //when less the high score is less than 65% of the highest score ever or if the high score is less than 5
      // a wide hMRate (high mutation rate) when its less than 75% or we use nMRate (normal) when
      //the bees are doing well. Instead of doing mutation in a seperate function, i just mixed it into crossover()
      
      //high rate
      hMRate = random(.85,1.15);
      
      //very high rate
      vHMRate  = random(.5,1.5);
      
      //normal
      nMRate  = random(.9,1.1);
      
     //I wonder what the best limit is here... 
     //how many bees should return before we stop forcing big randomization of genes?
    
     
     if(genHighHome / last < .65 || genHighHome < 5){
        // if bees aren't doing well, we know we need to change some values. 
        // so, we use a bigger mutation rate.
        mutRate = vHMRate;
        println("used vHMRate");
      } else if( genHighHome / last < .75 ){
      
        mutRate = hMRate;
        println("used hMRate");
        
      } else {
        //or, we just use the normal mutation rate, because if bees are returning
        //we don't want to deviate too much. this hive is on the right track
        mutRate = nMRate;
        println("used nMRate");
      }
      
      
      if (i > crossover) child.add(genes.get(i)*mutRate);
      else               child.add(partner.genes.get(i)*mutRate);
    }    
    
    EcoRules newgenes = new EcoRules(child);
    return newgenes;
  }
  ```

And, we print the highest number of bees to return from each generation in the window so we can see that our ecosystem is learning how to produce hives that produce bees that are good at learning how to find flowers. 

It seems that there are a few combinations of characteristics that do well under these circumnstances. I've run the program over and over and have observed different values doing pretty well. As I write now, I'm watching an ecosystem that for the first ten hive generations (which is equal to 10,000 frames) did not have any hives that exceeded 300 max returning bees. But, after 30 generations there were some hives that had almost reached 400 max returning bees. A hive finally hit 431 in generation # 39. Now, the highest score ever, after couple hundred generations, is 979.

The ecosystem is definitely learning how to create hives that produce bees that are able to find flowers and return home!

It's fun.


