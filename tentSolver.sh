#!/bin/bash

dir=false
file=false


if [[ $# -lt 1 && $# -gt 2 ]]; then
    echo "Not enough arguments: Correct use of script: 'bash $0 [option] pathToCSVFile/s'"
    exit 1
fi

# Check if file exists
if [ "$1" == "-f" ]; then
    file=true
fi


if [ "$1" == "-d" ]; then
    dir=true
fi

if [[ "$file" != true && "$dir" != true && ! -f "$1" ]]; then
    echo "There is no file with the path $1"
    exit 1
fi

if [[ "$file" = true && ! -f "$2" ]]; then
    echo "There is no file with the path $2"
    exit 1
fi

if [[ "$dir" = true && ! -d "$2" ]]; then
    echo "There is no directory with the path $2"
    exit 1
fi

if [[ "$dir" = true && "$(find $2 -type f | wc -l)" = 0 ]]; then
    echo "Directory is empty"
    exit 1
fi


if ! command -v clingo &> /dev/null; then
    echo "clingo could not be found, please install it."
    while true; do
        read -p "Do you wish to install clingo? (y/n) " yn
        case $yn in
            [Yy]* ) 
            echo "User chose yes."; 
            sudo apt-get update;
            sudo apt-get install gringo;
            break;;
            [Nn]* ) 
            echo "User chose no. Exiting."; 
            exit 1;;
            * ) 
            echo "Please answer yes (y) or no (n).";;
        esac
    done
fi

function parseAndSolveASP(){
    local file="$1"

    local clingoProgram=""

    local counterRow=0
    local counterColumn=1
    local rows=0
    local columns=0

    while IFS= read -r line; do
        if [ "$counterRow" -eq 0 ]; then
            IFS=' '
            read -ra infoArray <<< "$line"
            clingoProgram+="#const row=${infoArray[0]}."
            clingoProgram+="#const column=${infoArray[1]}."
            rows=${infoArray[0]}
            columns=${infoArray[1]}
        fi

        if [[ ! "$counterRow" -eq 0 && ! "$counterRow" -eq $(($rows+1)) ]]; then
            IFS=' '
            read -ra rowArray <<< "$line"
            clingoProgram+="rowCount($counterRow,${rowArray[1]})."

            readarray -t charArray < <(fold -w1 <<< "$line")
            for i in "${charArray[@]}"; do
                if [ "$i" == "T" ]; then
                    clingoProgram+="tree($counterRow, $counterColumn)."
                fi
                counterColumn=$(($counterColumn+1))
            done
            counterColumn=1
        fi

        if [ "$counterRow" -eq $(($rows+1)) ]; then
            readarray -t charArray < <(fold -w1 <<< "$line")
            
            for i in "${charArray[@]}"; do
                if [ ! "$i" == ' ' ]; then
                    clingoProgram+="columnCount($counterColumn, $i)."
                    counterColumn=$(($counterColumn+1))
                fi
                
            done
            counterColumn=1
        fi

        counterRow=$(($counterRow+1))
        
    done < <(sed -e '$a\' "$file")

    clingoProgram+="
    row(1..row).
    column(1..column).

    {tent(X,Y) : row(X), column(Y), not tree(X,Y)}.


    adjacentTree(X, Y, X1, Y) :- tent(X1, Y), row(X1), column(Y), X = X1+1.
    adjacentTree(X, Y, X1, Y) :- tent(X1, Y), row(X1), column(Y), X = X1-1.
    adjacentTree(X, Y, X, Y1) :- tent(X, Y1), row(X), column(Y1), Y = Y1+1.
    adjacentTree(X, Y, X, Y1) :- tent(X, Y1), row(X), column(Y1), Y = Y1-1.

    adjacentTent(X, Y, X1, Y) :- tent(X1, Y), row(X1), column(Y), X = X1+1.
    adjacentTent(X, Y, X1, Y) :- tent(X1, Y), row(X1), column(Y), X = X1-1.
    adjacentTent(X, Y, X, Y1) :- tent(X, Y1), row(X), column(Y1), Y = Y1+1.
    adjacentTent(X, Y, X, Y1) :- tent(X, Y1), row(X), column(Y1), Y = Y1-1.

    adjacentTent(X, Y, X1, Y1) :- tent(X1, Y1), row(X1), column(Y1), Y = Y1+1, X = X1+1.
    adjacentTent(X, Y, X1, Y1) :- tent(X1, Y1), row(X1), column(Y1), Y = Y1-1, X = X1+1.
    adjacentTent(X, Y, X1, Y1) :- tent(X1, Y1), row(X1), column(Y1), Y = Y1+1, X = X1-1.
    adjacentTent(X, Y, X1, Y1) :- tent(X1, Y1), row(X1), column(Y1), Y = Y1-1, X = X1-1.


    :- tree(X, Y), not adjacentTree(X, Y, _, _).

    :- tent(X,Y), adjacentTent(X,Y,_,_).

    :- columnCount(C, N), N != #count{X: tent(X,C)}.
    :- rowCount(R, N), N != #count{Y: tent(R,Y)}.

    #show tent/2."


    result=$(echo "$clingoProgram" | clingo 0)

    echo "$result"
}


if [ "$dir" = true ]; then
    for file in "$2"/*; do 
        echo "Processing $file"
        parseAndSolveASP "$file"
    done
else
    echo "Processing "${!#}""
    parseAndSolveASP "${!#}"
fi

exit 1