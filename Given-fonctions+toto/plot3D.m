function plot3D(filename,scale)

[data,parameter,title,comment] = userdataread (filename);
surf(data);
caxis([0 scale]);
axis off;
shading interp;

end