# Saga - the game tracker

## Purpose

* Track and record games played in the club
* Tally up a scoreboard of all wins/draws/losses

## Tracking the games

Intended operations operations:

* CRUD a league - e.g. all games of Magic: The Gathering happening in a club
* CRUD a game result - participants and results
* view league rankings

## Simplified version to start

* Only 2 player games
* Game system/size is just text (e.g. `Warhammer 40k - 2000pt matched play``)

### High Level Objects

#### Player

* Display Name :: Text

#### League

* Name :: Text
* Description :: Text
* Admin :: Player
* Participants :: [Player]
* Results :: [GameResult]
* Start Date :: DateTime
* End Date :: DateTime

#### GameResult

* Played Date :: DateTime
* Player 1 Result :: W/L/D
* Player 2 Result :: W/L/D

