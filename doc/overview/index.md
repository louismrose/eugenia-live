Bootstrap your new graphical DSL with EuGENia Live
==================================================
Domain-specific languages (DSLs) play an important role
in model-driven engineering: according to a recent survey of practitioners, DSLs are more widely used than any modelling language except for UML. But just how easy is it to start building your own DSL today?

A possible reason for the popularity of DSLs might be the increasing availability of powerful tools for implementing DSLs. In the Eclipse eco-system, Xtext, GMF and Graphiti allow software engineers to create rich DSLs and generate domain-specific editors. GMF, for example, has been used to produce powerful graphical editors for languages such as [UML](http://wiki.eclipse.org/MDT-UML2Tools) and [Business Process Model and Notation](http://www.bonitasoft.com/overview/bonita-studio).

This power, however, comes at the price of complexity. It takes considerable technical expertise to implement a DSL with GMF and other contemporary model-driven engineering tools. We believe that these tools are difficult to learn (and even harder to master).

To help reduce this learning curve, we've developed a couple of tools. The first, [EuGENia](http://www.eclipse.org/epsilon/doc/eugenia/), automatically generates the low-level models needed to define a GMF editor. The second, [EuGENia Live](http://eugenialive.herokuapp.com/), is a web-based tool for designing graphical DSLs and is the focus of this blog post.


A brief overview of EuGENiA Live
--------------------------------
We have developed EuGENia Live with the aim of reducing the amount of technical expertise required to design a DSL, minimise the amount of time required to change the DSL during its design, and to interoperate with existing model-driven engineering tools, such as EMF, GMF and [Epsilon](http://www.eclipse.org/epsilon).

Some of the key features of EuGENia Live are:

* It runs in your web browser. (There's no software to download and install).
* You can quickly switch between designing your DSL and trying out the editor. (There's no code generation).
* You can export your DSL to Eclipse to generate a powerful GMF-based editor, or to integrate it with model transformation tools.

Designing a seating plan DSL with EuGENia Live
----------------------------------------------
We have used EuGENia Live to rapidly design graphical languages ranging from seating plans to the cell dynamics of prostrate cancer cells. Using the example of a seating plan DSL, let's now take a look at how EuGENia Live works.

The screenshot below shows EuGENia Live's drawing editor, which is used to test a DSL. Here, we're partway through the design of our seating plan DSL. From the palette on the left-hand side of the screen, we can see that we've defined syntax for several domain concepts (tables, male guests, female guests and partners). Properties can be set using the editor at the bottom of the screen.

![Using the drawing editor of EuGENia Live to construct a seating plan, comprising a table and two guests.](../../../../raw/master/doc/overview/img/initial.png)

Let's change the concrete syntax of tables, so that names and numbers are shown on the drawing. Double-clicking on the table in the palette opens the palette editor (shown below). This screen can be used to change the table concept: we can add or remove properties, change its shape or colour, and add a label.

![Using the palette editor of EuGENia Live to edit the table concept by adding a label to it.](../../../../raw/master/doc/overview/img/editor.png)

By adding a couple of additional [EuGENia annotations](http://www.eclipse.org/epsilon/doc/articles/eugenia-gmf-tutorial/), we can specify that tables should have a label, the label should display the name and number of the table, and the label should be placed inside the table's shape:

![The contents of the palette editor of EuGENia Live after adding a label to the table concept.](../../../../raw/master/doc/overview/img/editor-final.png)

When we return to the drawing editor, the table now displays its name and number on the drawing.

![The results of using the palette editor are immediately shown in the drawing editor: the table now has a label.](../../../../raw/master/doc/overview/img/final.png)

Designing a DSL with EuGENia Live normally proceeds precisely in this manner: experimenting with the drawing, identifying a small change to the language, and implementing it by adding or changing EuGENia annotations.

Once the design stabilises, the DSL can be exported to Eclipse by clicking the Export Palette button. From there, we can download an Emfatic file, and follow the instructions to integrate our new DSL with EMF, GMF, or your favourite model transformation tool.

What's next?
------------
EuGENia Live is a continuation of a line of research that we started in 2010, and we plan to work on it for the foreseeable future.

We're currently working to make EuGENia Live easier to use and able to express richer languages. In particular, we're implementing a graphical editor for defining language concepts (so that users don't need to learn EuGENia annotations) and on adding support for users to define syntactic constraints (such as "it's not valid to use a partner link to connect a table to a guest").

You can try the alpha version of EuGENia Live today at [http://eugenialive.herokuapp.com/](http://eugenialive.herokuapp.com/), or find out more by following [@epsilonews](https://www.twitter.com/epsilonews) on Twitter.