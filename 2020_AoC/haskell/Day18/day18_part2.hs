import Data.List
import Data.List.Split
import Data.Maybe
import Debug.Trace

main :: IO ()
main = do input <- readFile "input.txt"
          print . foldr (+) 0 . parseInput $ input
          
parseInput :: String -> [Int]
parseInput input = l
    where l = map (\x -> evalExpr . makeExpr . reverse . concat . words $ x) . lines $ input

data Expr = Mult Expr Expr |
            Plus Expr Expr |
            Const Int
    deriving (Show) 

makeExpr :: String -> Expr
makeExpr list 
    | head list == ')' = if indexBracket + 1 == length list 
                             then makeExpr (tail . init $ list)
                         else if list!!(indexBracket+1) == '*' 
                             then Mult (makeExpr before) (makeExpr after)
                         else Plus (makeExpr before) (makeExpr after) 
    | isNothing indexOp = Const (read list)
    | nextOp == '+' = Plus (makeExpr next) (makeExpr prev)
    | nextOp == '*' = Mult (makeExpr next) (makeExpr prev) 
    where -- brackets
          before = tail . take indexBracket $ list 
          after = drop (indexBracket + 2) list
          indexBracket = findMatchingBracket list
          -- operators
          actualIndexOp = fromJust indexOp
          nextOp = list!!actualIndexOp
          prev = take actualIndexOp list
          next = drop (actualIndexOp + 1) list
          indexOp = findIndex (`elem` "+*") list

evalExpr :: Expr -> Int
evalExpr (Mult a b) = (evalExpr a) * (evalExpr b)
evalExpr (Plus a b) = (evalExpr a) + (evalExpr b)
evalExpr (Const a) = a

findMatchingBracket :: String -> Int
findMatchingBracket input = snd . head . filter (\(a,b) -> a > b) . zip backBrackets $ frontBrackets
    where frontBrackets = 0: (findIndices (== '(') input)
          backBrackets = (findIndices (== ')') input) ++ [length input + 1]
