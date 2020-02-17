# https://twitter.com/yuruyurau/status/1227244326301757441

W=540;N=200;x,y,t=0,0,9
def setup():size(W,W);noStroke()
def draw():global t;clear();[F(i,j)for i in range(N)for j in range(N)];t+=.1
def F(i,c):global x,y;u=sin(i+y)+sin(c/N*PI+x);v=cos(i+y)+cos(c/N*PI+x);x=u+t;y=v+t;fill(i,c,99);circle(u*N/2+W/2,v*N/2+W/2,2)
#つぶやきProcessing

# +/ blendMode(ADD) & fill(RGB, 50)
