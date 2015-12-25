#!/bin/sh
awk '{$2=$3$2;$3=$5$4} {print}' oml.txt | awk '{print $1,$2,$3}' > oml1.txt
awk '{$2=strtonum("0x"$2);$3=strtonum("0x"$3)} {print}' oml1.txt  > oml2.txt
awk '{
	if($2<235){$4="error"}
	else if($2<285) {$4="10.95.101.203"}
	else if($2<335) {$4="10.95.101.204"}
	else if ($2<385) {$4="10.95.101.205"}
	else if($2<435) {$4="10.95.101.206"}
	else if ($2<485) {$4="10.95.101.207"}
	else if($2<705) {$4="error"}
	else if($2<755){$4="10.95.101.208"}
	else if($2<805) {$4="10.95.101.209"} 
	else {$4="error"}}
	{print}' oml2.txt  > oml3.txt


