#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

    if [[ 
    $WINNER != winner && -n $WINNER && 
    $OPPONENT != opponent && -n $OPPONENT && 
    $YEAR != year && -n $YEAR &&
    $ROUND != round && -n $ROUND &&
    $WINNER_GOALS != winner_goals && -n $WINNER_GOALS &&
    $OPPONENT_GOALS != opponent_goals && -n $OPPONENT_GOALS
    ]]
    then
   
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER';")
        if [[ -z $WINNER_ID ]]
        then
            INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER');")
            if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
            then
                echo "Inserted into teams: $WINNER"
            fi
            WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER';")
        fi
   
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT';")
        if [[ -z $OPPONENT_ID ]]
        then
            INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT');")
            if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
            then
                echo "Inserted into teams: $OPPONENT"
            fi
            OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT';")
        fi
        
        GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year=$YEAR AND round='$ROUND' AND winner_id=$WINNER_ID AND opponent_id=$OPPONENT_ID AND winner_goals=$WINNER_GOALS and opponent_goals=$OPPONENT_GOALS;")
        if [[ -z $GAME_ID ]]
        then
            INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
            if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
            then
                echo "Inserted into games: $YEAR, $ROUND"
            fi
        fi        
    
    fi

done

