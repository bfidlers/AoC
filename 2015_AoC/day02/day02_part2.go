package main

import (
  "fmt"
  "os"
  "strings"
)

const fileName = "input.txt"

func calculate_ribbon_length(src string) int {
  var l, w, h int

  fmt.Sscanf(src, "%dx%dx%d", &l, &w, &h)

  min_perimeter := min(2*l + 2*w, 2*l + 2*h, 2*w + 2*h)
  bow := l * w * h
  ribbon := min_perimeter + bow
  return ribbon
}

func main() {
  data, err := os.ReadFile(fileName)
  if err != nil {
    panic(err)
  }
  lines := strings.Split(string(data), "\n")
  result := 0
  for _, line := range lines {
    result += calculate_ribbon_length(line)
  }
  fmt.Println(result)
}
