t = 1
h = 64

::_::
cls()
m = sin(t * .1)
t += .01
for i = 0, 50 do
  j = i * .02
  line(
    h + cos(j - m + t) * sin(i * .1) * h,
    h + sin(j + t)     * cos(i * .1) * h,
    h + sin(t - m + t) * cos(i * .1) * h,
    h + cos(t + m)     * sin(i * .1) * h, 
    7 + i * .04
  )
end
flip()
goto _ 
