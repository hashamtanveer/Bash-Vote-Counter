#!/bin/bash

args=$#

list1=("Popeye" "Tweety" "Homer" "Bugs Bunny" "Snoopy")


checkname()
{
  value=$1
  if [[ " ${list1[@]} " =~ " ${value} " ]]; then 
  return 0 
  fi
  echo "Invalid Candidate Name"
   exit
}

check_no_of_args()
{
  if ( [ "$args" == 2 ] ) || ( [ "$args" == 1 ] || [ "$args" == 4 ] )
    then 
	return 0
  fi
  echo "Incorrect Args"
  exit 
}


#GLOBAL VOTE COUNTER 
TOTAL_VOTES=0
count_votes()
{
  file=$1
  if [ -f $file ]; then 
  CNAME=$2
  votes=$( cat $1 | sed -n -e /$CNAME/p )
  INT_VOTES=${votes##* }
  LOCAL_VOTES=$( echo "$(( $TOTAL_VOTES + $INT_VOTES ))")
  TOTAL_VOTES=$LOCAL_VOTES; fi
}

#That you have to write code to visit each directory seperately 

#main taking three arguments dir, file, name

main() {
  cd "$1"
  count_votes "$2" "$3"
  LOCAL_FILES=$( ls -A | wc -l )
 COUNTER=0
  for i in $( ls -A )
  do 
  COUNTER=$( echo "$(( $COUNTER + 1 ))" )
  if [ -d "$i" ]; then main "$i" "$2" "$3" ; fi
  if [ $COUNTER -gt $LOCAL_FILES ]; then break; fi
  done 
  cd ..
 }




  check_no_of_args "$args" 
  
  if [ $args -eq 1 ]; 
    then 
    checkname "$1"
	DIR=$PWD
	FILE=".votes"
	NAME=$1
    main $DIR $FILE $NAME
	echo $1 $TOTAL_VOTES
	exit
  fi

  if [ $args -eq 2 ]
  then 
    if [ -d "$1" ]; then 
      checkname "$2"
	DIR=$1
	FILE=".votes"
	NAME=$2
      main $DIR $FILE $NAME
	echo $2 $TOTAL_VOTES
	exit
    else
      echo "incorrect Args"
      exit
    fi
  fi

  if [ $args -eq 3 ]; then
	if [ $1 == '-f' ]; then
checkname $3 
	main $PWD $2 $3; fi
	else 
  echo "Incorrect Args"
  exit ; fi

  if [ $args -eq 4 ]; then 
    if [ -d "$3" ]; then 
      if [ "$1" == "-f" ]; then 
        if [ -e "$2" ]; then checkname "$4"
		DIR=$3
		FILE=$2
		NAME=$4
          main $DIR $FILE $NAME
	 echo "$4 $TOTAL_VOTES"
	exit
        else
          echo "Incorrect Args"
          exit
        fi
      else 
        echo "Incorrect Args"
        exit
      fi
    else 
      echo "Incorrect Args"
      exit
    fi



