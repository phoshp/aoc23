with open("data.txt") as f:
    grid = [list(x) for x in f.read().splitlines()]
    m, k = len(grid[0]), len(grid)

    def next(c: (int, int, int, int)) -> [(int, int)]:
        t = grid[c[1]][c[0]]
        if t == '/':
            return [(-c[3], 0) if c[2] == 0 else (0, -c[2])]
        if t == '\\':
            return [(c[3], 0) if c[2] == 0 else (0, c[2])]
        if t == '|' and c[2] != 0:
            return [(0, c[2]), (0, -c[2])]
        if t == '-' and c[3] != 0:
            return [(c[3], 0), (-c[3], 0)]
        return [(c[2], c[3])]

    def start(s: (int, int, int, int)) -> int:
        used = {}
        energized = {}
        lights = [s]
        while len(lights) > 0:
            light = lights.pop()
            if not (0 <= light[0] < m and 0 <= light[1] < k):
                continue
            sub = next(light)
            if light not in used:
                used[light] = True
                energized[(light[0], light[1])] = True
                lights.append((light[0] + sub[0][0], light[1] +
                               sub[0][1], sub[0][0], sub[0][1]))
            if len(sub) == 2:
                lights.append((light[0], light[1], sub[1][0], sub[1][1]))
        return len(energized)

    print("Part 1:", start((0, 0, 1, 0)))
    starts = []
    starts += [(x, 0, 0, 1) for x in range(m)]
    starts += [(x, k, 0, -1) for x in range(m)]
    starts += [(0, x, 1, 0) for x in range(k)]
    starts += [(m, x, -1, 0) for x in range(k)]
    max = 0
    for s in starts:
        e = start(s)
        max = e if e > max else max
    print("Part 2:", max)
