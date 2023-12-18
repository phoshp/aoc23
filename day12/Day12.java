import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.stream.Collectors;

class Main {
    public static void main(String[] args) throws IOException {
        var lines = Files.readAllLines(Paths.get("data.txt"));
        long p1 = 0;
        long p2 = 0;
        for (var line : lines) {
            line = line.trim();
            var parts = line.split(" ");
            var springs = parts[0];
            var groups = new ArrayList<Integer>();
            for (var g : parts[1].split(",")) {
                groups.add(Integer.valueOf(g.trim()));
            }
            var cache = new LinkedHashMap<String, Long>();
            p1 += search(springs, groups, cache);
            var sp = new ArrayList<String>();
            var gr = new ArrayList<Integer>();
            for (int i = 0; i < 5; i++) {
                sp.add(springs);
                gr.addAll(groups);
            }
            var cache2 = new LinkedHashMap<String, Long>();
            p2 += search(String.join("?", sp), gr, cache2);
        }

        System.out.println("Part A: " + p1);
        System.out.println("Part B: " + p2);
    }

    public static long search(String springs, List<Integer> groups, LinkedHashMap<String, Long> cache) {
        var hash = springs + String.join("|", groups.stream().map(x -> x.toString()).collect(Collectors.toList()));
        if (cache.containsKey(hash)) {
            return cache.get(hash);
        }

        if (groups.isEmpty())
            return springs.contains("#") ? 0 : 1;

        long sum = 0;
        var group = groups.remove(0);
        var len = springs.length();
        var max = len - groups.stream().reduce(0, Integer::sum) - groups.size() - group + 1;
        for (int i = 0; i < max; i++) {
            var s = springs.substring(0, i);
            if (s.contains("#"))
                break;

            var next = group + i;
            var sub = springs.substring(i, Math.min(len, next));
            if (next <= len && !sub.contains(".") && (next == len || springs.charAt(next) != '#')) {
                sum += search(len > (next + 1) ? springs.substring(next + 1) : "", new ArrayList<>(groups), cache);
            }
        }
        cache.put(hash, sum);
        return sum;
    }
}
