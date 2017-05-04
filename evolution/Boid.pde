
class Boid {
  int s                                 = 8;
  float speed                           = 0.1;
  float newIntermediateNeuronProb       = 0.5;
  float newIntermediateNeuronLayerProb  = 0.05;
  int maxAge                            = int(random(boidMaxAge-100,boidMaxAge+100));
  int fertilityAge                      = int(maxAge)+100;
  float maxAngle                        = 0.2;

  float[] r = new float[2];
  int age = 0;
  int t   = 0;
  boolean dead          = false;
  int hasEaten          = 0;
  float speedBoost      = 0;

  float theta;
  Network network;
  Food closest;
  HunterBoid closestHunter;
  Boid otherboid;
  Boid(float x0, float y0, float theta0, Network network) {
    this.r[0] = x0;
    this.r[1] = y0;
    this.theta = theta0;
    this.network  = network;
  }

  void act() {
    this.age += dt; // can be reduced by eating
    this.t   += dt;

    this.respond();
    this.move();
    this.eat();
    this.death();
  }

  void death(){
    // die of aging
    if(this.age>this.maxAge){
      this.dead = true;
    }

  }

  void eat(){
    float dSq = sq(this.closest.r[0]-this.r[0]) + sq(this.closest.r[1]-this.r[1]);
    if( dSq < sq(0.5)*sq(this.s+this.closest.s+this.closest.eatsS*this.closest.eats) ){
      this.closest.eaten();
      this.age -= boidEatgain;
      this.hasEaten += 1;
    }
  }

  boolean reproduction(){
    return this.t>this.fertilityAge && random(100)< 20;
  }

  Network newNetwork(){ // develop mental capacities
    Network newNetwork;
    if(newIntermediateNeuronProb>random(100)){
      if(0.5<random(1)){ //increase inputs
        if(0.5<random(1) && this.network.inputs>1){ // min inputs: 1
          newNetwork = new Network(this.network.inputs-1, this.network.outputs,this.network.stacks,this.network.layers); // remove one input
        }else if(this.network.inputs<maxInputs){ // max inputs: maxInputs
          newNetwork = new Network(this.network.inputs+1, this.network.outputs,this.network.stacks,this.network.layers); // add one input
        }else{
          newNetwork = new Network(this.network.inputs, this.network.outputs,this.network.stacks,this.network.layers);
        }
      }else{
        if(0.5<random(1) && this.network.stacks>1){ // min stacks: 1
          newNetwork = new Network(this.network.inputs, this.network.outputs,this.network.stacks-1,this.network.layers); // remove one stack
        }else if(this.network.stacks<maxStacks){ // max stacks: maxStacksBoid
          newNetwork = new Network(this.network.inputs, this.network.outputs,this.network.stacks+1,this.network.layers); // add one stack
        }else{
          newNetwork = new Network(this.network.inputs, this.network.outputs,this.network.stacks,this.network.layers);
        }
      }
    }else if(newIntermediateNeuronLayerProb>random(100)){
      if(0.5<random(1) && this.network.layers>1){ // min layers: 1
        newNetwork = new Network(this.network.inputs, this.network.outputs,this.network.stacks,this.network.layers-1); // remove one layer
      }else if(this.network.layers<maxLayers){         // max layers: 2
        newNetwork = new Network(this.network.inputs, this.network.outputs,this.network.stacks,this.network.layers+1); // add one layer
      }else{
        newNetwork = new Network(this.network.inputs, this.network.outputs,this.network.stacks,this.network.layers);
      }
    }else{
      newNetwork = new Network(this.network.inputs, this.network.outputs,this.network.stacks,this.network.layers);
    }
    return newNetwork;
  }

  Boid reproduce(){
    Network newNetwork = this.newNetwork();
    newNetwork.makeSimilar(this.network);
    newNetwork = newNetwork.mutate(mutateRange,mutateProb);
    float sx = random(-this.s,this.s);
    float sy = sqrt(sq(s)-sq(sx));
    this.age += boidBirthloss;
    return new Boid(this.r[0]+sx,this.r[1]+sy,random(2*PI),newNetwork);
  }



  void respond(){

    float[] senses = new float[maxInputs];
    senses[0] = ((this.theta+2*PI)%(2*PI))/(2*PI); // self dir
    this.closest = this.findClosestFood();
    senses[1] = atan2(this.closest.r[1]-this.r[1],this.closest.r[0]-this.r[0])/(2*PI); // food dir
    senses[2] = sqrt(sq(this.closest.r[1]-this.r[1])+sq(this.closest.r[0]-this.r[0]))/500.; // distance to food per 500px
    if(this.network.inputs>3){ // to reduce complexity
      this.closestHunter = this.findClosestHunter();
      senses[3] = atan2(this.closestHunter.r[1]-this.r[1],this.closestHunter.r[0]-this.r[0])/(2*PI);       // direction to hunter
      senses[4] = sqrt(sq(this.closestHunter.r[1]-this.r[1])+sq(this.closestHunter.r[0]-this.r[0]))/500.;  // distance to hunter per 500px
      senses[5] = 0.5*this.closestHunter.theta/(2*PI); // direction of hunter
    }
    if(this.network.inputs>6){ // to reduce complexity
      this.otherboid = findClosestBoid();
      senses[6] = sqrt(sq(this.otherboid.r[1]-this.r[1])+sq(this.otherboid.r[0]-this.r[0]))/500.; // distance to closest boid per 500px
      senses[7] = atan2(this.otherboid.r[1]-this.r[1],this.otherboid.r[0]-this.r[0])/(2*PI); // dir to closest boid
      senses[8] = ((this.otherboid.theta+2*PI)%(2*PI))/(2*PI); // dir of closest boid
      senses[9] = this.age/this.maxAge;           // age
    }





    float[] response = this.network.think(senses);
    this.theta      += this.maxAngle*(response[0]-0.5)*dt; // -PI to PI
    this.speedBoost  = 0.5*response[1];
  }



  void move() {

    float dx = cos(this.theta)*(this.speed+this.speedBoost)*dt;
    float dy = sin(this.theta)*(this.speed+this.speedBoost)*dt;

    this.r[0] += dx;
    this.r[1] += dy;

    // periodic boundary
    this.r[0] = (this.r[0]+width)%width;
    this.r[1] = (this.r[1]+height)%height;

    // stiff boundary
    /*
    if(this.r[0]<0){
      this.r[0] = 0;
    }else if(this.r[0]>width){
      this.r[0]=width;
    }
    if(this.r[1]<0){
      this.r[1] = 0;
    }else if(this.r[1]>height){
      this.r[1]=height;
    }
    */

  }

  Boid findClosestBoid(){
    float dSqMin = sq(width);
    Boid closest = boids.get(0);
    for (int i = boids.size()-1; i > 0; i--) {
      Boid boid = boids.get(i);
      float dSq = sq( boid.r[0]-this.r[0] ) + sq( boid.r[1]-this.r[1] );
      if (dSq<dSqMin && boid!=this){
        dSqMin = dSq;
        closest = boid;
      }
    }
    return closest;
  }

  Food findClosestFood(){
    float dSqMin = sq(width);
    Food closest = foods.get(0);
    for (int i = foods.size()-1; i > 0; i--) {
      Food food = foods.get(i);
      float dSq = sq( food.r[0]-this.r[0] ) + sq( food.r[1]-this.r[1] );
      if (dSq<dSqMin){
        dSqMin = dSq;
        closest = food;
      }
    }
    return closest;
  }

  HunterBoid findClosestHunter(){
    float dSqMin = sq(width);
    HunterBoid closest = hunterboids.get(0);
    for (int i = hunterboids.size()-1; i > 0; i--) {
      HunterBoid boid = hunterboids.get(i);
      float dSq = sq( boid.r[0]-this.r[0] ) + sq( boid.r[1]-this.r[1] );
      if (dSq<dSqMin){
        dSqMin = dSq;
        closest = boid;
      }
    }
    return closest;
  }

  void show(color col) {
    strokeWeight(1);
    noStroke();
    if(showHunger){
      fill(100+100*atan(0.01*this.age),100-100*atan(0.01*this.age),0);
    }else{
      fill(col);
    }
    ellipse(this.r[0], this.r[1], this.s, this.s);
    strokeWeight(5);
    if(showHunger){
      stroke(100+100*atan(0.01*this.age),100-100*atan(0.01*this.age),0);
    }else{
      stroke(col);
    }
    line(this.r[0], this.r[1], this.r[0]+0.6*this.s*cos(this.theta), this.r[1]+0.6*this.s*sin(this.theta));

  }

  void showSight(){
    if(this.network.inputs>1){
      strokeWeight(2);
      stroke(0,255,0,80);
      line(this.r[0], this.r[1], this.closest.r[0],this.closest.r[1]);
    }
    if(this.network.inputs>3){
      stroke(255,0,0,80);
      line(this.r[0], this.r[1], this.closestHunter.r[0],this.closestHunter.r[1]);
    }
    if(this.network.inputs>6){
      stroke(0,0,255,80);
      line(this.r[0], this.r[1], this.otherboid.r[0],this.otherboid.r[1]);
    }
  }
}



//
