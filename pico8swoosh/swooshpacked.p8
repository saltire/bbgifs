// https://twitter.com/lexaloffle/status/1052920196497793025

cls()pal(15,1,1)::_::m=t()s=64
for v=0,42 do for u=0,31 do
x,y,c,w=u*4+(v%2)*2,v*3,0,200/(25+cos(m/4)*20)
j,k=s-x+s*cos(m*.5),s-y+s*sin(m*.3)if(j*j+k*k<w*w)then c=7 else
c2=pget(x+rnd(5)-2,y+rnd(5)-2)
if(c2>0)c=c2+1 end
if(c>0)circfill(x,y,1,c)end end
flip()goto _
