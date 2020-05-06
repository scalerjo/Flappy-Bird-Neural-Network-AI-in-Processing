//a Parray is an array of neurons
class Parray{
   neuron[] hidden;
   
   //Constructor
   Parray(int hiddens, int inputs, float rate){
      hidden = new neuron[inputs];
      for (int i = 0; i < hidden.length; i++){
         hidden[i] = new neuron(inputs, rate); 
      }
   }
}
