# https://twitter.com/yuruyurau/status/1226846058728177665

W=540;N=200;x,y,t=0,0,0
def setup():size(W,W);noStroke()
def draw():global t;clear();[F(i,j)for i in range(N)for j in range(N)];t+=.1
def F(i,c):global x,y;r=TAU/N;u=sin(i+y)+sin(r*i+x);v=cos(i+y)+cos(r*i+x);x=u+t;y=v;fill(i,c,99);circle(u*N/2+W/2,y*N/2+W/2,2) #つぶやきProcessing
