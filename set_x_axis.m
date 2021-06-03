function x_axis = set_x_axis(im)
p1 = drawpoint()
hold on
p2 = drawpoint()
x_axis =[p2.Position;p1.Position]
end