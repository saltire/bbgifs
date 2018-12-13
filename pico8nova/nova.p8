n = 30
t = 0

::∧::
cls()
t += .01
for i = 1, n do
  for j = 1, n do
    x = i - n / 2
    y = j - n / 2
    z = cos(sqrt(64 - (x * x + y * y) * cos(t)) / n - t) * 2
    line(
      i * 4 + cos(z) * z,
      j * 4 + sin(z) * z + z * 8,
      i * 4 + cos(.5 + z) * z,
      j * 4 + sin(.5 + z) * z + z * 8,
      11.5 + z
    )
  end 
end
flip()
goto ∧ 