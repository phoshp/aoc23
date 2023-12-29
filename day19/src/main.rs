use std::collections::VecDeque;

const DATA: &str = include_str!("data.txt");

#[derive(Debug)]
enum Condition {
    LowerThan {
        i: usize,
        no: u64,
        dest: &'static str,
    },
    GreaterThan {
        i: usize,
        no: u64,
        dest: &'static str,
    },
    Goto(&'static str),
}

#[derive(Debug)]
struct Workflow {
    name: &'static str,
    conds: Vec<Condition>,
}

fn main() {
    let (workflows, parts) = parse();
    let mut accepted = Vec::new();

    for part in parts {
        let mut cur = "in";
        let help = |&x| match x {
            0 => part.0,
            1 => part.1,
            2 => part.2,
            3 => part.3,
            _ => unreachable!()
        };
        'outer: loop {
            let workflow = workflows.iter().find(|x| x.name == cur).unwrap();
            for cond in &workflow.conds {
                let prev = cur;
                cur = match cond {
                    Condition::LowerThan { i, no, dest } if help(i) < *no => dest,
                    Condition::GreaterThan { i, no, dest } if help(i) > *no => dest,
                    Condition::Goto(go) => go,
                    _ => cur,
                };
                if cur == "A" {
                    accepted.push(part);
                    break 'outer;
                } else if cur == "R" {
                    break 'outer;
                } else if cur != prev {
                    break;
                }
            }
        }
    }
    println!("Part 1: {}", accepted.iter().map(|(x, m, a, s)| x + m + a + s).sum::<u64>());

    let mut accepted2: u64 = 0;
    let mut q = VecDeque::new();
    q.push_back(("in", [1..=4000, 1..=4000, 1..=4000, 1..=4000]));

    while let Some((work, mut vars)) = q.pop_front() {
        match work {
            "A" => {
                accepted2 += vars.iter().map(|x| x.end() - x.start() + 1).product::<u64>();
                continue;
            },
            "R" => continue,
            _ => {
                let flow = workflows.iter().find(|w| w.name == work).unwrap();
                for cond in &flow.conds {
                    match cond {
                        Condition::LowerThan { i, no, dest } => {
                            let t = vars.get(*i).unwrap();
                            if t.end() < no {
                                q.push_back((dest, vars.clone()));
                            } else if no > t.start() {
                                let mut xv = vars.clone();
                                let tn = xv.get_mut(*i).unwrap();
                                *tn = (*t.start())..=(*no - 1);
                                q.push_back((dest, xv));

                                let mut lv = vars.clone();
                                *lv.get_mut(*i).unwrap() = *no..=*t.end();
                                vars = lv
                            }
                        },
                        Condition::GreaterThan { i, no, dest } => {
                            let t = vars.get(*i).unwrap();
                            if t.start() > no {
                                q.push_back((dest, vars.clone()));
                            } else if no < t.end() {
                                let mut xv = vars.clone();
                                let tn = xv.get_mut(*i).unwrap();
                                *tn = (*no + 1)..=*t.end();
                                q.push_back((dest, xv));

                                let mut lv = vars.clone();
                                *lv.get_mut(*i).unwrap() = *t.start()..=*no;
                                vars = lv
                            }
                        },
                        Condition::Goto(go) => q.push_back((go, vars.clone())),
                    }
                }
            }
        }
    }
    println!("Part 2: {}", accepted2);
}

fn parse() -> (Vec<Workflow>, Vec<(u64, u64, u64, u64)>) {
    let (works, parts) = DATA.split_once("\n\n").unwrap();
    (
        works
            .lines()
            .map(|line| {
                let mut m = line.split(|x| x == '{' || x == '}');
                let name = m.next().unwrap();
                let conds = m
                    .next()
                    .unwrap()
                    .split(',')
                    .map(|co| {
                        if co.contains(':') {
                            let (cond, dest) = co.split_once(':').unwrap();
                            let i = match &cond[0..1] {
                                "x" => 0,
                                "m" => 1,
                                "a" => 2,
                                "s" => 3,
                                _ => unreachable!(),
                            };
                            let no = cond[2..].parse().unwrap();
                            if &cond[1..2] == ">" {
                                return Condition::GreaterThan { i, no, dest };
                            } else {
                                return Condition::LowerThan { i, no, dest };
                            }
                        } else {
                            return Condition::Goto(co);
                        }
                    })
                    .collect();
                Workflow { name, conds }
            })
            .collect(),
        parts
            .lines()
            .map(|line| {
                let numbers: Vec<_> = line[1..(line.len() - 1)]
                    .split(',')
                    .map(|x| x[2..].parse().unwrap())
                    .collect();
                (numbers[0], numbers[1], numbers[2], numbers[3])
            })
            .collect(),
    )
}
