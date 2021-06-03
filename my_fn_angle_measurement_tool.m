function current_axis = my_fn_angle_measurement_tool(im,current_axis)

% Display image in the axes % Display image
imshow(im)
if isempty(current_axis)
    x_axis=set_x_axis(im);
    
    % Get size of image.
    m = size(im,1);
    n = size(im,2);
    
    % Get center point of image for initial positioning.
    midy = ceil(m/2);
    midx = ceil(n/2);
    
    % Position first point vertically above the middle.
    firstx = midx;
    firsty = midy - ceil(m/4);
    lastx = midx + ceil(n/4);
    lasty = midy;
    current_axis = [x_axis;lastx,lasty]
end
% Create a two-segment right-angle polyline centered in the image.
h = impoly(gca,current_axis,'Closed',false);
api = iptgetapi(h);
% Display initial position
updateAngle(current_axis);

% set up callback to update angle in title.
api.addNewPositionCallback(@updateAngle);
fcn = makeConstrainToRectFcn('impoly',get(gca,'XLim'),get(gca,'YLim'));
api.setPositionConstraintFcn(fcn);
%

% Callback function that calculates the angle and updates the title.
% Function receives an array containing the current x,y position of
% the three vertices.
function t=updateAngle(p)
% Create two vectors from the vertices.
% v1 = [x1 - x2, y1 - y2]
% v2 = [x3 - x2, Y3 - y2]
global current_axis;
global angle_degrees;
current_axis = p;
v1 = [p(1,1)-p(2,1), p(1,2)-p(2,2)];
v2 = [p(3,1)-p(2,1), p(3,2)-p(2,2)];
% Find the angle.
theta = acos(dot(v1,v2)/(norm(v1)*norm(v2)));
% Convert it to degrees.
if det([v1;v2])<=0
    angle_degrees = (theta * (180/pi));
else
    angle_degrees =360-(theta * (180/pi));
end


% Display the angle in the title of the figure.
t=sprintf('(%1.0f) degrees',angle_degrees);
title(t)
