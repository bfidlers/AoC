main :: IO ()
main = do input <- readFile "input.txt"
          print . checkInput . parseInput $ input

parseInput :: String -> [[[String]]]
parseInput input = splitByBlocks ':' (words' . concatBlocks . lines $ input)


concatBlocks :: [String] -> [String]
concatBlocks [] = []
concatBlocks (x:xs) 
    | null xs = [x] 
    | x == "" = [""] ++ (concatBlocks xs)
    | otherwise = (\ (y:ys) -> (" "++x++y):ys) (concatBlocks xs)
                         
words' :: [String] -> [[String]]
words' [] = []
words' (x:xs) = words x : words' xs

splitByBlocks :: Eq a => a -> [[[a]]] -> [[[[a]]]]
splitByBlocks seperator [] = []
splitByBlocks seperator (x:xs) = [splitByLines seperator x] ++ splitByBlocks seperator xs

splitByLines :: Eq a => a -> [[a]] -> [[[a]]]
splitByLines seperator [] = []
splitByLines seperator (x:xs) = [splitBy seperator x] ++ splitByLines seperator xs

splitBy :: Eq a => a -> [a] -> [[a]]
splitBy seperator [] = []
splitBy seperator (x:xs) 
    | null xs = [[x]]
    | x == seperator = [[]] ++ (splitBy seperator xs)
    | otherwise = (\ (y:ys) -> (x:y):ys) (splitBy seperator xs)

checkInput :: [[[String]]] -> Int
checkInput [] = 0
checkInput (x:xs) 
    | checkValidFields x neededFields = 1 + checkInput xs
    | otherwise = checkInput xs
    
checkValidFields :: [[String]] -> [String] -> Bool
checkValidFields ex req = contains req fieldNames
    where fieldNames = map head ex
    
equal :: Eq a => [a] -> [a] -> Bool
equal a b = contains a b && contains b a

contains :: Eq a => [a] -> [a] -> Bool
contains [] b = True
contains (a:as) b = elem a b && contains as b

neededFields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
allFields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid", "cid"]
