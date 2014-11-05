#!/usr/bin/env sh
pushd /Applications/aws-mturk-clt-1.3.0/bin
./getResults.sh $1 $2 $3 $4 $5 $6 $7 $8 $9 -successfile /Users/justinek/Dropbox/Work/Grad_school/Research/hyperbolicquantifiers/mturkscripts/priors/launch_v2//priors.success -outputfile /Users/justinek/Dropbox/Work/Grad_school/Research/hyperbolicquantifiers/mturkscripts/priors/launch_v2//priors.results
popd