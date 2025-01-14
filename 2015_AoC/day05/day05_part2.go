package main

import (
  "fmt"
  "os"
  "strings"
  "bufio"
)

const fileName = "input.txt"

func contains_pair_twice(s string) bool{
  current := s[0:1]
  for i := 1; i < len(s); i++ {
    if strings.Contains(s[i+1:], current + string(s[i])) {
      return true
    }
    current = string(s[i])
  }
  return false
}

func contains_repeat_seperated_by_one(s string) bool{
  if len(s) < 3 {
    return false
  }
  for i := 0; i < len(s) - 2; i++ {
    if s[i] == s[i+2] {
      return true
    }
  }
  return false
}

func nice_string(s string) bool{
  return contains_pair_twice(s) && contains_repeat_seperated_by_one(s)
}

func main() {
  file, err := os.Open(fileName)
  if err != nil {
    panic(err)
  }
  scanner := bufio.NewScanner(file)
  nice_strings := 0
  for scanner.Scan() {
    if nice_string(scanner.Text()) {
      nice_strings += 1
    }
  }
  fmt.Println(nice_strings)
}
