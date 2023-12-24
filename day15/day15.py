def hash(text: str):
    cur = 0
    for c in text:
        cur = ((cur + ord(c)) * 17) % 256
    return cur


with open("data.txt") as f:
    seq = f.read().replace("\n", "").split(",")
    print("Part 1:", sum(map(lambda x: hash(x), seq)))

    boxes = {}
    for ins in seq:
        label = ''.join(filter(str.isalpha, ins))
        add = ins.find('=')
        bid = hash(label)

        if add > 0:
            lensno = int(ins[add+1:])
            if bid in boxes.keys():
                box = boxes[bid]
                i = -1
                for j, lens in enumerate(box):
                    if lens[0] == label:
                        i = j
                        break
                if i >= 0:
                    box[i] = (label, lensno)
                else:
                    box.append((label, lensno))
            else:
                boxes[bid] = [(label, lensno)]
        elif bid in boxes.keys():
            box = boxes[bid]
            for i, lens in enumerate(boxes[bid]):
                if lens[0] == label:
                    boxes[bid].pop(i)
                    break
    total = 0
    for bid, box in boxes.items():
        for i, lens in enumerate(box):
            total += (bid + 1) * (i + 1) * lens[1]
    print("Part 2:", total)
