package main

import (
  "fmt"
  "os"
  "strings"
)

const fileName = "input.txt"

func calculate_wrapping_paper(src string) int {
  var l, w, h int

  fmt.Sscanf(src, "%dx%dx%d", &l, &w, &h)

  s1 := l * w
  s2 := l * h
  s3 := w * h

  wrapping_paper := 2*s1 + 2*s2 + 2*s3 + min(s1, s2, s3)
  return wrapping_paper
}

func main() {
  data, err := os.ReadFile(fileName)
  if err != nil {
    panic(err)
  }
  lines := strings.Split(string(data), "\n")
  result := 0
  for _, line := range lines {
    result += calculate_wrapping_paper(line)
  }
  fmt.Println(result)
}
