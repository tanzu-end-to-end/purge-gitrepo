#!/bin/bash
set +e

export CURRENT_TIME=$(eval 'date +%s')
export SECONDS_IN_DAY=86400

git clone https://gitea_admin:$GITEA_PASSWORD@gitea.${INGRESS_DOMAIN}/gitea_admin/$1.git

cd $1
git config user.name gitea_admin
git config user.email "gitea_admin@example.com"

for FILE in *;
do 
  export COMMIT_TIME=$(eval "git log -1 --format=%ct $FILE")

  git log -1 --format=%cd $FILE;

  if [[ "$FILE" == "README.MD" ]];
  then
    continue
  fi

  if (( $CURRENT_TIME > $COMMIT_TIME+($NUM_DAYS*$SECONDS_IN_DAY) )) 
  then 
    echo "Purge"
    git rm $FILE
  else
    echo "Don't Purge"
  fi
done

git commit -a -m "Purging expired files"
git push -u origin main