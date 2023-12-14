var lines = File.ReadAllLines("data.txt").ToList();

for (int i = 0; i < lines.Count; ++i)
{
    var line = lines[i];
    if (line.IndexOf('#') == -1)
    {
        lines.Insert(i + 1, new string('o', line.Length));
        i++;
    }
}

var len = lines[0].Length;
for (int i = 0; i < len; ++i)
{
    bool empty = true;
    for (int j = 0; j < lines.Count; ++j)
    {
        var c = lines[j][i];
        if (c == '#')
        {
            empty = false;
            break;
        }
    }
    if (empty)
    {
        for (int j = 0; j < lines.Count; ++j)
        {
            var line = lines[j];
            lines[j] = line.Insert(i, "o");
        }
        i++;
        len = lines[0].Length;
    }
}

var galaxies = new List<(int, int)>();
for (int i = 0; i < lines.Count; ++i)
{
    for (int j = 0; j < lines[i].Length; ++j)
    {
        var c = lines[i][j];
        if (c == '#')
        {
            galaxies.Add((i, j));
        }
    }
}

ulong sum = 0;
ulong sum2 = 0;
var not = new List<(int, int)>();
foreach (var galaxy in galaxies)
{
    foreach (var other in galaxies)
    {
        if (not.Contains(other)) continue;

        ulong one1 = 0;
        ulong one2 = 0;
        for (int i = Math.Min(galaxy.Item2, other.Item2); i < Math.Max(galaxy.Item2, other.Item2); ++i)
        {
            var c = lines[galaxy.Item1][i];
            if (c == 'o')
            {
                one1++;
            }
        }
        for (int i = Math.Min(galaxy.Item1, other.Item1); i < Math.Max(galaxy.Item1, other.Item1); ++i)
        {
            var c = lines[i][galaxy.Item2];
            if (c == 'o')
            {
                one2++;
            }
        }

        sum += (ulong)(Math.Abs(other.Item1 - galaxy.Item1) + Math.Abs(other.Item2 - galaxy.Item2));
        sum2 += (ulong)(Math.Abs(other.Item1 - galaxy.Item1) + Math.Abs(other.Item2 - galaxy.Item2)) + 999998 * (one1 + one2);
    }
    not.Add(galaxy);
}

Console.WriteLine("Part A: {0}", sum);
Console.WriteLine("Part B: {0}", sum2);
