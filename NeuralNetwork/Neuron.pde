// a neuron is an array of floats
class neuron{
   float[] weights;
   
   //constructor
   neuron(int inputs, float rate){
      weights = new float[inputs];
      //initialize random weights
      for (int i = 0; i < weights.length; i++){
          weights[i] = random(-1*rate, rate); 
      }
   }
   
   //feedInputs: array of floats --> float
   //purpose: to calculate the weighted sum
   float feedInputs(float[] inputs){
      float output = 0;
      for (int i = 0; i < weights.length; i++){
          output+= weights[i]*inputs[i];
      }
      return atan(output);
   }
}
