+++
title= "My Introduction to Computational Fluid Dynamics (CFD)"
date= Date(2016,05,07)
categories=["cfd"]
+++

I have been doing a lot of CFD lately. I have quickly learned that the information one can gain from CFD is far more insightful to the physicals then 0D, lumped parameter equations.

One tool I have been using is [Agros2d](http://www.agros2d.org/). It can do 2d axis symmetric and planar PDE problems. Agros2d can handle incompressible steady and unsteady CFD.

As an example, orifice problem has been studied many times. However, it usually isn't studied from the point of view of an axis symmetric CFD.

Here is the model: \figalt{Screenshot from 2016-05-07 00:50:44}{/blog/2016/05/Screenshot-from-2016-05-07-005044.png}

The inlet boundary condition is a max velocity of 1.5m/s with a parabolic profile $(1-\frac{r}{R}^2)*1.5m/s$. R is the radius of the pipe 0.003m.

The Agros2d model is attached here: [Orifice.a2d](/blog/2016/05/Orifice.a2d). You should be able to open the model with Agros2d and hit the "Solve" button in the lower left hand corner.

Below are some the results from the simulation.

\figureHelper{Velocity field near the beginning and throat.}{/blog/2016/05/Plot01.png}{width:530px;}

\figureHelper{Velocity field just past the throat. Notice the re-circulation.}{/blog/2016/05/Plot02.png}{width:855px;}

\figureHelper{Velocity field at the outlet. Notice the recirculation}{/blog/2016/05/Plot03.png}{}

\figureHelper{Velocity along the axis of the pipe (velocity in the z direction).}{/blog/2016/05/Plot04.png}{width:1206px;}

\figureHelper{Velocity color plot at the throat. Notice that there is a dead space between the wall and the stream. The thinnest part of the stream is known as the vena contracta.}{/blog/2016/05/Plot05.png}{width:1206px;}

\figureHelper{This the velocity profile at the center of the throat. It is interesting to see the velocity is in a step shape. The velocity is constant in the stream and near zero otherwise.}{/blog/2016/05/Screenshot-from-2016-05-07-014935.png}{width:1027px;}

\figureHelper{Velocity profile at the start of throat where the fluid is accelerating.}{/blog/2016/05/Screenshot-from-2016-05-07-015138.png}{width:1027px;}

\figureHelper{Velocity profile at the end of the throat.}{/blog/2016/05/Screenshot-from-2016-05-07-015339.png}{width:1033px;}

\figureHelper{Velocity profile at the outlet in the z direction which along the axis of the pipe. Notice the negative velocity part of the profile indicating recirculation.}{/blog/2016/05/Screenshot-from-2016-05-07-015638.png}{width:1039px;}

Hopefully you enjoyed this as much as I did making it.
