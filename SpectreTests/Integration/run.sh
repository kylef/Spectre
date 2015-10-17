#!/usr/bin/env bash

EXIT_CODE=0

for var in "$@"; do
  echo "-> '$var'"
  rm $var-output.txt $var-dot-output.txt $var-tap-output.txt 2>/dev/null

  ./$var > $var-output.txt
  if [ $? != 0 ]; then
    if [ $var = "SpectreTests/Integration/Passing" ]; then
      echo "    - Passing Integration Failed"
      EXIT_CODE=1
    fi
  elif [ $var = "SpectreTests/Integration/Failing" ]; then
    echo "    - Failing Integration Succeeded"
    EXIT_CODE=1
  fi
  ./$var -t > $var-dot-output.txt
  if [ $? != 0 ]; then
    if [ $var = "SpectreTests/Integration/Passing" ]; then
      echo "    - Passing Dot Integration Failed"
      EXIT_CODE=1
    fi
  elif [ $var = "SpectreTests/Integration/Failing" ]; then
    echo "    - Failing Dot Integration Succeeded"
    EXIT_CODE=1
  fi
  ./$var --tap > $var-tap-output.txt
  if [ $? != 0 ]; then
    if [ $var = "SpectreTests/Integration/Passing" ]; then
      echo "    - Passing Tap Integration Failed"
      EXIT_CODE=1
    fi
  elif [ $var = "SpectreTests/Integration/Failing" ]; then
    echo "    - Failing Tap Integration Succeeded"
    EXIT_CODE=1
  fi

  diff $var-output.txt $var-expected-output.txt
  if [ $? != 0 ]; then
    echo "Output Mismatch"
    EXIT_CODE=1
  fi
  diff $var-dot-output.txt $var-expected-dot-output.txt
  if [ $? != 0 ]; then
    echo "Dot Output Mismatch"
    EXIT_CODE=1
  fi
  diff $var-tap-output.txt $var-expected-tap-output.txt
  if [ $? != 0 ]; then
    echo "Tap Output Mismatch"
    EXIT_CODE=1
  fi
done

exit $EXIT_CODE

