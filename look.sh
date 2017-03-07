#!/bin/bash

FILE=$1
SEP="|"
COL_LEN=30
DOT=" "
HYPHEN="-"
title=true

function add_spaces {
   OPTIND=1
   local str
   local sep=$DOT

   while getopts "s:" option; do
      case "$option" in
         s) sep=$OPTARG;;
     esac
   done

   eval str='$'$OPTIND

   local str_len=${#str}
   local end=$(($COL_LEN-$str_len))
   local out

   if [ $str_len -gt $COL_LEN ]; then
      out=${str:0:$COL_LEN}
   else
      for ((i=0; i<$end; i++)); do
         out="$out$sep"
      done
      out="$out$str"
   fi

   echo "$out"
}


function main {
   for f in $(cat $1); do
      output="$SEP "
      header="$SEP "
      for c in $(echo $f |tr "," "\n"); do
         output=$output$(add_spaces $c)" "$SEP" "
         if [ $title = true ]; then
            header=$header$(add_spaces -s $HYPHEN)" "$SEP" "
         fi
      done
      echo "$output"

      if [ $title = true ]; then
         echo $header
         title=false
      fi
   done
}

main $FILE
