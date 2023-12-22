import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.stream.Collectors;

class Main {

    public static void main(String[] args) throws IOException {
        var lines = Files.readAllLines(Paths.get("data.txt"));
        long p1 = 0;
        long p2 = 0;

        for (var line : lines) {
            var parts = line.split(" ");
            var springs = parts[0];
            var groups = new ArrayList<Integer>();
            for (var g : parts[1].split(",")) {
                groups.add(Integer.valueOf(g));
            }
            var cache = new LinkedHashMap<String, Long>();
            p1 += search(0, springs, groups, cache);
            var sp = new ArrayList<String>();
            var gr = new ArrayList<Integer>();
            for (int i = 0; i < 5; i++) {
                sp.add(springs);
                gr.addAll(groups);
            }
            p2 += search(0, String.join("?", sp), gr, cache);
        }

        System.out.println("Part A: " + p1);
        System.out.println("Part B: " + p2);
    }

    public static long search(int gid, String springs, List<Integer> groups, LinkedHashMap<String, Long> cache) {
        var hash = springs + String.valueOf(gid);
        if (cache.containsKey(hash)) {
            return cache.get(hash);
        }
        if (gid == groups.size())
            return springs.contains("#") ? 0 : 1;

        long res = 0;
        var gs = groups.get(gid);
        var len = springs.length();
        var totalGS = 0;

        for (int i = gid + 1; i < groups.size(); i++) {
            totalGS += groups.get(i);
        }

        var max = len - totalGS - groups.size() + gid - gs + 2;
        for (int i = 0; i < max; i++) {
            var s = springs.substring(0, i);
            if (s.contains("#"))
                break;
            var next = gs + i;
            var sub = springs.substring(i, Math.min(len, next));
            if (next <= len && !sub.contains(".") && (next == len || springs.charAt(next) != '#')) {
                res += search(gid + 1, len > (next + 1) ? springs.substring(next + 1) : "", groups, cache);
            }
        }
        cache.put(hash, res);
        return res;
    }
}
