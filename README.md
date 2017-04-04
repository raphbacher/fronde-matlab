# fronde-py
A Fixed-point algorithm for Robust Null Distribution Estimation

This simple and fast method allows to estimate in a robust way the median and the standard deviation under the null hypothesis of data samples that can be contaminated by a source signal. It is a σ-clipping algorithm based on a fixed-point approach.


To install simply download the fronde.m and add it in matlab path.

To get robust variance and mean estimators of null distribution of data sample L

    load('L.mat’)
    [medclip,stdclip] = fronde(L, 20, 0.9 ,true);
