#!/bin/bash
declare -a targets=(
 [5000]="Jinja2 - Python"
 [5001]="Mako - Python"
)

export file=all.yml

for i in "${!targets[@]}"; do
  echo "var PORT = $i;" > ssti-score.js
  echo "var TITLE = \"${targets[$i]}\";" >> ssti-score.js
  cat ssti-score-main.js >> ssti-score.js
  echo "$i  -> ${targets[$i]}";
  export port=$i
  ./zap.sh -silent -autorun ssti.yaml -dir ssti -cmd
  sleep 5
done

pass=`grep -c "any: Pass" $file`
fail=`grep -c "any: FAIL" $file`

let "score = ($pass * 100) / ($pass + $fail)"

echo "score: $score%" >> $file

echo Pass: $pass
echo Fail: $fail
echo Score: $score%
