function [l,m] = k2lm(k)
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here
l_list = [1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6];
m_list = [0, 1,-1, 0, 1,-1, 2,-2, 0, 1,-1, 2,-2, 3,-3, 0, 1,-1, 2,-2, 3,-3, 4,-4, 0, 1,-1, 2,-2, 3,-3, 4,-4, 5,-5, 0, 1,-1, 2,-2, 3,-3, 4,-4, 5,-5, 6,-6];
l = l_list(k);
m = m_list(k);
end

