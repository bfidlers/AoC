import Data.List

main :: IO ()
main = do input <- readFile "input.txt"
          print . answer . f . lines  $ input

answer :: [String] -> Int
answer = middle . sort . map totalScore . filter ("" /=)

totalScore :: [Char] -> Int
totalScore = foldl (\y x -> y*5 + score x) 0

score :: Char -> Int 
score ')' = 1
score ']' = 2
score '}' = 3
score '>' = 4
score _ = 0

middle :: [a] -> a
middle list = list !! index
    where index = div (length list) 2
    
f :: [String] -> [String]
f = map (parse [])

parse :: String -> String -> [Char]
parse [] (y:ys) = parse [y] ys 
parse [] [] = []
parse x [] = autofill x
parse (x:xs) (y:ys)
    | corresponding x y = parse xs ys
    | corrupt x y = []
    | otherwise = parse (y:x:xs) ys

autofill :: String -> String
autofill = map match

match :: Char -> Char
match '(' = ')'
match '[' = ']'
match '{' = '}'
match '<' = '>'

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
