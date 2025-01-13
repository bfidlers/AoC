package main

import (
  "fmt"
  "os"
)

const fileName = "input.txt"

func find_basement_instr(instr string) int {
  floor := 0
  for i := 0; i < len(instr); i++ {
    if instr[i] == '(' {
      floor += 1
    } else if instr[i] == ')' {
      floor -= 1
    }

    if floor == -1 {
      return i + 1
    }
  }
  return -1
}

func main() {
  data, err := os.ReadFile(fileName)
  if err != nil {
      panic(err)
  }

  instr := find_basement_instr(string(data))

  fmt.Print(instr)
}
