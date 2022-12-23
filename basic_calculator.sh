#!/usr/bin/env bash

file_name="operation_history.txt"
touch $file_name

echo "Welcome to the basic calculator!" | tee -a "$file_name"

while true
    do
    echo "Enter an arithmetic operation or type 'quit' to quit:" | tee -a "$file_name"
    read number1 operator number2
    all="$number1 $operator $number2"
    echo "$all" >> operation_history.txt

    if [ "$number1" == 'quit' ]; then
            break
    fi
        validation1='^-?[-0-9]+.?[-0-9]*$'
        validation2='^[\/\*-\+^]{1}$'

        if [[ "$number1" =~ $validation1 && "$number2" =~ $validation1 && $operator =~ $validation2 ]]; then
            arithmetic_result=$(echo "scale=2; $number1 $operator $number2" | bc -l)
            printf "%s\n" "$arithmetic_result"
            echo $arithmetic_result >> operation_history.txt
          else
            echo "Operation check failed!" | tee -a "$file_name"
        fi
    done

echo "Goodbye!" | tee -a "$file_name"