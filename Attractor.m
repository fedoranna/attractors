function [A] = Attractor(P)

A = InitializeAttractor(P); 
A = TrainAttractor(A);
A = TestAttractor(A);
