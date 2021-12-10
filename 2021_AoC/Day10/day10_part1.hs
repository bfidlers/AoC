import Data.List

main :: IO ()
main = do input <- readFile "input.txt"
          print . answer . f . lines  $ input

answer :: [Char] -> Int
answer = sum . map score

score :: Char -> Int 
score ')' = 3
score ']' = 57
score '}' = 1197
score '>' = 25137
score _ = 0

f :: [String] -> [Char]
f = map (parse [])

parse :: String -> String -> Char
parse [] (y:ys) = parse [y] ys 
parse _ [] = ' '
parse (x:xs) (y:ys)
    | corresponding x y = parse xs ys
    | corrupt x y = y
    | otherwise = parse (y:x:xs) ys

corresponding :: Char -> Char -> Bool
corresponding '(' ')' = True 
corresponding '[' ']' = True 
corresponding '{' '}' = True 
corresponding '<' '>' = True 
corresponding _ _ = False 

corrupt :: Char -> Char -> Bool 
corrupt _ ')' = True
corrupt _ ']' = True
corrupt _ '}' = True
corrupt _ '>' = True
corrupt _ _ = False
