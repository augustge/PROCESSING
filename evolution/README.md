## EVOLUTION

This is a conceptual test of how to train neural networks with evolutionary algorithms. There are three kinds of objects: 
* **Food** Drifting dots that gets absorbed by Prey upon contact. This prolongs the lifetime of Prey.
* **Prey/Boid** Objects whos response to input is determined by an individual, inherited (with mutations), neural network of varying shape. Prey can learn to develop new senses (inputs to neural network) and mutations can create increasing intermediate hidden layers.
* **Predator/Hunterboid** Predators are much like Prey but, as the name suggests, their food source are the Prey. Their possible sensory input also differs from the Pray. For instance, they can never evolve to sense the position of food. 

Run the sketch and have fun studying how the convergence of the different neural networks depends on the various parameters such as number of food,Pray and Predator, mutation probability, life prolongation upon eating, reproductive rate and cost, etc. 
