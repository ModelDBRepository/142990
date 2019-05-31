% Compile cellsxfun.cpp to mex file
mex -o popcode/cellsxfun popcode/cellsxfun.cpp

% Add popcode directory to the path
addpath([pwd '/popcode'])