package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
    "slices"
)

type Set struct {
    red int64
    green int64
    blue int64
}

type Game struct {
    id int64
    sets []Set
}

func main() {
    partA()
    partB()
}

func partA() {
    games := parseGames()

    const max_red int64 = 12
    const max_green int64 = 13
    const max_blue int64 = 14

    var result int64

    for _, game := range games {
        valid := true
        for _, set := range game.sets {
            if set.red > max_red || set.green > max_green || set.blue > max_blue {
                valid = false
                break
            }
        }

        if valid {
            result += game.id
        }
    }

    fmt.Println("Part A: ", result)
}

func partB() {
    games := parseGames()

    var result int64

    for _, game := range games {
        var reds []int64
        var greens []int64
        var blues []int64

        for _, set := range game.sets {
            reds = append(reds, set.red)
            greens = append(greens, set.green)
            blues = append(blues, set.blue)
        }

        min_red := slices.Max(reds)
        min_green := slices.Max(greens)
        min_blue := slices.Max(blues)

        result += min_red * min_green * min_blue
    }

    fmt.Println("Part B: ", result)
}

func parseGames() []Game {
    file, err := os.OpenFile("data.txt", 0, os.ModeAppend);
    if err != nil {
        log.Fatal(err)
        return nil
    }

    defer file.Close()

    var games []Game
    sc := bufio.NewScanner(file)
    for sc.Scan() {
        line := sc.Text()
        subs := strings.SplitN(line, ": ", 2)
        id, _ := strconv.ParseInt(subs[0][5:], 10, 32)
        var sets []Set
        for _, set := range strings.Split(subs[1], "; ") {
            colors := strings.Split(set, ", ")
            var red int64
            var green int64
            var blue int64

            for _, color := range colors {
                temp := strings.Split(color, " ")
                count, _ := strconv.ParseInt(temp[0], 10, 32)
                name := temp[1]

                switch name {
                case "red":
                    red += count
                    break
                case "green":
                    green += count
                    break
                case "blue":
                    blue += count
                    break
                }
            }

            sets = append(sets, Set{red, green, blue})
        }

        games = append(games, Game{id, sets})
    }

    return games
}
