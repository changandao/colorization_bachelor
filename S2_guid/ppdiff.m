function qq = ppdiff(pp,j)
%PPDIFF Differentiate piecewise polynomial.
%   QQ = PPDIFF(PP,J) returns the J:th derivative of a piecewise
%   polynomial PP. PP must be on the form evaluated by PPVAL. QQ is a
%   piecewise polynomial on the same form. Default value for J is 1.
%
%   Example:
%       x = linspace(-pi,pi,9);
%       y = sin(x);
%       pp = spline(x,y);
%       qq = ppdiff(pp);
%       xx = linspace(-pi,pi,201);
%       plot(xx,cos(xx),'b',xx,ppval(qq,xx),'r')
%
%   See also PPVAL, SPLINE, SPLINEFIT, PPINT

%   Author: jonas.lundgren@saabgroup.com, 2009.

if nargin < 1, help ppdiff, return, end
if nargin < 2, j = 1; end

% Check diff order
if ~isreal(j) || mod(j,1) || j < 0
    msgid = 'PPDIFF:DiffOrder';
    message = 'Order of derivative must be a non-negative integer!';
    error(msgid,message)
end

% Get coefficients
coefs = pp.coefs;
[m n] = size(coefs);

if j == 0
    % Do nothing
elseif j < n
    % Derivative of order J
    D = repmat(n-1:-1:j,j,1) - repmat((0:j-1)',1,n-j);
    D = repmat(prod(D,1),m,1);
    coefs = D.*coefs(:,1:n-j);
else
    % Derivative kills PP
    coefs = zeros(m,1);
end

% Set output
qq = pp;
qq.coefs = coefs;
qq.order = size(coefs,2);
