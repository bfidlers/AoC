package main

import (
  "fmt"
  "crypto/md5"
  "encoding/hex"
)

// const secret_key_test = "abcdef"
const secret_key = "yzbqklnj"

func startsWith(s string, c byte, n int) bool {
  for i := 0; i < n; i++ {
    if s[i] != c {
      return false
    }
  }
  return true
}

func findHash(s string) int {
  for i := 0; i >= 0; i++ {
    text := fmt.Sprintf("%s%d", s, i)
    hash := md5.Sum([]byte(text))
    s := hex.EncodeToString(hash[:])
    if startsWith(s, '0', 6) {
      return i
    }
  }
  return -1
}

func main() {
  fmt.Println(findHash(secret_key))
}
