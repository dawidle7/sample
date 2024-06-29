#!/bin/bash

OPTSTR="he:"
e=' -not -path "/dev/*" -a -not -path "/tmp/*" -a -not -path "/proc/*" -a -not -path "/sys/*" -a -not -path "/run/*" '
while getopts ${OPTSTR} o
do
    case $o in
        e) echo "Excluding $OPTARG"; e+=$OPTARG ;;
        :) echo "-$OPTARG requires an argument."; exit 1 ;;
        h | ?) echo "Usage sample.sh [-h] [-e DIR]"; exit 1 ;;
    esac
done
#e="(^\/proc|^\/sys|^\/dev)"; fi
echo Final exclusion list $e


echo Checking for gentoolkit...
emstatus=$(which equery 2>&1)
if [[ $emstatus  =~ ^which ]]
then 
    read -p "No gentoolkit on this system, it is recommended not to continue: y or n? " ans
    case $ans in
        y) echo "Continuing..." ;;
        n) echo "Bye"; exit 1 ;;
        *) echo "Unrecognized selection: $ans"; exit 1 ;;
    esac
else echo $emstatus
fi


echo Running as $LOGNAME
if [ $LOGNAME == "root" ]
then
    echo This is risky. Consider exiting..
fi
 


# while read -r pkg
# do
#     while read -r f
#     do
#         if ! [ -e "$f" ] 
#         then
#             echo Missing file: "$f" from "$pkg"
#         fi
#     done < <(equery f $pkg |tail -n+2)
# done < <(equery l '*')


echo Looking for missing files which should be installed
lif=()
while read -r f
do
    lif+=("$f")
    # if ! [ -e "$f" ]
    # then
    #     pkg=$(equery b "$f")
    #     echo Missing file: $f from $pkg
    #     read -t 1 -u 1 -p "Would you like to reinstall? y/n? " ans
    #     if ! [ -z $ans ]
    #     then
    #         case $ans in
    #             y) emerge -1v $pkg ;;
    #             n) continue ;;
    #             *) echo "Unrecognized selection: $ans"; exit 1 ;;
    #         esac
    #     else echo ""
    #     fi
    #     ans=""
    # fi
done < <(equery f '*' )
echo Size "${#lif[@]}"
declare -A lifu
for i in "${lif[@]}"; do lifu["$i"]=1; done
lif=()
for i in "${!lifu[@]}"; do lif+=("$i"); done
unset $lifu
echo New size "${#lif[@]}"



echo Looking for files present which were not installed
while read -r f
do
    #if [[ "$f" =~ $e ]]; then continue; fi
    if ! [[ $(echo "${lif[@]}" | grep -Fw "$f") ]]
    then
        echo "$f not found"
        echo "$f" >> ./sample.backup.files
    else
        echo "$f found"
    fi
done < <(eval 'find /etc '$e' 2>./sample.err')


