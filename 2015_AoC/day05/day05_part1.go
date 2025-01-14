package main

import (
  "fmt"
  "os"
  "strings"
  "bufio"
)

const fileName = "input.txt"

func contains_n_vowels(n int, s string) bool{
  count := 0
  for _, letter := range s {
    if strings.Contains("aeiou", string(letter)) {
      count += 1
    }
  }
  if count >= n {
    return true
  }
  return false
}

func contains_duplicate(s string) bool{
  var current rune
  for _, letter := range s {
    if letter == current {
      return true
    }
    current = letter
  }
  return false
}

func contains(s string, substrings []string) bool{
  for _, substring := range substrings {
    if strings.Contains(s, substring) {
      return true
    }
  }
  return false
}

func nice_string(s string) bool{
  no_goes := []string{"ab", "cd", "pq", "xy"}
  return contains_n_vowels(3, s) && contains_duplicate(s) && !contains(s, no_goes)
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
