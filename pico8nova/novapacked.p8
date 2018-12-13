// https://twitter.com/voxeledphoton/status/1032873460563931136

n=30
c,s,t=cos,sin,0::∧::cls()t+=.01
for i=1,n do
for j=1,n do
x,y=i-n/2,j-n/2
z=c(sqrt(64-(x*x+y*y)*c(t))/n-t)*2
line(
i*4+c(z)*z,
j*4+s(z)*z+z*8,
i*4+c(.5+z)*z,
j*4+s(.5+z)*z+z*8,11.5+z)
end end
flip()goto ∧ 