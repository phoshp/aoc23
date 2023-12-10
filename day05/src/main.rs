use std::ops::Range;

static DATA: &str = include_str!("data.txt");

fn main() {
    let (seeds, sections) = parse_data();
    let mut min = i64::MAX;
    for seed in &seeds {
        let mut temp = *seed;
        for sec in &sections {
            'next: for range in &sec.ranges {
                if range.0.contains(&temp) {
                    temp += range.1;
                    break 'next;
                }
            }
        }
        min = min.min(temp);
    }

    println!("Part A: {}", min);

    let mut seed_ranges = Vec::new();
    let mut it = seeds.iter();
    while let Some(&n) = it.next() {
        let n2 = *it.next().unwrap();
        seed_ranges.push(n..(n + n2));
    }

    let mut loc = Vec::new();
    for sr in &seed_ranges {
        let mut remain = vec![("seed-to-soil", sr.clone())];

        while let Some((target, n)) = remain.pop() {
            let mut it = sections.iter().peekable();
            while let Some(sec) = it.next() {
                if sec.name == target {
                    let mut pass = false;
                    let mut ate = Vec::new();
                    for r in &sec.ranges {
                        if n.start < r.0.end && n.end > r.0.start {
                            if n.start >= r.0.start && n.end <= r.0.end {
                                pass = true;
                            }
                            let i = n.start.max(r.0.start);
                            let j = n.end.min(r.0.end);
                            ate.push(i..j);

                            let nextr = (i + r.1)..(j + r.1);
                            if it.len() == 0 {
                                loc.push(nextr);
                            } else {
                                remain.push((it.peek().unwrap().name, nextr));
                            }
                        }
                    }

                    if !pass {
                        let mut j = n.clone();
                        if ate.len() > 1 {
                            j.start = ate.iter().map(|x| x.end).min().unwrap();
                            j.end = ate.iter().map(|x| x.start).max().unwrap();
                        } else if ate.len() == 1 {
                            let o = ate.first().unwrap();
                            j.start = o.end.min(j.start);
                            j.end = o.start.max(j.end);
                        }
                        if j.start < j.end {
                            if it.len() > 0 {
                                remain.push((it.peek().unwrap().name, j));
                            } else {
                                loc.push(j);
                            }
                        }
                    }
                }
            }
        }
    }
    let min2 = loc
        .iter()
        .map(|x| x.clone().min().unwrap())
        .min()
        .expect("MISSION IMPOSSIBLE!");

    println!("Part B: {}", min2);
}

struct Section {
    name: &'static str,
    ranges: Vec<(Range<i64>, i64)>,
}

fn parse_data() -> (Vec<i64>, Vec<Section>) {
    let mut data = DATA.split("\n\n");
    let seeds: Vec<i64> = data
        .next()
        .unwrap()
        .split(" ")
        .skip(1)
        .map(|s| s.parse().unwrap())
        .collect();
    let sections: Vec<_> = DATA
        .split("\n\n")
        .map(|part| {
            let mut lines = part.lines();
            let name = lines.next().unwrap().split_once(" ").unwrap().0;
            let mut ranges = Vec::new();

            while let Some(line) = lines.next() {
                let mut it = line.split(" ");
                let dst: i64 = it.next().unwrap().parse().unwrap();
                let src: i64 = it.next().unwrap().parse().unwrap();
                let len: i64 = it.next().unwrap().parse().unwrap();

                ranges.push((src..(src + len), dst - src));
            }

            return Section { name, ranges };
        })
        .collect();
    (seeds, sections)
}
