// https://twitter.com/voxeledphoton/status/986715424254554112

s=sin
c=cos
t=1
h=64
::_::
cls()
m=sin(t*.1)*1
t+=.01
for i=0,50 do
j=i*.02
line(
    h+c(j-m+t)*s(i*.1)*h,
    h+s(j+t)*c(i*.1)*h,
    h+s(t-m+t)*c(i*.1)*h,
    h+c(t+m)*s(i*.1)*h,7+i*.04
)
end
flip()
goto _ 