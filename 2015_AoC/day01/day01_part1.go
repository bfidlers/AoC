package main

import (
  "fmt"
  "os"
)

const fileName = "input.txt"

func use_elevator(instr string) int {
  floor := 0
  for i := 0; i < len(instr); i++ {
    if instr[i] == '(' {
      floor += 1
    } else if instr[i] == ')' {
      floor -= 1
    }
  }
  return floor
}

func main() {
  data, err := os.ReadFile(fileName)
  if err != nil {
      panic(err)
  }

  floor := use_elevator(string(data))

  fmt.Print(floor)
}
