function plot3D1(filename,scale)

[data,parameter,title,comment] = userdataread (filename);
surf(data);
caxis([0 scale]);
axis on;
shading interp;

end