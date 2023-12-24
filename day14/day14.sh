#!/bin/bash

input="./data.txt"
lines=()
orig=()
leny=0
lenx=0
while read -r line; do
    lines+=("$line")
    orig+=("$line")
    leny=$((leny + 1))
    lenx=${#line}
done < "$input"

nsb=0
north() {
    for ((j=0; j<lenx; j++)); do
        next=0
        for ((i=0; i<leny; i++)); do
            v=${lines[i]:j:1}
            if [[ "$v" == "O" ]]; then
                if [[ "$i" -gt $next ]]; then
                    lines[i]="${lines[i]:0:j}.${lines[i]:j+1}"
                    lines[next]="${lines[next]:0:j}O${lines[next]:j+1}"
                fi
                next=$((next + 1))
            elif [[ "$v" == "#" ]]; then
                next=$((i + 1))
            fi
        done
    done
}
west() {
    for ((i=0; i<leny; i++)); do
        next=0
        for ((j=0; j<lenx; j++)); do
            v=${lines[i]:j:1}
            if [[ "$v" == "O" ]]; then
                if [[ "$j" -gt $next ]]; then
                    lines[i]="${lines[i]:0:j}.${lines[i]:j+1}"
                    lines[i]="${lines[i]:0:next}O${lines[i]:next+1}"
                fi
                next=$((next + 1))
            elif [[ "$v" == "#" ]]; then
                next=$((j + 1))
            fi
        done
    done
}
south() {
    for ((j=0; j<lenx; j++)); do
        next=$((leny - 1))
        for ((i=leny - 1; i>=0; i--)); do
            v=${lines[i]:j:1}
            if [[ "$v" == "O" ]]; then
                if [[ "$i" -lt $next ]]; then
                    lines[i]="${lines[i]:0:j}.${lines[i]:j+1}"
                    lines[next]="${lines[next]:0:j}O${lines[next]:j+1}"
                fi
                next=$((next - 1))
            elif [[ "$v" == "#" ]]; then
                next=$((i - 1))
            fi
        done
    done
}
east() {
    for ((i=0; i<leny; i++)); do
        next=$((lenx - 1))
        for ((j=lenx - 1; j>=0; j--)); do
            v=${lines[i]:j:1}
            if [[ "$v" == "O" ]]; then
                if [[ "$j" -lt $next ]]; then
                    lines[i]="${lines[i]:0:j}.${lines[i]:j+1}"
                    lines[i]="${lines[i]:0:next}O${lines[i]:next+1}"
                fi
                nsb=$((nsb + leny - i))
                next=$((next - 1))
            elif [[ "$v" == "#" ]]; then
                next=$((j - 1))
            fi
        done
    done
}

north
load=0
for ((i=0; i<leny; i++)); do
    for ((j=0; j<lenx; j++)); do
        v=${lines[i]:j:1}
        if [[ "$v" == "O" ]]; then
            load=$((load + leny - i))
        fi
    done
done
echo "Part A: $load" 

lines=("${orig[@]}")
loads=()
declare -A history

cycle_start=0
cycle_len=0

for ((m=0; m<1000000000; m++)); do
    nsb=0
    north
    west
    south
    east
    loads+=("$nsb")

    if [[ "$m" -gt 20 ]]; then
        hlen=${#loads[@]}
        state="${loads[*]:hlen-20}"
        if [[ -v history[$state] ]]; then
            cycle_start=${history[$state]}
            cycle_len=$((m - cycle_start))
            break
        fi
        history[$state]=$m
    fi
done

target=$((1000000000 - cycle_start))
offset=$((target % cycle_len))

echo "Part B: ${loads[cycle_start + offset - 1]}"
