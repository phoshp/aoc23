from collections import defaultdict
from math import gcd

with open("data.txt") as f:
    mods = {}

    def parse_mods():
        for line in f.read().splitlines():
            w = line.split(' -> ')
            mods[''.join(filter(str.isalpha, w[0]))] = (w[0], w[1].split(', '))

    parse_mods()
    low, high = 1000, 0
    states = defaultdict(lambda: [-1])  # -1 for low, 1 for high pulse
    rx = None
    for k, v in mods.items():
        if "rx" in v[1]:
            rx = k
            break
    rx_i = 0
    cycle = {}
    visited = {
        name: 0 for name, mod in mods.items() if rx in mod[1]
    }
    i = 0
    while rx_i == 0:
        i += 1
        pulses = [("button", "broadcaster", -1)]
        while pulses:
            (source, target, signal) = pulses.pop(0)
            if target not in mods:
                continue
            mod = mods[target]
            state = states[target]
            type = mod[0][0]
            ts = None
            if rx_i == 0 and target == rx and signal == 1:
                visited[source] += 1
                if source not in cycle:
                    cycle[source] = i
                if all(visited.values()):
                    product = 1
                    for x in cycle.values():
                        product *= x // gcd(product, x)
                    rx_i = product
            if type == 'b':
                ts = signal
            if type == '%' and signal == -1:
                ts = -state[0]
                state[0] *= -1
            if type == '&':
                if state[0] == -1:  # init state
                    state[0] = {}
                    for k, v in mods.items():
                        if target in v[1]:
                            state[0][k] = -1
                state[0][source] = signal
                ts = -min(state[0].values())
            if ts:
                if i <= 1000:
                    if ts == 1:
                        high += len(mod[1])
                    else:
                        low += len(mod[1])
                for t in mod[1]:
                    pulses.append((target, t, ts))
    print("Part 1:", low * high)
    print("Part 2:", rx_i)
