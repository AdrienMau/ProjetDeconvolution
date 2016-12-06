function analyseMIA(filename,synfile,dicfile,maxblink,distmax,deco)


till=65;
sizepixel=173;


affectsynapsesMIA(filename,synfile,maxblink,distmax,1,1,deco,1);
extractsynPCSMIA(filename,synfile,dicfile,till,sizepixel,1)
end