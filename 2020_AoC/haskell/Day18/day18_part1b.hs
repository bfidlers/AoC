import Data.List
import Data.Char
import Data.Maybe

main :: IO ()
main = do input <- readFile "test2.txt"
          print . map (reverse . concat . words) . lines $ input
          print . parse $ input
          print . f . parse $ input

f :: [Expr] -> [Int]
f = map evalExpr      

data Expr = Mult Expr Expr |
            Add Expr Expr |
            Const Int |
            Empty
    deriving (Show) 

evalExpr :: Expr -> Int
evalExpr (Mult a b) = (evalExpr a) * (evalExpr b)
evalExpr (Add a b) = (evalExpr a) + (evalExpr b)
evalExpr (Const a) = a

makeExpr :: Expr -> String -> Expr
makeExpr r [] = r
makeExpr r (x:xs) 
    | isDigit x = makeExpr (Const (digitToInt x)) xs
    | x == '+' = Add (makeExpr Empty xs) r
    | x == '*' = Mult (makeExpr Empty xs) r
    | x == ')' = makeExpr (makeExpr Empty before) after
    | otherwise = error (x : " not parsable")
    where (before,after) = parseBracket xs 0 ("","")

parseBracket :: String -> Int -> (String,String) -> (String,String)
parseBracket (x:xs) nb (f,_)
    | x == '(' = if nb == 0 then (f,xs)
                 else parseBracket xs (nb-1) (f++[x],[])
    | x == ')' = parseBracket xs (nb+1) (f++[x],[])
    | otherwise = parseBracket xs nb (f++[x],[])

parse :: String -> [Expr]
parse = map (makeExpr Empty . reverse . concat . words) . lines
