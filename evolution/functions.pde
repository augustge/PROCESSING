
float sigmoid(float x){
  return 1/(1+exp(-x));
}

float regulate(float x){
  if(x>0){
    return x;
  }else{
    return 0;
  }
}


float score(Boid boid){
  return(boid.hasEaten + boid.t);
}

// ================================================================================

void adjustFoodNumUp(){
  while(foods.size()<numFoods){
    foods.add( new Food(random(foodXmin,foodXmax), random(foodYmin,foodYmax)) );
  }
}

void adjustFoodNumDown(){
  while(foods.size()>numFoods){ foods.remove(0); }
}


void restart(){
  boids = new ArrayList <Boid>();
  for (int i=0; i<NumInitialBoids; i++) {
    Network network = new Network(inputsToNetwork, outputsFromNetwork,stacksNetwork,layersNetwork);
    Boid boid = new Boid(random(width), random(height), random(2*PI), network);
    boids.add(boid);
  }

  foods = new ArrayList <Food>();
  for (int i=0; i<numFoods; i++) {
    Food food = new Food(random(foodXmin,foodXmax), random(foodYmin,foodYmax));
    foods.add(food);
  }

  hunterboids = new ArrayList <HunterBoid>();
  for (int i=0; i<NumInitialHunterboids; i++) {
    Network network = new Network(inputsToNetworkHunter, outputsFromNetworkHunter,stacksNetworkHunter,layersNetworkHunter);
    HunterBoid boid = new HunterBoid(random(width), random(height), random(2*PI), network);
    hunterboids.add(boid);
  }
}


// ================================================================================

void drawNeuralNet(){
  background(backgroundColor);

  for(int i=0; i<cyclesPerNeuralDraw; i++){
     cycle(false);
  }

  int sx = 100;
  int sy = 50;
  textAlign(RIGHT);
  textSize(10);
  fill(255);

  // BOID
  translate(180,100);
  textAlign(CENTER);
  textSize(30);
  text("BEST BOIDBRAIN",0.5*(sx*(oldestHunterboid.network.layers+1)-180),-20);
  oldestBoid.network.display(sx,sy);
  strokeWeight(10);
  stroke(neuronColor);
  textAlign(RIGHT);
  textSize(10);
  for(int i=0; i<oldestBoid.network.inputs; i++){
    point(0,sy*i);
    text(boidInputs[i],-10,sy*i+5);
  }
  for(int i=0; i<oldestBoid.network.layers; i++){
    for(int j=0; j<oldestBoid.network.stacks; j++){
      point(sx*(i+1),sy*j);
    }
  }
  for(int i=0; i<oldestBoid.network.outputs; i++){
    point(0,sy*i);
  }

  // HUNTER

  translate(180+sx*(oldestBoid.network.layers+1),0);
  textAlign(CENTER);
  textSize(30);
  text("BEST HUNTERBRAIN",0.5*(sx*(oldestHunterboid.network.layers+2)-180),-20);
  oldestHunterboid.network.display(sx,sy);
  strokeWeight(10);
  stroke(neuronColor);
  textAlign(RIGHT);
  textSize(10);
  for(int i=0; i<oldestHunterboid.network.inputs; i++){
    point(0,sy*i);
    text(hunterInputs[i],-10,sy*i+5);
  }
  for(int i=0; i<oldestHunterboid.network.layers; i++){
    for(int j=0; j<oldestHunterboid.network.stacks; j++){
      point(sx*(i+1),sy*j);
    }
  }
  for(int i=0; i<oldestHunterboid.network.outputs; i++){
    point(0,sy*i);
  }
}



// ================================================================================

void cycle(boolean showIt){

  if(showIt){
    background(backgroundColor);
    noStroke();
  }

  // foods
  for (int i = foods.size()-1; i > 0; i--) {
    Food food = foods.get(i);
    food.move();
    if(showIt){
      food.show();
    }
  }

  // boids
  float maxScore = -1;
  for (int i = boids.size()-1; i > 0; i--) {
    Boid boid = boids.get(i);
    boid.act();
    if(showIt){
      boid.show(boidColor);
      if(showBoidSight){
        boid.showSight();
      }
    }
    if(score(boid)>maxScore){
      maxScore = score(boid);
      oldestBoid = boid;
    }
    if(boid.dead){
      boids.remove(i);
    }
  }

  for (int i = boids.size()-1; i > 0; i--) {
    Boid boid = boids.get(i);
    if(boid.reproduction() && boids.size()<NumInitialBoids){
      Boid newBoid = boid.reproduce();
      boids.add(newBoid);
    }
  }

  if( boids.size()<NumInitialBoids && renewalProb > random(100)){
    Network network = new Network(oldestBoid.network.inputs, oldestBoid.network.outputs,oldestBoid.network.stacks,oldestBoid.network.layers);
    network.makeSimilar(oldestBoid.network);
    network = network.mutate(newMutateRange,newMutateProb);
    float t = random(2*PI);
    boids.add( new Boid(oldestBoid.r[0]+2*cos(t)*oldestBoid.s, oldestBoid.r[1]+2*sin(t)*oldestBoid.s, random(2*PI), network)); // totally new from best
  }

  // hunterboids
  float maxScoreHunter = -1;
  for (int i = hunterboids.size()-1; i > 0; i--) {
    HunterBoid boid = hunterboids.get(i);
    boid.act();
    if(showIt){
      boid.show(hunterColor);
      if(showHunterboidSight){
        boid.showSight();
      }
    }
    if(score(boid)>maxScoreHunter){
      maxScoreHunter = score(boid);
      oldestHunterboid = boid;
    }
    if(boid.dead){
      hunterboids.remove(i);
    }
  }

  for (int i = hunterboids.size()-1; i > 0; i--) {
    HunterBoid boid = hunterboids.get(i);
    if(boid.reproduction() && hunterboids.size()<NumInitialHunterboids){
      HunterBoid newBoid = boid.reproduce();
      hunterboids.add(newBoid);
    }
  }

  if( hunterboids.size()<NumInitialHunterboids && renewalProbHunter > random(100)){
    Network network = new Network(oldestHunterboid.network.inputs, oldestHunterboid.network.outputs,oldestHunterboid.network.stacks,oldestHunterboid.network.layers);
    network.makeSimilar(oldestHunterboid.network);
    network = network.mutate(newMutateRange,newMutateProb);
    float t = random(2*PI);
    hunterboids.add( new HunterBoid(oldestHunterboid.r[0]+2*cos(t)*oldestHunterboid.s, oldestHunterboid.r[1]+2*sin(t)*oldestHunterboid.s, random(2*PI), network)); // totally new from best
  }

}



// ================================================================================


void drawInfoPanel(){
  background(backgroundColor);
  noStroke();
  textSize(20);
  textAlign(LEFT);


  int textX     = 50;
  int textY     = 80;
  int lineSep   = 30;
  fill(textColorStrong);
  text("OPTIONS",textX,50);
  fill(textColorMedium);
  for(int i=0; i<options.length; i++){
    text(options[i],textX,textY+lineSep*i);
  }

  textX += 200;
  fill(textColorStrong);
  text("BOID INPUTS",textX,50);
  fill(textColorMedium);
  for(int i=0; i<boidInputs.length; i++){
    text(boidInputs[i],textX,textY+lineSep*i);
  }

  textX += 350;
  fill(textColorStrong);
  text("HUNTER INPUTS",textX,50);
  fill(textColorMedium);
  for(int i=0; i<hunterInputs.length; i++){
    text(hunterInputs[i],textX,textY+lineSep*i);
  }

  textX += 350;
  fill(textColorStrong);
  text("OUTPUTS [both]",textX,50);
  fill(textColorMedium);
  for(int i=0; i<outputs.length; i++){
    text(outputs[i],textX,textY+lineSep*i);
  }

}

// ================================================================================

void initiateHigspeedMode(){
  resetMatrix();
  noStroke();
  textAlign(CENTER);
  textSize(50);
  fill(0,100);
  rect(0,height-200,width,200);
  fill(255);
  text("HIGHSPEED MODE",width/2,height-100);
}

void highspeedMode(int n){
  for(int i=0; i<n; i++){
    cycle(false);
  }
}


// ================================================================================

void drawControlPanel(){
  background(backgroundColor);
  noStroke();
  textSize(20);
  textAlign(LEFT);

  int boxX     = 50;
  int boxY     = 80;
  int boxb     = 50;

  for(int i=0; i<buttons.length; i++){
    // determine hover
    if(mouseX>buttons[i].x && mouseX<buttons[i].x+buttons[i].sx && mouseY>buttons[i].y && mouseY<buttons[i].y+buttons[i].sy){
      buttons[i].hover = true;
    }else{
      buttons[i].hover = false;
    }
    // show
    buttons[i].show();
  }

  // react to buttonpress
    if(buttons[0].clicked){ // restart
      buttons[0].clicked = false;
      restart();
    }

    // float mutateProb         = 0.8;  // percentage of mutated weights
    // float mutateRange        = 0.8;  // change when mutated
    // float newMutateProb      = 5;
    // float newMutateRange     = 1;
    // float renewalProb        = 2;
    // float renewalProbHunter  = 2;

    // NUM FOODS
    buttons[1].valTxt = "["+str(numFoods-1)+"] ";
    // NUM BOIDS
    buttons[2].valTxt = "["+str(NumInitialBoids-1)+"] ";
    // NUM HUNTERBOIDS
    buttons[3].valTxt = "["+str(NumInitialHunterboids-1)+"] ";
    // TOGGLE BOID SIGHT
    buttons[4].valTxt = "["+str(showBoidSight)+"] ";
    // TOGGLE HUNTERBOID SIGHT
    buttons[5].valTxt = "["+str(showHunterboidSight)+"] ";
    // TOGGLE HUNGER
    buttons[6].valTxt = "["+str(showHunger)+"] ";
    // MUTATE PROB
    buttons[7].valTxt = "["+str(mutateProb)+"] ";
    // MUTATE SIG
    buttons[8].valTxt = "["+str(mutateRange)+"] ";
    // NEW MUTATE PROB
    buttons[9].valTxt = "["+str(newMutateProb)+"] ";
    // NEW MUTATE SIG
    buttons[10].valTxt= "["+str(newMutateRange)+"] ";
    // BOID RENEWAL
    buttons[11].valTxt= "["+str(renewalProb)+"] ";
    // HUNTERBOID RENEWAL
    buttons[12].valTxt= "["+str(renewalProbHunter)+"] ";
    // KILL AXON PROB
    buttons[13].valTxt= "["+str(killAxonProb)+"] ";
    // TIMESTEP
    buttons[14].valTxt= "["+str(dt)+"] ";
    // BOID BIRTHLOSS
    buttons[15].valTxt= "["+str(boidBirthloss)+"] ";
    // BOID EATGAIN
    buttons[16].valTxt= "["+str(boidEatgain)+"] ";
    // HUNTER BIRTHLOSS
    buttons[17].valTxt= "["+str(hunterboidBirthloss)+"] ";
    // HUNTER EATGAIN
    buttons[18].valTxt= "["+str(hunterboidEatgain)+"] ";
    // BOID HUNGERBARRIER
    buttons[19].valTxt= "["+str(boidMaxAge)+"] ";
    // HUNTER HUNGERBARRIER
    buttons[20].valTxt= "["+str(hunterMaxAge)+"] ";

}


//
