// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Simple Perceptron Example
// See: http://en.wikipedia.org/wiki/Perceptron

// Perceptron Class

class Perceptron {
  float[] weights;  // Array of weights for inputs
  float c;          // learning constant

  // Perceptron is created with n weights and learning constant
  Perceptron(int n, float c_) {
    weights = new float[n];
    c = c_;
    // Start with random weights
    for (int i = 0; i < weights.length; i++) {
      weights[i] = random(0, 1);
    }
  }

  // Function to train the neural bee
  // Weights are adjusted based on vehicle's error
  // so if the weight is high, the force will end up having 
  // a large influence on the vector that is finally returned in the feedforward function

  
  // if the error is low, if the bee is near a target, that will mean that the weight will be smaller
  // which would mean that the neural bee would then seek out another target.. so then,
  // i guess that means it would seek the furthest target
  
  void train(PVector[] forces, PVector error) {
    for (int i = 0; i < weights.length; i++) {
      weights[i] += c*error.x*forces[i].x;         
      weights[i] += c*error.y*forces[i].y;
      weights[i] = constrain(weights[i], 0, 1);
    }
  }

  // Give me a steering result
  PVector feedforward(PVector[] forces) {
    // Sum all values
    PVector sum = new PVector();
    for (int i = 0; i < weights.length; i++) {
      forces[i].mult(weights[i]);
      sum.add(forces[i]);
    }
    return sum;
  }
}
