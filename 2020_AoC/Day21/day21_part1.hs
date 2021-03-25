import Data.List
import Data.List.Split
import Debug.Trace

main :: IO ()
main = do input <- readFile "input.txt"
          print . parseInput $ input

parseInput :: String -> Int
parseInput input = length . filterFoods matchedAllergens $ foods
    where matchedAllergens = findSolution newAllergens
          newAllergens = matchAllergens allergens foods
          allergens = map (\x -> makeAllergen x) (allAllergens foods)
          foods = foldr (\ x1 x2 -> (makeFood . splitOn " (contains " $ x1) : x2) [] split
          split = splitOn "\n" input

data Food = Food [String] [String]
    deriving (Show) 

getIngredients :: Food -> [String]
getIngredients (Food ingr _) = ingr

getAllergens :: Food -> [String]
getAllergens (Food _ allergens) = allergens

hasAllergen :: String -> Food -> Bool 
hasAllergen a (Food _ allergens) = elem a allergens

makeFood :: [String] -> Food 
makeFood (x1:x2:xs) = Food ingredients allergens
    where ingredients = words x1
          allergens = splitOn ", " (init x2)

data Allergen = Allergen String String [String]
    deriving (Show)

makeAllergen :: String -> Allergen
makeAllergen name = Allergen name "" []

getName :: Allergen -> String 
getName (Allergen name _ _) = name 

getMatch :: Allergen -> String 
getMatch (Allergen _ match _) = match

getPossMatches :: Allergen -> [String]
getPossMatches (Allergen _ _ poss) = poss

setMatch :: String -> Allergen -> Allergen 
setMatch match (Allergen name _ poss) = Allergen name match poss

setPossMatches :: [String] -> Allergen -> Allergen
setPossMatches poss (Allergen name match _) = Allergen name match poss 

allAllergens :: [Food] -> [String]
allAllergens = foldr (\x1 x2 -> union (getAllergens x1) x2) []

matchAllergens :: [Allergen] -> [Food] -> [Allergen]
matchAllergens allergens foods = foldr (\ a1 a2 -> newA1 a1 : a2) [] allergens
    where newA1 a = checkAllergen (matchAllergen a foods)

matchAllergen :: Allergen -> [Food] -> Allergen 
matchAllergen a [] = a
matchAllergen a (f:fs)
    | hasAllergen allergen f = matchAllergen (setPossMatches newPossMatches a) fs
    | otherwise = matchAllergen a fs 
    where newPossMatches = if length possMatches == 0 
                               then ingredients
                           else intersect possMatches ingredients
          possMatches = getPossMatches a
          ingredients = getIngredients f
          allergen = getName a

checkAllergen :: Allergen -> Allergen 
checkAllergen a = if length matches == 1 
                      then setMatch (head matches) a
                  else a
    where matches = getPossMatches a

findSolution :: [Allergen] -> [Allergen]
findSolution a = if length check == 0 
                     then a 
                 else findSolution . slimDownAllergens a $ a
    where check = filter (\a1 -> getMatch a1 == "") a

slimDownAllergens :: [Allergen] -> [Allergen] -> [Allergen]
slimDownAllergens [] all = all
slimDownAllergens (a:as) all = if match == "" 
                                   then slimDownAllergens as all
                               else slimDownAllergens as (map (\x -> removeIngredient match x) all) 
    where match = getMatch a

removeIngredient :: String -> Allergen -> Allergen
removeIngredient match a = checkAllergen . setPossMatches newMatches $ a
    where newMatches = delete match possMatches
          possMatches = getPossMatches a

filterFoods :: [Allergen] -> [Food] -> [String]
filterFoods a f = foldr (\x1 x2 -> filterFood a x1 ++ x2) [] f

filterFood :: [Allergen] -> Food -> [String]
filterFood a f = foldr (\x1 x2 -> intersect (delete (allergen x1) ingredients) x2) ingredients a
    where allergen x = getMatch x
          ingredients = getIngredients f 
