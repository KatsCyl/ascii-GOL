module Paths_ascii_GOL (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/WinDir/tempanime/projects/ascii-GOL/.cabal-sandbox/bin"
libdir     = "/WinDir/tempanime/projects/ascii-GOL/.cabal-sandbox/lib/x86_64-linux-ghc-7.10.1/ascii_823bht6hrob8OSakOHZKqw"
datadir    = "/WinDir/tempanime/projects/ascii-GOL/.cabal-sandbox/share/x86_64-linux-ghc-7.10.1/ascii-GOL-0.1.0.0"
libexecdir = "/WinDir/tempanime/projects/ascii-GOL/.cabal-sandbox/libexec"
sysconfdir = "/WinDir/tempanime/projects/ascii-GOL/.cabal-sandbox/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "ascii_GOL_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "ascii_GOL_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "ascii_GOL_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "ascii_GOL_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "ascii_GOL_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
