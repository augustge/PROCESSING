

class Food{
  int normalEats = 2;
  int eats = 2;
  float[] r = new float[2];
  float theta = 0;
  int eatsS = 2;
  int s = 3;
  Food(float x, float y){
    this.r[0] = x;
    this.r[1] = y;
  }

  void move(){
    this.theta += random(-0.1,0.1)*dt;
    this.r[0] += 0.1*cos(this.theta)*dt;
    this.r[1] += 0.1*sin(this.theta)*dt;

    this.r[0] = (this.r[0]+width)%width;
    this.r[1] = (this.r[1]+height)%height;

  }

  void eaten(){
    this.eats -= 1;
    if( eats<=0 ){
      this.r[0] = random(foodXmin,foodXmax);
      this.r[1] = random(foodYmin,foodYmax);
      this.eats = normalEats;
    }
  }

  void show(){
    fill(foodColor);
    ellipse(this.r[0],this.r[1],this.s+this.eatsS*this.eats,this.s+this.eatsS*this.eats);
  }

}
