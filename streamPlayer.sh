#!/bin/bash
# define file paths
url_file="urls.txt"
log_file="player.log"

red='\033[0;31m' # Red color code
cyan='\033[0;36m' # Cyan color code
magenta='\033[0;35m' # Magenta color code
nocolor='\033[0m' # Reset color code

echo -e "${magenta}Welcome to StreamPlayer and Ripper${nocolor}"

# read urls from file if none provided as argument
if [ $# -eq 0 ]
then
    if [ -f "$url_file" ]
    then
        while IFS= read -r line
        do
            urls+=("$line")
        done < "$url_file"
    else
        echo "No urls provided and $url_file not found."
        exit 1
    fi
else
    urls=("$@")
fi

# check that mplayer is installed
if ! command -v mplayer &> /dev/null
then
    echo "mplayer not found. Please install mplayer and try again."
    exit 1
fi

# check that streamripper is installed
if ! command -v streamripper &> /dev/null
then
    echo "streamripper not found. Please install streamripper and try again."
    exit 1
fi
echo "urls: ${urls[@]}"

# start player
current_url_index=0
mplayer "${urls[current_url_index]}" &> "$log_file" &
echo -e "Playing stream $((current_url_index + 1)) of ${#urls[@]} ${red}${urls[current_url_index]}${nocolor}"

# define rip status flag
ripping=false

# handle keypresses
while true
do
    read -rsn1 input
    case $input in
        '.') # advance to next url and play
            current_url_index=$(( (current_url_index + 1) % ${#urls[@]} ))
            killall mplayer # stop current player process
            mplayer "${urls[current_url_index]}" &> "$log_file" &
            echo -e "Playing stream $((current_url_index + 1)) of ${#urls[@]} ${red}${urls[current_url_index]}${nocolor}"
            ;;
        ',') # go to previous url and play
            current_url_index=$(( (current_url_index - 1 + ${#urls[@]}) % ${#urls[@]} ))
            killall mplayer # stop current player process
            mplayer "${urls[current_url_index]}" &> "$log_file" &
            echo -e "Playing stream $((current_url_index + 1)) of ${#urls[@]}  ${red}${urls[current_url_index]}${nocolor}"
            ;;
        'r') # toggle streamripper on/off
            if [ "$ripping" = false ]
            then
                ripping=true
                echo -e "${cyan}Starting rip${nocolor} of ${red}${urls[current_url_index]}${nocolor}"
                streamripper "${urls[current_url_index]}" --quiet &
            else
                ripping=false
                echo -e "${nocolor}Stopping rip${nocolor} of ${red}${urls[current_url_index]}${nocolor}"
                pkill -SIGTERM streamripper
            fi
            ;;
        'q') # cleanup and exit
            if [ "$ripping" = false ]
            then
                killall mplayer
                pkill -SIGTERM streamripper
                rm "$log_file"
                echo -e "${magenta}Cleaning up and exiting...${nocolor}"
                exit 0
            else
                echo "Stopping rip of ${urls[current_url_index]}"
                killall mplayer
                pkill -SIGTERM streamripper
                rm "$log_file"
                echo -e "${magenta}Cleaning up and exiting...${nocolor}"
                exit 0
            fi
            ;;
        *) # ignore other keys
            ;;
    esac
done


