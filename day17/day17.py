import heapq

with open("data.txt") as f:
    u = f.read().strip().split('\n')
    grid = [[int(u[y][x]) for y in range(len(u))] for x in range(len(u[0]))]
    m, n = len(grid[0]), len(grid)

    dirs = [(-1, 0), (1, 0), (0, 1), (0, -1)]
    queue = [(0, 0, 0, 0, 0, 0)]
    closed = set()
    while queue:
        loss, x, y, dx, dy, dc = heapq.heappop(queue)
        if x == m-1 and y == n-1:
            break
        if (x, y, dx, dy, dc) in closed:
            continue
        closed.add((x, y, dx, dy, dc))
        for ndx, ndy in dirs:
            nx, ny = x + ndx, y + ndy
            straight = (dx == ndx and dy == ndy)

            if (ndx == -dx and ndy == -dy) or (straight and dc == 3) or nx < 0 or ny < 0 or nx == m or ny == n:
                continue
            heapq.heappush(queue, (loss + grid[nx][ny], nx, ny, ndx, ndy, dc + 1 if straight else 1))
    print("Part 1:", loss)

    queue = [(0, 0, 0, 0, 0, 0)]
    closed = set()
    while queue:
        loss, x, y, dx, dy, dc = heapq.heappop(queue)
        if x == m-1 and y == n-1:
            if dc < 4:
                continue
            break
        if (x, y, dx, dy, dc) in closed:
            continue
        closed.add((x, y, dx, dy, dc))
        for ndx, ndy in dirs:
            nx, ny = x + ndx, y + ndy
            straight = (dx == ndx and dy == ndy) or (dx == 0 and dy == 0)

            if (dc < 4 and not straight) or (ndx == -dx and ndy == -dy) or (straight and dc == 10) or nx < 0 or ny < 0 or nx == m or ny == n:
                continue
            heapq.heappush(queue, (loss + grid[nx][ny], nx, ny, ndx, ndy, dc + 1 if straight else 1))
    print("Part 2:", loss)
