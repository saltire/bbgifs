# https://twitter.com/yuruyurau/status/1226843640040812546

W=540;N=200;x,y,t=0,0,0
def setup():size(W,W);noStroke()
def draw():global t;clear();[F(i,j)for i in range(N)for j in range(N)];t+=.06
def F(i,c):global x,y;u=sin(i+y)+sin(i+x);v=cos(i+y)+cos(i+x);x=u+t;y=v;fill(c,i,150);circle(u*N/2+W/2,y*N/2+W/2,sin(c))
#つぶやきProcessing
