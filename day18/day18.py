with open("data.txt") as f:
    lines = [x.split() for x in f.readlines()]
    for j in range(1, 3):
        corners = [(0, 0)]
        borders = 0
        cur = (0, 0)
        for line in lines:
            if j == 1:
                d = line[0]
                n = int(line[1])
            else:
                hex = line[2][1:-1]
                d = {0: 'R', 1: 'D', 2: 'L', 3: 'U'}[int(hex[-1])]
                n = int(hex[1:-1], 16)
            if d == 'R':
                cur = (cur[0] + n, cur[1])
            if d == 'L':
                cur = (cur[0] - n, cur[1])
            if d == 'U':
                cur = (cur[0], cur[1] - n)
            if d == 'D':
                cur = (cur[0], cur[1] + n)
            corners.append(cur)
            borders += n
        area = 0
        for i in range(len(corners) - 1):
            (x1, y1), (x2, y2) = corners[i:i+2]
            area += x1 * y2 - x2 * y1
        area = abs(area) // 2 + (borders // 2 + 1)
        print("Part {}: {}".format(j, area))
