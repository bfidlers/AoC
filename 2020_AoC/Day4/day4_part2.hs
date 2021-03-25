import Text.Read
import Data.List
import Data.Maybe

main :: IO ()
main = do input <- readFile "input.txt"
          print . length . checkInput . parseInput $ input

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

checkInput :: [[[String]]] -> [[[String]]]
checkInput [] = []
checkInput (x:xs) 
    | checkValidKeys x neededFields && checkValidValues x = x : checkInput xs
    | otherwise = checkInput xs    
    
checkValidKeys :: [[String]] -> [String] -> Bool
checkValidKeys ex req = contains req fieldNames
    where fieldNames = map head ex
    
checkValidValues :: [[String]] -> Bool 
checkValidValues [] = True
checkValidValues ((x1:x2:xs):ys) = checkValue x1 x2 && checkValidValues ys

checkValue :: String -> String -> Bool 
checkValue key value
    | key == "byr" = read value <= 2002 && read value >= 1920
    | key == "iyr" = read value <= 2020 && read value >= 2010
    | key == "eyr" = read value <= 2030 && read value >= 2020
    | key == "hgt" = checkHeight value
    | key == "hcl" = length value == 7 && head value == '#' && checkHexadecimal (tail value) 
    | key == "ecl" = elem value possibleEyeColors
    | key == "pid" = length value == 9 && (isJust (readMaybe value :: Maybe Int))
    | key == "cid" = True 

checkHeight :: String -> Bool
checkHeight list 
    | isSuffixOf "cm" list = height <= 193 && height >= 150
    | isSuffixOf "in" list = height <= 76 && height >= 59
    | otherwise = False
        where height = read (init . init $ list) :: Int
        
checkHexadecimal :: String -> Bool 
checkHexadecimal [] = True 
checkHexadecimal (x:xs) = ((x >= '0' && x <= '9') || (x >= 'a' && x <= 'f')) && checkHexadecimal xs
    
equal :: Eq a => [a] -> [a] -> Bool
equal a b = contains a b && contains b a

contains :: Eq a => [a] -> [a] -> Bool
contains [] b = True
contains (a:as) b = elem a b && contains as b

neededFields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
allFields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid", "cid"]
possibleEyeColors = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
