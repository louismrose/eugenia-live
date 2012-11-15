EuGENia Live
============

EuGENia Live aims to reduce the time and effort required to design graphical domain-specific languages. We have used EuGENia Live to rapidly design graphical languages for seating plans, and for modelling cell dynamics for prostrate cancer researchers.

You might be wondering why we have used EuGENia Live in preference to a graphical modelling tool such as GMF or Graphiti from the Eclipse eco-system. As we describe in our XM 2012 paper, we've found GMF and Graphiti to be extremely powerful for implementing DSLs, but their expressiveness and customisation options also make these tools difficult to learn (and even harder to master).

The learning curve of tools like GMF or Graphiti has arguably been dramatically reduced by tools such as Spray (for Graphiti), or our previous work on EuGENia (for GMF). Spray and EuGENia are front-ends for GMF and Graphiti, and use model transformation and code generation to hide some of the complexities of the underlying graphical modelling tools.



Installation
============

1. Install NPM (by [installing Node.js](http://nodejs.org/)).
2. Clone this Git repository.
3. Launch the development server: `./server.sh`