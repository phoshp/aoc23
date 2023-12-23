#!/bin/bash

input="./data.txt"
lines=()
orig=()
len=0
while read -r line; do
    lines+=("$line")
    orig+=("$line")
    len=$((len + 1))
done < "$input"

north() {
    local next=0
    for ((k=i-1; k>=0; k--)) do
        n=${lines[k]:j:1}
        if [[ "$n" == "#" || "$n" == "O" ]]; then
            next=$((k + 1))
            break
        fi
    done
    lines[i]="${lines[i]:0:j}.${lines[i]:j+1}"
    lines[next]="${lines[next]:0:j}O${lines[next]:j+1}"
}
south() {
    local next=$((len - 1))
    for ((k=i+1; k<len; k++)) do
        n=${lines[k]:j:1}
        if [[ "$n" == "#" || "$n" == "O" ]]; then
            next=$((k - 1))
            break
        fi
    done
    lines[i]="${lines[i]:0:j}.${lines[i]:j+1}"
    lines[next]="${lines[next]:0:j}O${lines[next]:j+1}"
}
west() {
    local next=0
    for ((k=j-1; k>=0; k--)) do
        n=${lines[i]:k:1}
        if [[ "$n" == "#" || "$n" == "O" ]]; then
            next=$((k + 1))
            break
        fi
    done
    lines[i]="${lines[i]:0:j}.${lines[i]:j+1}"
    lines[i]="${lines[i]:0:next}O${lines[i]:next+1}"
}
east() {
    local next=$((len - 1))
    for ((k=j+1; k<len; k++)) do
        n=${lines[i]:k:1}
        if [[ "$n" == "#" || "$n" == "O" ]]; then
            next=$((k - 1))
            break
        fi
    done
    lines[i]="${lines[i]:0:j}.${lines[i]:j+1}"
    lines[i]="${lines[i]:0:next}O${lines[i]:next+1}"
}

turn() {
    local turn=$1
    for i in "${!lines[@]}"; do
        if [[ "$turn" == 2 ]]; then
            i=$((len - i - 1))
        fi
        for j in "${!lines[@]}"; do
            if [[ "$turn" == 4 ]]; then
                j=$((len - j - 1))
            fi
            v=${lines[i]:j:1}
            if [[ "$v" == "O" ]]; then
                if [[ "$turn" == 1 ]]; then
                    north
                elif [[ "$turn" == 2 ]]; then
                    south
                elif [[ "$turn" == 3 ]]; then
                    west
                elif [[ "$turn" == 4 ]]; then
                    east
                fi
            fi
        done
    done
}

load=0
check_load() {
    load=0
    for i in "${!lines[@]}"; do
        for j in "${!lines[@]}"; do
            v=${lines[i]:j:1}
            if [[ "$v" == "O" ]]; then
                load=$((load + len - i))
            fi
        done
    done
}

turn 1
check_load
echo "Part A: $load" 

lines=("${orig[@]}")
loads=()
declare -A history

cycle_start=0
cycle_len=0

for ((m=0; m<300; m++)) do
    turn 1
    turn 3
    turn 2
    turn 4
    check_load
    loads+=("$load")

    if [[ $m -gt 20 ]]; then
        hlen=${#loads}
        state="${loads[*]:hlen-20}"
        if [[ -v history[$state] ]]; then
            cycle_start=${history[state]}
            cycle_len=$((m - cycle_start))
            break
        fi
        history[$state]=$m
    fi
done

target=$((1000000000 - cycle_start))
offset=$((target % cycle_len - 1))

echo "Part B: ${loads[$cycle_start + $offset]}"


