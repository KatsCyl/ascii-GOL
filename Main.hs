module Main where

import qualified System.Random as R
import System.Console.ANSI (clearScreenCode)
import Data.Maybe
import Data.List.Ordered
import Control.Concurrent


data Game = Game Int Int [Bool]
secs :: Int
secs = 500000

main :: IO ()
main = do putStrLn ("Please provide width: ")
          w <- readLn :: IO Int
          putStrLn ("Please provide height: ")
          h <- readLn :: IO Int
          putStrLn ("Please provide random seed: ")
          seed <- readLn :: IO Int
          putStrLn ("Please provide percentage of living cells in the beginning: ")
          proc <- readLn :: IO Double
          loop $ genGOL (w, h) seed proc 

loop :: Game -> IO ()
loop = sequence_ .map (\x -> putStrLn (matrixToString $ x) >> threadDelay secs) . iterate updateGame

genGOL :: (Int, Int) -> Int -> Double -> Game
genGOL (w, h) seed proc =let rndms = take (w * h) $ R.randomRs (1, 100) (R.mkStdGen seed) :: [Int]
                             bools = map (\x -> x < floor (100 * proc)) rndms
                         in
                             Game w h bools

matrixToString :: Game -> String
matrixToString (Game w h list) = (++) clearScreenCode $ concat $ map rowToString $ grabRows w list 

grabRows :: Int -> [a] -> [[a]]
grabRows _ []   = [[]]
grabRows x list = (take x list) : (grabRows x (drop x list))

rowToString :: [Bool] -> String
rowToString x = (concat $ map boolToString x) ++ "\n"
              where
              boolToString x | x = "@"
                             | otherwise = " "

updateGame :: Game -> Game
updateGame g@(Game w h list)= (Game w h $ map aliveOrDead $ calcNeighbours g)
                          where
                          aliveOrDead :: (Bool, Int) -> Bool
                          aliveOrDead (x, y) | x && 1 < y && y < 4 = True
                                          | not x && 2 < y = True
                                          | otherwise = False
 
calcNeighbours :: Game -> [(Bool, Int)]
calcNeighbours (Game w h list) = map (\x -> calcSingularNeighbours x (w, h) list) ordXs
                               where
                                xs = [(i, j) | i <- [0 .. w - 1] , j <- [0 .. h - 1]]
                                ordXs = reverse $ sortBy ordFunc xs

ordFunc :: (Int, Int) -> (Int, Int) -> Ordering
ordFunc (x, y) (z, w) | w > y = GT
                      | w == y && z > x = GT
                      | w == y && z == x = EQ
                      | otherwise = LT

-- Indexing function, firt argument index, next size of matrix [a]
index :: (Int, Int) -> (Int, Int) -> [a] -> Maybe a
index (x, y) (w, h) list | x < 0 || y <0 || w < 0 || h < 0 = Nothing
                         | x >= w || y >= h = Nothing
                         | x + w * y < w * h = Just $ list !! (x + y*w)
                         | otherwise = Nothing

calcSingularNeighbours :: (Int, Int) -> (Int, Int) -> [Bool] -> (Bool, Int)
calcSingularNeighbours (x, y) (w, h) bools = (curIndex, foldr (+) 0 (map index' xs))
                                           where
                                            index' = (\x -> maybe 0 boolToInt $ index x (w,h) bools)
                                            xs = [(i, j) | i <- [x - 1 .. x + 1], j <- [y - 1 .. y + 1], (i, j) /= (x, y)]
                                            curIndex = fromMaybe False $ index (x, y) (w,h) bools

boolToInt :: Bool -> Int
boolToInt x | x = 1
            | otherwise = 0

debug :: Game -> [Bool]
debug (Game _ _ list) = list
