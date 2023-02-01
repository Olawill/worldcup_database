#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Connect to the database 
echo $($PSQL "\c")

# Clear the tables
echo $($PSQL "TRUNCATE games, teams;")

# Read the games data from games.csv
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

# Insert all teams into the teams table
do
  if [[ $YEAR != 'year' ]]
  then
    # insert teams into the teams table
    INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams (name) VALUES('$WINNER') ON CONFLICT (name) DO NOTHING")
    INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams (name) VALUES('$OPPONENT')  ON CONFLICT (name) DO NOTHING")

    if [[ $INSERT_WINNER_RESULT == 'INSERT 0 1' ]]
    then
      echo "Inserted $WINNER into teams"
    fi
    if [[ $INSERT_OPPONENT_RESULT == 'INSERT 0 1' ]]
    then
      echo "Inserted $OPPONENT into teams"
    fi
  fi
done


# Read the games data from games.csv
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
# Insert all games into the games table
do
  if [[ $YEAR != 'year' ]]
  then
    # Get the winner and opponent ids from the teams table
    WINNERID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    OPPONENTID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

    # insert teams into the teams table
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, opponent_goals, winner_goals) VALUES('$YEAR', '$ROUND', '$WINNERID', '$OPPONENTID', '$OPPONENT_GOALS', '$WINNER_GOALS')")

    if [[ $INSERT_GAME_RESULT == 'INSERT 0 1' ]]
    then
      echo "Inserted the match between $WINNER and $OPPONENT into teams"
    fi
  fi
done
