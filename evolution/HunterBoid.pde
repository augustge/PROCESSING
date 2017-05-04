
class HunterBoid extends Boid{
  Boid closest;

  HunterBoid(float x0, float y0, float theta0, Network network){
    super(x0,y0,theta0,network);
    this.s            = 15;
    this.speed        = 0.0;
    this.maxAge       = int(random(hunterMaxAge-100,hunterMaxAge+100));
    this.fertilityAge = int(this.maxAge)+100;
  }

  void eat(){
    float dSq = sq(this.closest.r[0]-this.r[0]) + sq(this.closest.r[1]-this.r[1]);
    if( dSq < sq(0.5)*sq(this.s+this.closest.s) ){
      this.closest.dead = true;
      this.age -= hunterboidEatgain;
      this.hasEaten += 1;
      // change momentum when eating:
      //this.v[0] = (this.s*this.v[0]+this.closest.s*cos(this.closest.theta))/(this.s+this.closest.s);
      //this.v[1] = (this.s*this.v[1]+this.closest.s*sin(this.closest.theta))/(this.s+this.closest.s);
    }
  }


  HunterBoid reproduce(){
    Network newNetwork = this.newNetwork();
    newNetwork.makeSimilar(this.network);
    newNetwork = newNetwork.mutate(mutateRange,mutateProb);
    float sx = random(-this.s,this.s);
    float sy = sqrt(sq(s)-sq(sx));
    this.age += hunterboidBirthloss;
    return new HunterBoid(this.r[0]+sx,this.r[1]+sy,random(2*PI),newNetwork);
  }

  void act() {
    this.age += dt; // can be reduced by eating
    this.t   += dt;


    this.respond();
    this.move();
    this.eat();
    this.death();
  }

  void respond(){
    float[] senses = new float[maxInputs];
    senses[0] = ((this.theta+2*PI)%(2*PI))/(2*PI);                                         // self dir
    this.closest = this.findClosestBoid();
    senses[1] = atan2(this.closest.r[1]-this.r[1],this.closest.r[0]-this.r[0])/(2*PI);     // dir food
    senses[2] = sqrt( sq(this.closest.r[0]-this.r[0]) + sq(this.closest.r[1]-this.r[1]) ); // dist to food pr 500 px
    senses[3] = ((this.closest.theta+2*PI)%(2*PI))/(2*PI);                                 // closest dir
    senses[4] = this.age/this.maxAge;                                                      // self age
    senses[5] = this.speedBoost;                                                           // self speed
    senses[6] = 2*(this.r[0]/float(width)-0.5);                                            // self x
    senses[7] = 2*(this.r[1]/float(height)-0.5);                                           // self y
    senses[8] = 2*(this.closest.r[0]/width-0.5);                                           // food x
    senses[9] = 2*(this.closest.r[1]/height-0.5);                                          // food y


    float[] response = this.network.think(senses);
    this.theta      += this.maxAngle*(response[0]-0.5)*dt; // -PI to PI
    this.speedBoost  = 0.6*response[1];
  }

  void showSight(){
    if(this.network.inputs>1){
      strokeWeight(2);
      stroke(0,80);
      line(this.r[0], this.r[1], this.closest.r[0],this.closest.r[1]);
    }
  }

}
