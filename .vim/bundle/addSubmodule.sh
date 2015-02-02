#/bin/sh
# Adds all git repos in this folder as submodules
for i in $(ls -d */)
do
    if [ -d "$i".git ]
    then
      echo "Adding submodule $i"
      git submodule add $(cd $i && git remote show origin | grep Fetch | awk '{print $3}')
    fi
done
