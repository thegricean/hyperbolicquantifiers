#!/bin/bash

for i in {1..1000}
	do
		python parseOutputAllAffects.py models_basic_output/$i.txt > models_basic_output/$i.csv	
	done

