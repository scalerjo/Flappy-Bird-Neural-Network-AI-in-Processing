int testingAmount = 100;//amount of birds to run at once
int gen = 1;//generation counter

float rate = 3; //used to generate a new random weight factor
float Lrate = 1;//learning constant

PImage backImage =loadImage("http://i.imgur.com/cXaR0vS.png");//game images
PImage birdImage =loadImage("http://i.imgur.com/mw0ai3K.png");
PImage wallImage =loadImage("http://i.imgur.com/4SUsUuc.png");
PImage startImage =loadImage("http://i.imgur.com/U6KEwxe.png");

int[] wallx = new int [2];//the x position of each wall
int[] wally = new int [2];//the y position of each wall
int gap = 150;//size of the game in each wall

int x1;//position of the first back image
int x2;//position of the second back image

int score = 0;//keeps track of the score
PFont f;//font used for the score and the generation counter

boolean score0 = false;//used to determine if a wall has passed the bird
boolean score1 = false;//------

bird[] birds;


void setup(){
   imageMode(CENTER);
   size(600,800);
   f = createFont ("Arial", 50, true);
   birds = new bird[testingAmount];
   
   //initialize the birds
   for (int i = 0; i < birds.length; i++){
      birds[i] = new bird(); 
   }
   
   //Initialize the position of the walls
   wallx[0] = 600;
   wallx[1] = 1000;
   wally[0] = height + wallImage.height/2 - gap;
   wally[1] = height + wallImage.height/2 - gap;
   
   //Initialize the position of the backimage
   x2 = width/2 + backImage.width;
   x1 = width/2;
}

void draw(){
  moveBackImage();
  moveWalls();
  drawBackImage();
  drawWalls();
  addScore();
  
  //display the score and the generation counter
  textFont(f);
  text(score, width/2, height - 100);
  text("Gen: " + gen, width/2, height - 50);
  
  for (int i = 0; i < birds.length; i++){
     if (birds[i].state == 0){
        birds[i].time++;
        if (birds[i].time > birds[i].max)
          birds[i].max = birds[i].time;
        birds[i].moveBird(); 
        birds[i].drawBird();
        birds[i].isDead();
        
        int nextWallIndex = findNextWall();
        float i1 = (wallx[nextWallIndex]-birds[i].x)/100;//do not edit these
        float i2 = (wally[nextWallIndex] - wallImage.height/2 - birds[i].y)/100;//do not edit these
        float i3 = ((wally[nextWallIndex] - gap - wallImage.height/2) - birds[i].y )/100;//do not edit these
        float i4 = birds[i].v/10;//do not edit these
        float[] inputs = {i1,i2,i3,i4};
        birds[i].jump(inputs);
     }
  }
  
  //Begin training the birds
  if (isOver() == true){
     int bestIndex = findBest();
     swapBirds(0,bestIndex);
     
     //ReInitialize the birds and mutate the brains of all birds except the first index
     for (int i = 0; i < birds.length; i++){
         birds[i].y = height/2;
         birds[i].v = 0;
         birds[i].state = 0;
         birds[i].time = 0;
         
         if (i > 0){
            birds[i].max = 0;
            birds[i].adjust();
         }
     }
     
     //ReInitialize the wall and backimage positions and the score
     wallx[0] = 600;
     wallx[1] = 1000;
     wally[0] = height + wallImage.height/2 - gap;
     wally[1] = height + wallImage.height/2 - gap;
     x2 = width/2 + backImage.width;
     x1 = width/2;
     score = 0;
     
     //Increase the generation counter. If gen is greater then 20, change the mutation rate.
     gen++;
     if (gen > 20){
       rate = 1;
       Lrate = .1;
     }
  }
}

void moveBackImage(){
  x1 -= 6;
  x2 -= 6;
  
  //reset the position of the backimage when it has left the scene     
  if (x1 + backImage.width/2 < 0){
    x1 += backImage.width*2;
  }
  //---------------------------------      
  if (x2 + backImage.width/2 < 0){
    x2 += backImage.width*2;
  }
}

//draw the back image on the scene
void drawBackImage(){
  image(backImage, x1 , height/2);
  image(backImage, x2 , height/2);
}

//move the walls
void moveWalls(){
  //Move the walls across the screen
  for (int n = 0; n < wallx.length; n++){
    wallx[n] -= 6;
    if (wallx[n] + wallImage.width/2 < 0){
      wallx[n] += 800;
      wally[n] = height + wallImage.height/2- (int)random(50,height-gap);
      
      //keep track of which wall passes the bird when counting the score
      if(n == 0)
        score0 = false;
      if(n == 1)
        score1 = false;
    }
  }
}

//draw the walls on the scene
void drawWalls(){
  image(wallImage, wallx[0],wally[0]);
  image(wallImage, wallx[0], wally[0] - gap - wallImage.height);
  image(wallImage, wallx[1], wally[1]);
  image(wallImage, wallx[1], wally[1] - gap - wallImage.height);
}

//findBest: noInput --> int
//Purpose: to find the bird that lasted the longest
int findBest(){
   int output = 0;
   for (int i = 1; i < birds.length; i++){
      if (birds[i].max > birds[output].max){
         output = i; 
      }
   }
   return output;
}

//findNextWall: noInput --> Int
//Purpose: to determine which wall the bird needs to consider next
int findNextWall(){
   int output;
   IntList loi = new IntList();
   for (int i = 0; i < wallx.length; i++){
      if (wallx[i] > width/2 - birdImage.width)
        loi.append(i);
   }
   if (loi.size() > 1){
      if (wallx[loi.get(0)] > wallx[loi.get(1)])
        output = loi.get(1);
      else
        output = loi.get(0);
   }
   else
     output = loi.get(0);
   return output;
}

//isOver: noInput --> boolean
//Purpose: to determine if the game is over
boolean isOver(){
    boolean output = true;
   for (int i = 0; i < birds.length; i++){
      if (birds[i].state == 0){
          output = false;
          break;
      }
   }
   return output;
}

//swap the birds indexs
void swapBirds(int i, int j){
   bird temp = birds[i];
   birds[i] = birds[j];
   birds[j] = temp;
}

//Add1 to the score if a wall passes the bird
void addScore(){
   if(wallx[0] < width/2 && score0 == false)
    {
      score += 1;
      score0 = true;
    }
  if(wallx[1] < width/2 && score1 == false)
    {
      score += 1;
      score1 = true;
    } 
}
