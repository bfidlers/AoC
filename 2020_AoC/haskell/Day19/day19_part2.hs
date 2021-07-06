import Data.List.Split
import qualified Data.Map.Strict as M

main = do input <- readFile "input.txt"
          print . parse $ input

parse :: String -> Int
--parse input = filter (\x -> checkRules x tree) msgs
parse input = length . filter (\ x -> elem x language) $ msgs
    where language = constructLanguage tree
          tree = buildTree rules
          rules = constructRules .  map (splitOn ": ") . splitOn "\n" $ bigSplit!!0
          msgs = splitOn "\n" (bigSplit!!1)
          bigSplit = splitOn "\n\n" input

constructRules :: [[String]] -> M.Map Int Rule
constructRules [] = M.empty
constructRules (x:xs) = M.insert key value (constructRules xs)
    where key = read (head x) :: Int
          value = parseRule (x!!1)

parseRule :: String -> Rule
parseRule input
    | elem 'a' input = Const 'a'
    | elem 'b' input = Const 'b' 
    | elem '|' input = Or (map read . words $ orSplit!!0) (map read . words $ orSplit!!1)
    | otherwise = And (map read . words $ input)
    where orSplit = splitOn " | " input

data Rule = Const Char
            | And [Int]
            | Or [Int] [Int] 
    deriving (Show)

data Tree = TreeConst Char 
            | TreeAnd [Tree] 
            | TreeOr [Tree] [Tree]
    deriving (Show) 

buildTree :: M.Map Int Rule -> Tree 
buildTree m = buildTreeHelp 0 m
    where buildTreeHelp nb m =
             case M.lookup nb m of 
               Just (Const c) -> TreeConst c
               Just (And a) -> TreeAnd (map (\x -> buildTreeHelp x m) a)
               Just (Or o1 o2) -> TreeOr (map (\x -> buildTreeHelp x m) o1) (map (\x -> buildTreeHelp x m) o2)

--checkRules :: String -> Tree -> Bool
--checkRules (s:ss) (TreeConst c) 
--    | s == True 
--    | otherwise = False 
--checkRules s (TreeAnd a) = foldr 

constructLanguage :: Tree -> [String]
constructLanguage (TreeConst c) = [[c]] 
constructLanguage (TreeAnd a) = merge . map (\x -> constructLanguage x) $ a
constructLanguage (TreeOr o1 o2) = (merge . map (\x -> constructLanguage x) $ o1)
                                   ++ (merge . map (\x -> constructLanguage x) $ o2)

merge :: [[String]] -> [String]
merge (x:[]) = x
merge (x1:x2:xs) = merge ((pack x1 x2):xs)  

pack :: [String] -> [String] -> [String]
pack [] b = []
pack (a:as) b = (map (\x -> a ++ x) b) ++ (pack as b) 
