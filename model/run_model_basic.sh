#!/bin/bash

for i in {1..1000}
	do
		node test/run_sandbox.js ~/Dropbox/Work/Grad_school/Research/hyperbolicquantifiers/model/models_basic/$i.church > /Users/justinek/Dropbox/Work/Grad_school/Research/hyperbolicquantifiers/model/models_basic_output/$i.txt
	done

