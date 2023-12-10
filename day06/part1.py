file = open("data.txt", "r")
times = file.readline().split()[1:]
records = file.readline().split()[1:]

score = 1
for n, time in enumerate(times):
    time = int(time)
    record = int(records[n])
    ways = 0

    for speed in range(time):
        left = time - speed
        d = left * speed
        if d > record:
            ways += 1
    score *= ways

file.close()

print("Part A: ", score)
