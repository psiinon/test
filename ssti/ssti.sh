#!/bin/bash
declare -a targets=(
 [5000]="Jinja2 - Python"
 [5001]="Mako - Python"
 [5002]="Tornado - Python"
 [5002]="Django - Python"
)

cd /zap/wrk/

export file=/zap/wrk/all.yml

/zap/zap.sh -silent -addoninstall ascanrulesAlpha -cmd

echo "section: All URLs" > $file
echo "details:" >> $file

for i in "${!targets[@]}"; do
  echo "var PORT = $i;" > ssti-score.js
  echo "var TITLE = \"${targets[$i]}\";" >> ssti-score.js
  cat ssti-score-main.js >> ssti-score.js
  echo "$i  -> ${targets[$i]}";
  export port=$i
  pwd
  /zap/zap.sh -silent -autorun /zap/wrk/ssti.yaml -dir ssti -cmd
  cat $file
  sleep 5
done

pass=`grep -c "any: Pass" $file`
echo Pass: $pass
fail=`grep -c "any: FAIL" $file`
echo Fail: $fail

let "score = ($pass * 100) / ($pass + $fail)"
echo Score: $score%

echo "score: $score%" >> $file

echo Pass: $pass
echo Fail: $fail
echo Score: $score%
