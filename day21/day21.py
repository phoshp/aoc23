from collections import deque

with open("data.txt") as f:
    grid = f.read().splitlines()
    m, n = len(grid[0]), len(grid)
    start = None
    for y, line in enumerate(grid):
        x = line.find('S')
        if x > -1:
            start = (0, x, y)
            break
    open = deque([start])
    closed = {}
    while open:
        i, cx, cy = open.popleft()
        if (cx, cy) in closed:
            continue
        closed[(cx, cy)] = i
        for nx, ny in ((cx-1, cy), (cx+1, cy), (cx, cy+1), (cx, cy-1)):
            if not (0 <= nx < m and 0 <= ny < n) or (nx, ny) in closed or grid[ny][nx] == '#':
                continue
            open.append((i + 1, nx, ny))
    even_in, even_all, odd_all, even_out, odd_out = 0, 0, 0, 0, 0
    for _, i in closed.items():
        if i % 2 == 0:
            even_in += 1 if i <= 64 else 0
            even_out += 1 if i > 65 else 0
            even_all += 1
        else:
            odd_out += 1 if i > 65 else 0
            odd_all += 1
    print("Part 1:", even_in)
    n = (26501365 - (m // 2)) // m
    print("Part 2:", (n + 1) ** 2 * odd_all + n * n
          * even_all - (n + 1) * odd_out + n * even_out)
