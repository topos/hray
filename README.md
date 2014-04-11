hray
====

a haskell dev. environment in order to learn haskell

#### Why share?

In case it is of use to others.

#### What is it?

A dev environment with possibly the following useful bits:

1. cabal sandbox
2. keep track of cabals with cabal.list
3. cheesy continuous compilation (rake cc)--should work well enough for small projects
4. (questionable but I like it) rake environment
5. and (even more questionable) my updates as I play around with GHC

#### How to get it to work? (Definitely not for the novice)

One note before proceeding: this will most probably work only on Ubuntu 13.10 (Saucy).

1. git pull http://github.com/topos/hray
2. cd <hray>
3. make -f lib/make.dev
4. rake cc 
  - builds Main and Spec in *HRAY_DIR*/src
5. edit code in <hray>/src
