
/*
  Idea:
    Do not order neurons in a stack. Every neuron can form connection to every other neuron.
    Some special subclasses InputNeuron and OutputNeuron exist, which are connected to the Network class.
    Complexity may increase by changing number of passes neuron0 --> out, for neuron1 as each out: neuron1 --> out;
    NEURON:
      form connection to 
*/

class Network {
  int inputs, outputs, stacks, layers;
  Neuron[][] neurons;
  Neuron[] finalNeurons;
  float[] out;
  Network(int inputs, int outputs, int stacks, int layers) {
    this.inputs  = inputs;
    this.stacks  = stacks;
    this.outputs = outputs;
    this.layers  = layers;
    this.out = new float[outputs];
    this.neurons = new Neuron[stacks][layers];
    this.finalNeurons = new Neuron[outputs];
    // every layer has 'stacks' neurons
    for (int i=0; i<stacks; i++) {
      // first takes 'input' inputs
      this.neurons[i][0] = new Neuron(inputs);
      // rest takes 'stacks' inputs
      for (int j=1; j<layers; j++) {
        this.neurons[i][j] = new Neuron(stacks,i,1);
      }
    }
    for (int i=0; i<outputs; i++) {
        this.finalNeurons[i] = new Neuron(stacks);
    }

  }

  void makeSimilar(Network network){
    // every layer has 'stacks' neurons
    for (int i=0; i<min(network.stacks,this.stacks); i++) {
      // first takes 'input' inputs
      this.neurons[i][0].similarTo(network.neurons[i][0]);
      // rest takes 'stacks' inputs
      for (int j=1; j<min(network.layers,this.layers); j++) {
        this.neurons[i][j].similarTo(network.neurons[i][j]);
      }
    }
    for (int i=0; i<min(network.outputs,this.outputs); i++) {
        this.finalNeurons[i].similarTo(network.finalNeurons[i]);
    }
  }

  float[] think(float[] input) {
    // first layer
    for (int i=0; i<this.stacks; i++) { // each neuron
      this.neurons[i][0].initialize();
      for (int k=0; k<this.inputs; k++) { // each input
        this.neurons[i][0].intputFrom(k,input[k]);
      }
      // apply sigmoid
      this.neurons[i][0].wrapValue();
    }

    // for each deeper layer
    for (int n=1; n<this.layers; n++) { // each layer (except last)
      for (int i=0; i<this.stacks; i++) { // each neuron
        this.neurons[i][n].initialize();
        for (int k=0; k<this.stacks; k++) { // each input
          this.neurons[i][n].intputFrom(k,this.neurons[k][n-1].call());
        }
        // apply sigmoid
        this.neurons[i][n].wrapValue();
      }
    }

    // for last layer
    for (int i=0; i<this.outputs; i++) { // each neuron
      this.finalNeurons[i].initialize();
      for (int k=0; k<this.stacks; k++) { // each input
        this.finalNeurons[i].intputFrom(k,this.neurons[k][this.layers-1].call());
      }
      // apply sigmoid
      this.finalNeurons[i].wrapValue();
      this.out[i] = regulate(this.finalNeurons[i].call());
    }
    return this.out;
  }

  Network mutate(float m, float p){
    for (int i=0; i<this.stacks; i++) {
      // first takes 'input' inputs
      this.neurons[i][0].mutate(m,p);
      // rest takes 'stacks' inputs
      for (int j=1; j<this.layers; j++) {
        this.neurons[i][j].mutate(m,p);
      }
    }
    for (int i=0; i<this.outputs; i++) {
        this.finalNeurons[i].mutate(m,p);
    }
    return this;
  }

  void display(int sx, int sy){
    // every layer has 'stacks' neurons
    for (int i=0; i<stacks; i++) {
      // first takes 'input' inputs
      this.neurons[i][0].display(0,i,sx,sy);
      // rest takes 'stacks' inputs
      for (int j=1; j<layers; j++) {
        this.neurons[i][j].display(j,i,sx,sy);
      }
    }
    for (int i=0; i<outputs; i++) {
        this.finalNeurons[i].display(layers,i,sx,sy);
    }
  }

}

// ========================================================================

class Neuron {
  float[] W;
  int inputs;
  float value = 0;
  Neuron(int in) {
    this.inputs  = in;
    this.W = new float[in];
    for (int i=0; i<in; i++) {
      this.W[i] = 0; //int(round(random(-1, 1)));
    }
  }

  Neuron(int in, int j, float val) {
    this.inputs  = in;
    this.W = new float[in];
    for (int i=0; i<in; i++) {
      this.W[i] = 0; //int(round(random(-1, 1)));
    }
    this.W[j] = val;
  }

  void initialize() {
    this.value = 0;
  }

  void wrapValue() {
    this.value = sigmoid(this.value);
  }

  void similarTo(Neuron neuron){
    for (int i=0; i<min(neuron.inputs,this.inputs); i++) {
        this.W[i] = neuron.W[i];
    }
  }

  float call() {
    return this.value;
  }

  void intputFrom(int i, float val) {
    this.value += this.W[i]*val;
  }

  void mutate(float m,float p){
    for (int i=0; i<this.inputs; i++) {
      if(random(100)<p){
        if(random(100)<killAxonProb){
          this.W[i] = 0.0;
        }else{
          float a = this.W[i]+random(-m,m);
          this.W[i] = a;
        }
      }
    }
  }

  void display(int n,int m,int sx,int sy){
    for (int i=0; i<this.inputs; i++){
      if(atan(this.W[i])<0){
        strokeWeight(5*atan(-this.W[i]));
        stroke(255,0,0,180);
      }else{
        strokeWeight(5*atan(this.W[i]));
        stroke(0,255,0,180);
      }
      noFill();
      bezier(sx*n,sy*i, sx*n,sy*(i+0.5*(m-i) ), sx*(n+1),sy*(m-0.5*(m-i)), sx*(n+1),sy*m);
      //line(sx*n,sy*i, sx*(n+1),sy*m);
    }
  }
}
