hray
====

haskell toys: my feeble attempt to learn Haskell

#### Why share? 

In case it is of use to others.

#### What is it? 

A dev environment with possibly the following useful bits:

1. cabal sandbox
2. keep track of cabals with cabal.list
3. cheesy continuous compilation (rake cc)--should work well enough for small projects
4. (questionable but I like it) rake environment
5. and (even more questinable) my updates as I play around with GHC

#### How to get it to work? (Definitely not for the novice)

One note before proceeding: this will most probably work only on Ubuntu 13.10 (Saucy).

1. git pull http://github.com/topos/hray
2. cd <HRAY DIR>
3. gem install rake
  - possibly others?
4. rake dev:init
  - debug until it works, (obviously) if it doesn't work the first round
  - most bugs related to dev (ubuntu) packages not being installed
5. rake cc (continuous (cheesy) compile
  - builds Main and Spec in <HRAY DIR>/src
6. edit code in <HRAY DIR>/src 