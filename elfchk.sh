#!/bin/bash

echo "usage: elfchk.sh dbfile  inputdir/ "

if [[ $# -eq 0 ]] ; then
    echo 'no args'
    exit 0
fi

dbfile="$1"
elfdir="$2"

IFS=$'\n'


  for f in $(find "$elfdir" -type f)
  do
   if file -b -e apptype -e ascii -e encoding -e tokens -e cdf -e compress -e elf -e tar -e text "$f" | grep -i -q ^elf 
   then
    fname=`basename "$f"`
    flen=`stat -c %s "$f"`
    shack="`rhash --sha3-512 "$f" | head -c 128`,$flen,$fname"
    if ! grep -F -q "$shack" "$dbfile" 
    then
     echo "ERR:$shack"
#     else
#      echo "OK:$shack"
    fi
   fi
  done
 

 echo "DONE"
exit 0



# real    61m14.593s bez -e


#  -e apptype -e ascii -e encoding -e tokens -e cdf -e compress -e elf -e soft -e tar -e text    
