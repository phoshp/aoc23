import { readFileSync } from "fs";

class Hand {
    constructor(type, rank, bid, cards) {
        this.type = type;
        this.rank = rank;
        this.bid = bid;
        this.cards = cards;
    }
}

const data = readFileSync('data.txt').toString();
let parseHands = function(joker) {
    return data.trim().split('\n').map((line) => {
        let t = line.split(' ');
        let cards = Array.from(t[0]).map((x) => {
            switch (x) {
                case "A":
                    return joker ? 13 : 14;
                case "K":
                    return joker ? 12 : 13;
                case "Q":
                    return joker ? 11 : 12;
                case "J":
                    return joker ? 1 : 11;
                case "T":
                    return 10;
                default:
                    return parseInt(x);
            }
        });
        let bid = parseInt(t[1]);
        let type = undefined;
        let original_cards = Array.from(cards);

        if (joker) {
            let map = new Map();
            for (let c of cards) {
                if (c == 1) continue;
                const copy = cards.reduce((t, c2) => c == c2 ? t + 1 : t, 0);
                map.set(c, copy);
            }
            let max = -1;
            let target = undefined;
            map.forEach((v, k) => {
                if (v > max || (v == max && k > target)) {
                    max = v;
                    target = k;
                }
            });
            if (target != undefined) {
                cards.forEach((v, i) => {
                    if (v == 1) {
                        cards[i] = target;
                    }
                });
            } else {
                cards = [13, 13, 13, 13, 13];
            }
        }

        let map = new Map();
        for (let c of cards) {
            const copy = cards.reduce((t, c2) => c == c2 ? t + 1 : t, 0);
            map.set(c, copy);
        }
        let val = map.values();
        let type_rank = 0;

        switch (map.size) {
            case 1:
                type = "fivekind";
                type_rank = 7;
                break;
            case 2:
                let m = Math.min(val.next().value, val.next().value);
                if (m == 1) {
                    type = "fourkind";
                    type_rank = 6;
                } else {
                    type = "fullhouse";
                    type_rank = 5;
                }
                break;
            case 3:
                let w = Math.max(val.next().value, val.next().value, val.next().value);
                if (w == 3) {
                    type = "threekind";
                    type_rank = 4;
                } else if (w == 2) {
                    type = "twopair";
                    type_rank = 3;
                }
                break;
            case 4:
                type = "onepair";
                type_rank = 2;
                break;
            case 5:
                type = "highcard";
                type_rank = 1;
                break;
        }

        return new Hand(type, type_rank, bid, original_cards);
    })
};

/**
 * @param {Hand} a
 * @param {Hand} b
 * @returns number
 */
function compareHands(a, b) {
    for (let i = 0; i < 5; i++) {
        let x = a.cards[i];
        let y = b.cards[i];

        if (x < y) {
            return -1;
        } else if (x > y) {
            return 1;
        }
    }
    return 0;
}

let hands = parseHands(false).sort((a, b) => a.rank < b.rank ? -1 : (a.rank > b.rank ? 1 : compareHands(a, b)));
let wins = hands.map((v, i) => v.bid * (i + 1)).reduce((t, v) => t + v, 0);
console.log("Part A: ", wins);

let hands2 = parseHands(true).sort((a, b) => a.rank < b.rank ? -1 : (a.rank > b.rank ? 1 : compareHands(a, b)));
let wins2 = hands2.map((v, i) => v.bid * (i + 1)).reduce((t, v) => t + v, 0);
console.log("Part B: ", wins2);

