
class bird {
   int x; //X position of the bird
   int y; //Y position of the bird
   float v; //Velocity of the bird
   int state; //State of the bird determines if the bird is still alive or not. 0 if alive, 1 if dead
   int time; //how long the bird has survived
   int max; //state variable for the best bird. Used to determine if a smarter bird was generated or not. 
   
   brain birdBrain; //The brain of the bird
   
   //Constructor
   bird(){
      x = width/2;
      y = height/2;
      v = 0;
      state = 0;
      time = 0;
      max = 0;
      birdBrain = new brain(4, 6, 1, 1, 3);
   }
   
   //draw the bird on the scene
   void drawBird(){
       image(birdImage, x, y);
   }
   
   //move the bird on the scene
   void moveBird(){
      v += .7; //Simulates the effects of gravity
      y += v;
   }

   //determines if the bird is dead
   void isDead(){
       //check if the bird hit a wall
       for (int n = 0; n < 2; n++){
          if ((abs (wallx[n] - width/2) < birdImage.width) && ((y + birdImage.height/2 > wally[n] - wallImage.height/2) || y - birdImage.height/2 < (wally[n] - wallImage.height/2 - gap)))
          {
            state = 1;
          }
        }
        
        //if the bird hit the ground or touched the ceiling, remove the bird
        if (y < 0 || y > height){
          state = 1;
        }
   }
   
   //jump: array of floats --> void
   //purpose: to determine if the bird should jump or not
   //EFFECT: computes the weighted sum throughout the entire network using the initial inputs.
   //        The output is then plugged into an activation function which determines if the bird should jump or not.
   void jump(float[] inputs){
      if (birdBrain.activate(inputs, 0)[0] > 0){
          v = -10;
      }
   }
   
   //Purpose: randomly adjust all of the weights throughout the network
   //EFFECT:  The brain is copied from the best bird then randomly adjusted. 
   void adjust(){
      for (int i = 0; i < birdBrain.network.length; i++){
         for (int n = 0; n < birdBrain.network[i].hidden.length; n++){
            for (int z = 0; z < birdBrain.network[i].hidden[n].weights.length; z++){
                birdBrain.network[i].hidden[n].weights[z] = birds[0].birdBrain.network[i].hidden[n].weights[z] + birds[0].birdBrain.network[i].hidden[n].weights[z]*random(-1*rate,rate)*Lrate;
            }
         }
      }
   }
}
