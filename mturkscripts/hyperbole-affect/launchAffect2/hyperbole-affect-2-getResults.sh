#!/usr/bin/env sh
pushd /Applications/aws-mturk-clt-1.3.0/bin
./getResults.sh $1 $2 $3 $4 $5 $6 $7 $8 $9 -successfile /Users/justinek/Dropbox/Work/Grad_school/Research/Hyperbole/hyperbolicquantifiers/mturkscripts/hyperbole-affect/launchAffect2//hyperbole-affect-2.success -outputfile /Users/justinek/Dropbox/Work/Grad_school/Research/Hyperbole/hyperbolicquantifiers/mturkscripts/hyperbole-affect/launchAffect2//hyperbole-affect-2.results
popd