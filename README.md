# fronde-py
A Fixed-point algorithm for Robust Null Distribution Estimation

To install simply download the fronde.m and add it in matlab path

To get robust variance and mean estimators of null distribution of data sample L

    load('L.mat’)
    [medclip,stdclip] = fronde(L, 20, 0.9 ,true);
