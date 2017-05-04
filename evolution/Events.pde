
// ========================================================


void keyPressed(){

    if(option==4 || option==0){ // control panel or show dynamics
      // NUM FOODS
      if(buttons[1].clicked){ // [1]: change numFoods
        if(keyCode==38){ // UP
          numFoods += 1; adjustFoodNumUp();
        }else if(keyCode==40){ // DOWN
          numFoods -= 1; adjustFoodNumDown();
        }
      }
      // NUM BOIDS
      if(buttons[2].clicked){ // [2]: change NumInitialBoids
        if(keyCode==38){ // UP
          NumInitialBoids += 1;
        }else if(keyCode==40){ // DOWN
          NumInitialBoids -= 1;
        }
      }
      // NUM HUNTERBOIDS
      if(buttons[3].clicked){ // [3]: change NumInitialHunterboids
        if(keyCode==38){ // UP
          NumInitialHunterboids += 1;
        }else if(keyCode==40){ // DOWN
          NumInitialHunterboids -= 1;
        }
      }

      // TOGGLE BOIDSIGHT
      if(buttons[4].clicked){ // [4]: toggle boidsight
        showBoidSight = !showBoidSight;
      }

      // TOGGLE BOIDSIGHT
      if(buttons[5].clicked){ // [5]: toggle hunterboidsight
        showHunterboidSight = !showHunterboidSight;
      }

      // TOGGLE HUNGER
      if(buttons[6].clicked){ // [6]: toggle hunger
        showHunger = !showHunger;
      }

      // MUTATION PROB
      if(buttons[7].clicked){ // [7]: change mutation probability
        if(keyCode==38){ // UP
          mutateProb += 0.1;
        }else if(keyCode==40 && mutateProb>0){ // DOWN
          mutateProb -= 0.1;
        }
        mutateProb = int(round(10*mutateProb))/10.;
      }
      // MUTATION SIGNIFICANCE
      if(buttons[8].clicked){ // [8]: change mutation range
        if(keyCode==38){ // UP
          mutateRange += 0.1;
        }else if(keyCode==40 && mutateRange>0){ // DOWN
          mutateRange -= 0.1;
        }
        mutateRange = int(round(10*mutateRange))/10.;
      }
      // NEW MUTATION PROB
      if(buttons[9].clicked){ // [9]: change new mutation probability
        if(keyCode==38){ // UP
          newMutateProb += 0.1;
        }else if(keyCode==40 && newMutateProb>0){ // DOWN
          newMutateProb -= 0.1;
        }
        newMutateProb = int(round(10*newMutateProb))/10.;
      }
      // NEW MUTATION SIGNIFICANCE
      if(buttons[10].clicked){ // [10]: change new mutation range
        if(keyCode==38){ // UP
          newMutateRange += 0.1;
        }else if(keyCode==40 && newMutateRange>0){ // DOWN
          newMutateRange -= 0.1;
        }
        newMutateRange = int(round(10*newMutateRange))/10.;
      }
      // RENEWALPROB BOID
      if(buttons[11].clicked){ // [11]: change boid renewal prob
        if(keyCode==38){ // UP
          renewalProb += 0.5;
        }else if(keyCode==40 && renewalProb>0){ // DOWN
          renewalProb -= 0.5;
        }
        renewalProb = int(round(10*renewalProb))/10.;
      }
      // RENEWALPROB HUNTERBOID
      if(buttons[12].clicked){ // [12]: change hunterboid renewal prob
        if(keyCode==38){ // UP
          renewalProbHunter += 0.5;
        }else if(keyCode==40 && renewalProbHunter>0){ // DOWN
          renewalProbHunter -= 0.5;
        }
        renewalProbHunter = int(round(10*renewalProbHunter))/10.;
      }
      // KILL AXON PROB
      if(buttons[13].clicked){ // [13]: change kill axon prob
        if(keyCode==38){ // UP
          killAxonProb += 0.05;
        }else if(keyCode==40 && killAxonProb>0){ // DOWN
          killAxonProb -= 0.05;
        }
        killAxonProb = int(round(100*killAxonProb))/100.;
      }
      // TIMESTEP
      if(buttons[14].clicked){ // [14]: change timestep
        if(keyCode==38){ // UP
          dt += 0.1;
        }else if(keyCode==40 && dt>0){ // DOWN
          dt -= 0.1;
        }
        dt = int(round(10*dt))/10.;
      }
      // BOID BIRTHLOSS
      if(buttons[15].clicked){ // [15]: change boid birthloss
        if(keyCode==38){ // UP
          boidBirthloss += 10;
        }else if(keyCode==40 && boidBirthloss>0){ // DOWN
          boidBirthloss -= 10;
        }
      }
      // BOID EATGAIN
      if(buttons[16].clicked){ // [16]: change boid eatgain
        if(keyCode==38){ // UP
          boidEatgain += 10;
        }else if(keyCode==40 && boidEatgain>0){ // DOWN
          boidEatgain -= 10;
        }
      }
      // HUNTER BIRTHLOSS
      if(buttons[17].clicked){ // [17]: change hunterboid birthloss
        if(keyCode==38){ // UP
          hunterboidBirthloss += 10;
        }else if(keyCode==40 && hunterboidBirthloss>0){ // DOWN
          hunterboidBirthloss -= 10;
        }
      }
      // HUNTER EATGAIN
      if(buttons[18].clicked){ // [18]: change hunterboid eatgain
        if(keyCode==38){ // UP
          hunterboidEatgain += 10;
        }else if(keyCode==40 && hunterboidEatgain>0){ // DOWN
          hunterboidEatgain -= 10;
        }
      }
      // BOID HUNGERBARRIER
      if(buttons[19].clicked){ // [19]: change boid hungerbarrier
        if(keyCode==38){ // UP
          boidMaxAge += 10;
        }else if(keyCode==40 && boidMaxAge>0){ // DOWN
          boidMaxAge -= 10;
        }
      }
      // HUNTER HUNGERBARRIER
      if(buttons[20].clicked){ // [20]: change hunterboid hungerbarrier
        if(keyCode==38){ // UP
          hunterMaxAge += 10;
        }else if(keyCode==40 && hunterMaxAge>0){ // DOWN
          hunterMaxAge -= 10;
        }
      }

    }


    // 0 Draw events
    // 1 Draw network
    // 2 Info panel
    // 3 Highspeed mode
    // 4 Control Panel

    if(keyCode==78){ // I
      option = 1; // information
    }else if(keyCode==73){ // N
      option = 2; // network
    }else if(keyCode==72){ // H
      option = 3; // highspeed mode
    }else if(keyCode==67){ // C
      option = 4; // control panel
    }else if(keyCode==37){ //LEFT
      option -= 1;
      option = (option+options.length)%options.length;
    }else if(keyCode==39){ //RIGHT
      option += 1;
      option = (option+options.length)%options.length;
    }else if(keyCode==32){ // SPACE
      option = 0;
    }

    if(option==3){
      initiateHigspeedMode();
    }

}


// ========================================================

void mousePressed(){
  // [0] RESTART
  // [1] Change number of foods
  // [2] Change number of boids
  // [3] Change number of hunters
  // [4] Toggle boid sight
  // [5] Toggle hunterboid sight

  // Control Panel
  if(option==4){
      for(int i=0; i<buttons.length; i++){
        if(mouseX>buttons[i].x && mouseX<buttons[i].x+buttons[i].sx && mouseY>buttons[i].y && mouseY<buttons[i].y+buttons[i].sy){
          buttons[i].clicked = !buttons[i].clicked;
        }else{
          buttons[i].clicked = false;
        }
      }
    }
}
