#!/usr/bin/env bash

echo "Welcome to the True or False Game!"

curl -s -u username:password -o cookie.txt --cookie-jar cookie.txt http://0.0.0.0:8000/login

responses=("Perfect!", "Awesome!", "You are a genius!", "Wow!", "Wonderful!")

filename="scores.txt"

function play() {
    points=0
    correct=0
    echo "What is your name?"
    read name
    while true; do
        RANDOM=4096 #$RANDOM
        item=$(curl --silent --cookie cookie.txt http://0.0.0.0:8000/game)
        question=$(echo "$item" | sed 's/.*"question": *"\{0,1\}\([^,"]*\)"\{0,1\}.*/\1/')
        answer=$(echo "$item" | sed 's/.*"answer": *"\{0,1\}\([^,"]*\)"\{0,1\}.*/\1/')
        echo $question
        echo "True or False?"
        read user_answer
        if [ "$answer" == "$user_answer" ]; then
            echo "Perfect!"
            idx=$((RANDOM % 5))
            echo "${responses[$idx]}"
            points=$((points + 10))
            correct=$((correct + 1))
        else
            echo "Wrong answer, sorry!"
            echo "$name you have $correct correct answer(s)."
            echo "Your score is $points points."
            date=$(date '+%Y-%m-%d')
            echo "User: $name, Score: $points, Date: $date" >> "$filename"
            break
        fi
    done
}

function display_scores() {
    lines=$(wc -l < "$filename")
    if [[ "$lines" > 0 ]]; then
        echo "Player scores"
        i=1
        while read -r line; do
            name="$line"
            echo "$name"
            i=$[$i +1]
        done < "$filename"
    else
        echo "File not found or no scores in it!"
    fi
}

function reset_scores() {
    lines=$(wc -l < "$filename")
    if [[ "$lines" > 0 ]]; then
        rm $filename
    else
        echo "File not found or no scores in it!"
    fi
}

function game() {
    echo -e "0. Exit\n1. Play a game\n2. Display scores\n3. Reset scores\nEnter an option:"
    read choice
case $choice in
        0)
            echo "See you later!"
            exit
        ;;
        1)
            play
        ;;
        2)
            display_scores
        ;;
        3)
           reset_scores
        ;;
        *)
            echo "Invalid option!"
        ;;
    esac
}


while true; do
    game
done