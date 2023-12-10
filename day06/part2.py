file = open("data.txt", "r")
time = int("".join(file.readline().split()[1:]))
record = int("".join(file.readline().split()[1:]))

ways = 0
for speed in range(time):
    left = time - speed
    d = left * speed
    if d > record:
        a = time - speed
        ways = (a - speed + 1)
        break

file.close()

print("Part B: ", ways)
