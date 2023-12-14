file = open("data.txt", "r")
time = int("".join(file.readline().split()[1:]))
record = int("".join(file.readline().split()[1:]))

ways = 0
for speed in range(time):
    d = (time - speed) * speed
    if d > record:
        ways = time - 2 * speed + 1
        break
file.close()

print("Part B: ", ways)
