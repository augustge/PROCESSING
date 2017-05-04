

/*
  MAIN PROBLEM:
    how to increase degrees of freedom further?
    --> * Inherit look (size,color,...) and behaviour (age,reproductivity,...) at expense
          of food value and lifetime. [some energy function needed]
        * Determine friend or foe based on genetic array.

    --> * Allow for Neural comparison as input and attack as response.

    --> * Try to write Hunterboids and Boids as same class.

    @ Subclasses may have different artefacts: Arm, spear, ...

  INPUTS:
    * All neighbours within some scope.
    * more realistic sight: dist, scope.

  OUTPUTS:
    * breed
    * rest

  * conservation of momentum on eat.

*/

int option = 0;

int NumInitialHunterboids = 9;
int NumInitialBoids       = 81;
int numFoods              = 55;
float dt = 8;
float mutateProb         = 0.8;  // percentage of mutated weights
float mutateRange        = 0.8;  // change when mutated
float newMutateProb      = 5;
float newMutateRange     = 1;
float renewalProb        = 4;
float renewalProbHunter  = 4;

float killAxonProb       = 0.1; // kill axon 0.1%

int maxInputs   = 10;
int maxStacks   = 10;
int maxLayers   = 5;

int boidBirthloss       = 100;
int boidEatgain         = 500;
int boidMaxAge          = 900;
int hunterboidBirthloss = 100;
int hunterboidEatgain   = 500;
int hunterMaxAge        = 900;

color backgroundColor       = color(51, 55, 69);
color backgroundColor2      = color(218, 237, 226);
color foodColor             = color(246, 247, 146);
color boidColor             = color(119, 196, 211);
color hunterColor           = color(234, 46, 73);
color buttonFillColor       = color(92, 75, 81);
color buttonHoverColor      = color(218, 237, 226);
color buttonActiveColor     = color(119, 196, 211);
color neuronColor           = color(255);
color textColorMedium       = color(120);
color textColorStrong       = color(246, 247, 146);
color textColorNormal       = color(218, 237, 226);

int trainingCycles        = 15000;  // Highspeed mode
int cyclesPerNeuralDraw   = 10000;  //  when neuromode

int inputsToNetwork           = 4; // initial Boid senses
int outputsFromNetwork        = 2;
int stacksNetwork             = 3;
int layersNetwork             = 1;

int inputsToNetworkHunter     = 4; // initial Hunter senses
int outputsFromNetworkHunter  = 2;
int stacksNetworkHunter       = 3;
int layersNetworkHunter       = 1;


String[] boidInputs =  {
    "Direction of self",
    "Direction to food",
    "Distance to food",
    "Direction to hunter",
    "Distance to hunter",
    "Direction of hunter",
    "Distance to closest boid",
    "Direction to closest boid",
    "Direction of closest boid",
    "Age"
};

String[] hunterInputs =  {
    "Direction of self",
    "Direction to food",
    "Distance to food",
    "Direction of food",
    "Age of self",
    "Speed of self",
    "Self position x",
    "Self position y",
    "Food position x",
    "Food position y"
};

String[] outputs =  {
    "Change in direction of self",
    "Additional speed of self"
};

String[] options = {
  "Draw events",
  "Draw network",
  "Info panel",
  "Highspeed mode",
  "Control panel"
};

// killAxonProb

Button[] buttons = {
  new Button("RESTART",                               100, 80,40,40), // 0
  new Button("Change number of foods",                100,200,20,20), // 1
  new Button("Change number of boids",                100,240,20,20), // 2
  new Button("Change number of hunters",              100,280,20,20), // 3
  new Button("Toggle boid sight",                     100,320,20,20), // 4
  new Button("Toggle hunterboid sight",               100,360,20,20), // 5
  new Button("Toggle hunger",                         100,400,20,20), // 6
  new Button("Change mutation probability",           500, 40,20,20), // 7
  new Button("Change mutation significance",          500, 80,20,20), // 8
  new Button("Change new mutation probability",       500,120,20,20), // 9
  new Button("Change new mutation significance",      500,160,20,20), // 10
  new Button("Change boid renewal probability",       500,200,20,20), // 11
  new Button("Change hunterboid renewal probability", 500,240,20,20), // 12
  new Button("Change kill axon probability",          500,280,20,20), // 13
  new Button("Change timestep",                       100,440,20,20), // 14
  new Button("Change birthloss of boid",              500,360,20,20), // 15
  new Button("Change eatgain of boid",                500,400,20,20), // 16
  new Button("Change birthloss of hunterboid",        500,440,20,20), // 17
  new Button("Change eatgain of hunterboid",          500,480,20,20), // 18
  new Button("Change boids mean hungerbarrier",       500,520,20,20), // 19
  new Button("Change hunterboid mean hungerbarrier",  500,560,20,20) // 20
};

int foodXmin, foodXmax, foodYmin, foodYmax;

ArrayList <HunterBoid> hunterboids;
ArrayList <Boid> boids;
ArrayList <Food> foods;

boolean showNetwork         = false;
boolean showBoidSight       = false;
boolean showHunterboidSight = false;
boolean showHunger          = false;

Boid oldestBoid;
HunterBoid oldestHunterboid;
Network networkOfBestBoid;

void setup() {
  size(displayWidth, displayHeight);

  foodXmin = 0;        // width/3;
  foodXmax = width;    // 2*width/3;
  foodYmin = 0;        // height/3;
  foodYmax = height;   // 2*height/3;

  restart();

  textAlign(CENTER);
  textSize(8);
  strokeWeight(5);
}

void draw() {
  if(option==0){
    cycle(true);
  }else if(option==1){
    drawNeuralNet();
  }else if(option==2){
    drawInfoPanel();
  }else if(option==3){
    highspeedMode(trainingCycles);
  }else if(option==4){
    drawControlPanel();
  }
}







//
