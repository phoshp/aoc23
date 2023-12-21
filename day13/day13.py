with open("data.txt") as f:
    groups = [x.splitlines() for x in f.read().split('\n\n')]

    def mirror_index(grid: [str], fix: bool = False):
        m = len(grid)
        for i in range(1, m):
            r = min(i, m - i)
            down = grid[i:i + r]
            up = grid[i - r:i][::-1]

            if fix:
                a = 0
                for x in range(len(up)):
                    for y in range(len(up[x])):
                        if up[x][y] != down[x][y]:
                            a += 1
                if a == 1:
                    return i
            elif up == down:
                return i
        return None

    total = 0
    for grid in groups:
        if m := mirror_index(grid):
            total += m * 100
        else:
            vgrid = [str([grid[j][i] for j in range(len(grid))]) for i in range(len(grid[0]))]
            total += mirror_index(vgrid)
    print("Part A:", total)

    total2 = 0
    for grid in groups:
        if m := mirror_index(grid, True):
            total2 += m * 100
        else:
            vgrid = [str([grid[j][i] for j in range(len(grid))]) for i in range(len(grid[0]))]
            total2 += mirror_index(vgrid, True)
    print("Part B:", total2)
