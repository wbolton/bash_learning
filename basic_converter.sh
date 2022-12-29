#!/usr/bin/bash
echo "Welcome to the Simple converter!"
touch definitions.txt
filename="definitions.txt"
re_int='^[0-9]+$'
re_str='^[A-Za-z]+_to_[A-Za-z]+$'
re_num='^-?([0-9]*\.)?[0-9]+$'

function output_file() {
    i=1
    while read -r line; do
        name="$line"
        echo "$i". "$name"
        i=$[$i +1]
    done < "$filename"
}

while true; do
    echo -e "Select an option\n0. Type '0' or 'quit' to end program\n1. Convert units\n2. Add a definition\n3. Delete a definition"
    read choice

    case $choice in
        0|"quit")
            echo "Goodbye!"
            exit;;
        1)
            lines=$(wc -l < "$filename")
            if [[ "$lines" == 0 ]]; then
                echo "Please add a definition first!"
            else
                echo "Type the line number to convert units or '0' to return"
                output_file
                while true; do
                read linenum
                    if [[ ("$linenum" == 0) ]]; then
                            break;
                    elif [[ ("$linenum" -le "$lines") && ("$linenum" =~ $re_int) ]]; then
                        line=$(sed "${linenum}!d" "$filename")
                        read -a text <<< "$line"
                        constant="${text[1]}"
                        echo "Enter a value to convert:"
                        while true; do
                            read to_convert
                            if [[ !("$to_convert" =~ $re_num) ]]; then
                                echo "Enter a float or integer value!"
                            else
                                result=$(echo "scale=2; $constant * $to_convert" | bc -l)
                                printf "Result: %s\n" "$result"
                                break;
                            fi
                        done
                        break;
                    else
                        echo "Enter a valid line number!"
                    fi
                done
            fi
        ;;
        2)
            while true; do
                echo "Enter a definition:"
                read -a user_input
                arr_length="${#user_input[@]}"
                definition="${user_input[0]}"
                constant="${user_input[1]}"
                
                if [[ !(("$arr_length" == 2) && ("$definition" =~ $re_str) && ("$constant" =~ $re_num)) ]]; then
                    echo "The definition is incorrect!"
                else
                    echo "${user_input[@]}" >> "$filename"
                    break;
                fi
            done;;
        3)
                lines=$(wc -l < "$filename")
                if [[ "$lines" == 0 ]]; then
                    echo "Please add a definition first!"
                else
                    echo "Type the line number to delete or '0' to return"
                    output_file
                    while true; do
                    read linenum
                        if [[ ("$linenum" == 0) ]]; then
                                break;
                        elif [[ ("$linenum" -le "$lines") && ("$linenum" =~ $re_int) ]]; then
                            sed -i "${linenum}d" "$filename"
                            break;
                        else
                            echo "Enter a valid line number!"
                        fi
                    done
                fi
            ;;
        *)
            echo "Invalid option!";;
    esac
done