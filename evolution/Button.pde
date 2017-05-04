
class Button{
  int textsize = 20;
  boolean clicked = false;
  boolean hover   = false;
  int x, y, sx, sy;
  color fillC         = buttonFillColor;
  color fillHover     = buttonHoverColor;
  color textC         = textColorNormal ;
  color activeC       = buttonActiveColor;
  String text;
  String valTxt = "";
  Button(String text,int x,int y,int sx, int sy){
    this.x = x;
    this.y = y;
    this.sx = sx;
    this.sy = sy;
    this.text = text;
  }

  void setColors(color fillC, color fillHover, color textC){
    this.fillC = fillC;
    this.fillHover = fillHover;
    this.textC = textC;
  }

  void show(){
    noStroke();
    if(this.clicked){
      fill(this.activeC);
    }else if(this.hover){
      fill(this.fillHover);
    }else{
      fill(this.fillC);
    }
    pushMatrix();
    translate(this.x,this.y);

    rect(0,0,this.sx,this.sy);

    fill(this.textC);
    textSize(this.textsize);
    textAlign(LEFT);
    text(this.text,10+this.sx,0.5*(this.sy+this.textsize));
    textAlign(RIGHT);
    fill(textColorStrong);
    text(this.valTxt,-10,0.5*(this.sy+this.textsize));

    popMatrix();
  }
}
