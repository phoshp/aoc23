import { readFileSync } from "fs";

interface Node {
    name: string,
    left: string,
    right: string
}

const data = readFileSync("data.txt").toString();
let lines = data.split("\n");
let instructions = lines.shift()!;
lines.shift();
let nodes: Node[] = lines.filter(l => l.length > 0).map(v => {
    v = v.replace("(", "");
    v = v.replace(")", "");
    let parts = v.split(" = ");
    let name = parts[0];
    let arms = parts[1].split(", ");
    return {
        name,
        left: arms[0],
        right: arms[1]
    };
});

function walk(curr: Node): number {
    let steps = 0;
    let ic = 0;
    while (!curr.name.endsWith("Z")) {
        let inst = instructions[ic++ % instructions.length];
        if (inst == 'L') {
            curr = nodes.find(v => v.name == curr.left)!;
        } else {
            curr = nodes.find(v => v.name == curr.right)!;
        }
        steps++;
    }
    return steps;
}

function gcd(a: number, b: number): number {
    while (b != 0) {
        let c = b;
        b = a % b;
        a = c;
    }
    return a;
}

function lcm(a: number, b: number): number {
    return a * b / gcd(a, b);
}

console.log("Part A: ", walk(nodes.find(n => n.name == "AAA")!));
console.log("Part B: ", nodes.filter(n => n.name.endsWith("A")).
    map(n => walk(n)).reduce((a, b) => lcm(a, b), 1));
