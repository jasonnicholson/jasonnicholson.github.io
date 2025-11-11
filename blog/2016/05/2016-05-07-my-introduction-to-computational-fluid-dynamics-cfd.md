+++
title= "My Introduction to Computational Fluid Dynamics (CFD)"
date= Date(2016,05,07)
categories=["cfd"]
+++

I have been doing a lot of CFD lately. I have quickly learned that the information one can gain from CFD is far more insightful to the physicals then 0D, lumped parameter equations.

One tool I have been using is [Agros2d](http://www.agros2d.org/). It can do 2d axis symmetric and planar PDE problems. Agros2d can handle incompressible steady and unsteady CFD.

As an example, orifice problem has been studied many times. However, it usually isn't studied from the point of view of an axis symmetric CFD.

Here is the model:[![Screenshot from 2016-05-07 00:50:44](images/Screenshot-from-2016-05-07-005044.png)](https://www.jasonhnicholson.com/wp-content/uploads/2016/05/Screenshot-from-2016-05-07-005044.png)

The inlet boundary condition is a max velocity of 1.5m/s with a parabolic profile (1-(r/R)^2)\*1.5m/s. R is the radius of the pipe 0.003m.

The Agros2d model is attached here: [Orifice.a2d](http://jasonhnicholson.com/attachments/Orifice.a2d). You should be able to open the model with Agros2d and hit the "Solve" button in the lower left hand corner.

Below are some the results from the simulation.

\[caption id="attachment\_78" width="530"\][![Plot01](images/Plot01.png)](https://www.jasonhnicholson.com/?attachment_id=78) Velocity field near the beginning and throat.\[/caption\]

\[caption id="attachment\_79" width="855"\][![Plot02](images/Plot02.png)](https://www.jasonhnicholson.com/?attachment_id=79) Velocity field just past the throat. Notice the re-circulation.\[/caption\]

\[caption id="attachment\_80" width="855"\][![Velocity field at the outlet. Notice the recirculation](images/Plot03.png)](https://www.jasonhnicholson.com/?attachment_id=80) Velocity field at the outlet. Notice the recirculation\[/caption\]

.

\[caption id="attachment\_81" width="1206"\][![Velocity along the axis of the pipe (velocity in the z direction).](images/Plot04.png)](https://www.jasonhnicholson.com/?attachment_id=81) Velocity along the axis of the pipe (velocity in the z direction).\[/caption\]

\[caption id="attachment\_83" width="1206"\][![Velocity color plot at the throat. Notice that there is a dead space between the wall and the stream. The thinniest part of the stream is known as the vena contracta. See the next picture to see the velocity profile across the center of the throat.](images/Plot05.png)](https://www.jasonhnicholson.com/?attachment_id=83) Velocity color plot at the throat. Notice that there is a dead space between the wall and the stream. The thinnest part of the stream is known as the vena contracta. See the next picture to see the velocity profile across the center of the throat.\[/caption\]

\[caption id="attachment\_85" width="1027"\][![Plot07](images/Screenshot-from-2016-05-07-014935.png)](https://www.jasonhnicholson.com/?attachment_id=85) This the velocity profile at the center of the throat. It is interesting to see the velocity is in a step shape. The velocity is constant in the stream and near zero otherwise.\[/caption\]

\[caption id="attachment\_86" width="1027"\][![Velocity profile at the start of throat where the fluid is accelerating.](images/Screenshot-from-2016-05-07-015138.png)](https://www.jasonhnicholson.com/?attachment_id=86) Velocity profile at the start of throat where the fluid is accelerating.\[/caption\]

\[caption id="attachment\_87" width="1033"\][![Velocity profile at the end of the throat.](images/Screenshot-from-2016-05-07-015339.png)](https://www.jasonhnicholson.com/?attachment_id=87) Velocity profile at the end of the throat.\[/caption\]

\[caption id="attachment\_88" width="1039"\][![Velocity profile at the outlet in the z direction which along the axis of the pipe. Notice the negative velocity part of the profile indicating recirculation.](images/Screenshot-from-2016-05-07-015638.png)](https://www.jasonhnicholson.com/?attachment_id=88) Velocity profile at the outlet in the z direction which along the axis of the pipe. Notice the negative velocity part of the profile indicating recirculation.\[/caption\]

Hopefully you enjoyed this as much as I did making it.
