//a brain is an array of Parray's
class brain{
   Parray[] network;
   
   //Constructor
   brain(int inputs, int hiddens, int hiddenLayers, int outputs, float rate){
       network = new Parray[hiddenLayers+1];
       for (int i = 0; i < hiddenLayers; i++){
          //the constructor needs to determine how many inputs each layer is considering
          if (i == 0)
            network[i] = new Parray(hiddens, inputs, rate);
          //use the weighted sum values calulated by the previous layer as inputs
          else
            network[i] = new Parray(hiddens, network[i-1].hidden.length, rate);
       }
       network[hiddenLayers] = new Parray(outputs, network[hiddenLayers-1].hidden.length, rate);
   }
   
   //activate: array of floats, integer --> array of floats
   //Purpose: pass the inputs through the network
   //EFFECT: the output will be used in the activation function
   float[] activate(float[] inputs, int acc){
       float[] output = new float[network[acc].hidden.length];
       for (int i = 0; i < network[acc].hidden.length; i++){
          output[i] = network[acc].hidden[i].feedInputs(inputs); 
       }
       if (acc+1 < network.length)
         output = activate(output, acc+1);
       return output;
   }
}
