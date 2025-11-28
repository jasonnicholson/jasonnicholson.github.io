---
title: Piston Rings Multiphysics Simulation
date: 2019-05-29
---
## Goal

My main goal is to define the pressure-flow (PQ curve) past piston rings for a known oil and temperature. This is a Fluid-Structure Interaction problem (FSI).

## Background

I am modelling an application very similar to pistons rings in engine although my application has some differences. My rings are not in constant motion like in an engine. My rings are stationary and move sometimes in practice; for this simulation, I am going to ignore their motion.

The fit between the bore diameter and the rings is an interference fit. In the undeformed state, the piston rings interfere with the bore. Below are some pictures to familiarize yourself with the geometry and loading.

![Piston](../piston.png)
![Piston Ring](../piston-ring.jpg)
![Piston Ring Forces](../piston-ring-forces.png)


## Difficulties

This is a tough problem because the fluid mesh will go to zero thickness as the rings expand against the bore. Also, the initial mesh is hard to get setup.

## Research

There are several PhD theses on this topic. I will have to see what they say. My hunch is that an automotive manufacturer supplied the funding so the key details might be missing to protect their intellectual property. I will most likely need to rediscover the keys to solving this problem.

I Expect this to be a longer term project. This is a difficult research project that few engineers can solve. If you want to partner with me on this one, drop me a message via LinkedIn or GitHub.