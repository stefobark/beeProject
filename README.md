# bees

A "bee hive" simulation (although, its not really based on bee behavior... just a loose association) based on the genetic algorithm chapter from [Nature of Code](http://natureofcode.com), which,in turn, was inspired by 'Smart Rockets'.

##the idea

Four beehives send out bees to find a flower. They eventually learn to return home after finding the flower. The bees that get to the target and back home the fastest are rewarded with a higher probability of spreading their genes (which in this case means "the path they take throughout their lifetime"). Each generation gets better at finding the flower. 

But, there are a few variables that can be manipulated to help the bees learn faster.

These variables are (so far):
* lifetime (the length of a generation)
* mutation rate (how much the new generation deviates from the old)
* max force (how much force can be applied to shift the path of the bee at any given point)
 
##the meta idea

Instead of playing around to find the optimal value of each of the above mentioned variables, I just use the same kind of genetic algorith employed to teach bees, but instead of an array of PVectors, the hive genes are "lifetime", "mutation rate" and "max force".

The hive with the highest number of bees (how many bees hit the target also plays a role, but it's smaller) gets the highest fitness score, and its genes are most likely going to be present in the next generation.

So, over time, the bees learn to find the target and the hives learn to create the best conditions for their bees. What does 'best' mean? Best, in this case, means that the hive produced the most number of bees that were able to hit the target and return home in the course of 10,000 frames. The characteristics are shuffled around and eventually we get some very productive bee hives!
