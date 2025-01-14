package main

import (
  "fmt"
  "os"
  "strings"
)

type pos struct {
  x int
  y int
}

const fileName = "input.txt"

func move(p pos, dir rune) pos {
  if dir == '>' {
    return pos{x: p.x + 1, y: p.y}
  } else if dir == '<' {
    return pos{x: p.x - 1, y: p.y}
  } else if dir == 'v' {
    return pos{x: p.x, y: p.y + 1}
  } else if dir == '^' {
    return pos{x: p.x, y: p.y - 1}
  }
  panic("Unknown character")
}

func addToMap(p pos, v map[pos]bool) {
  _, ok := v[p]
  if !ok {
    v[p] = true
  }
}

func main() {
  data, err := os.ReadFile(fileName)
  if err != nil {
    panic(err)
  }

  visited := map[pos]bool {}
  pSanta := pos{x: 0, y: 0}
  pRoboSanta := pos{x: 0, y: 0}
  turn := 0
  addToMap(pSanta, visited)

  for _, dir := range strings.TrimSuffix(string(data), "\n") {
    if turn == 0 {
      pSanta = move(pSanta, dir)
      addToMap(pSanta, visited)
    } else {
      pRoboSanta = move(pRoboSanta, dir)
      addToMap(pRoboSanta, visited)
    }
    turn = (turn + 1) % 2
  }

  fmt.Println(len(visited))
}
