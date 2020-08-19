#!/usr/bin/env bash

RNGSEED="hex:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"

####################
# common script init
# if ! test -r ../utils.sh; then
# 	echo "run executable from its own directory: $0"; exit 1; fi
# . ../utils.sh
# Z="`detect_zenroom_path` `detect_zenroom_conf`"
zexe() {
	out="$1"
	shift 1
	>&2 echo "test: $out"
	tee "$out" | zenroom -z $*
}
####################

## Path: ../../docs/examples/zencode_cookbook/

n=0
tmpData1=`mktemp`
tmpData2=`mktemp`
tmpData3=`mktemp`
tmpData4=`mktemp`

tmpKeys1=`mktemp`
tmpKeys2=`mktemp`
tmpKeys3=`mktemp`
tmpKeys4=`mktemp`

tmpZencode0=`mktemp`
tmpZencode1=`mktemp`
tmpZencode2=`mktemp`
tmpZencode3=`mktemp`
tmpZencode4=`mktemp`




let n=n+1
echo "                                                "
echo "------------------------------------------------"
echo "   Generate a keypair: $n          "
echo " 												  "
echo "------------------------------------------------"
echo "                                                "


cat <<EOF  > $tmpZencode0
Scenario 'ecdh': Generate a keypair
Given I am 'Andrea'
When I create the keypair
Then print my data
EOF

cat $tmpZencode0 > ../../docs/examples/zencode_cookbook/scenarioECDHZencodePart0.zen

cat $tmpZencode0 | zexe ../../docs/examples/zencode_cookbook/temp.zen -z | jq . | tee ../../docs/examples/zencode_cookbook/scenarioECDHKeypair1.json

let n=n+1
echo "                                                "
echo "------------------------------------------------"
echo "  Generate a keypair with known seed: $n       "
echo "  The known seed is:							  "
echo "  74eeeab870a394175fae808dd5dd3b047f3ee2d6a8d01e14bff94271565625e98a63babe8dd6cbea6fedf3e19de4bc80314b861599522e44409fdd20f7cd6cfc "
echo "------------------------------------------------"
echo "                                                "



cat $tmpZencode0 | zexe ../../docs/examples/zencode_cookbook/temp.zen -z -c rngseed=hex:74eeeab870a394175fae808dd5dd3b047f3ee2d6a8d01e14bff94271565625e98a63babe8dd6cbea6fedf3e19de4bc80314b861599522e44409fdd20f7cd6cfc | jq . | tee ../../docs/examples/zencode_cookbook/scenarioECDHKeypair2.json



echo "                                                "
echo "------------------------------------------------"
echo "   	END of Generate a keypair with known seed - script $n"
echo "                                                "
echo " The keypair should be:  "
echo "                                                "
echo " {"Andrea":{"keypair":{"private_key":"Aku7vkJ7K01gQehKELav3qaQfTeTMZKgK+5VhaR3Ui0=","public_key":"BBCQg21VcjsmfTmNsg+I+8m1Cm0neaYONTqRnXUjsJLPa8075IYH+a9w2wRO7rFM1cKmv19Igd7ntDZcUvLq3xI="}}}  "
echo "------------------------------------------------"
echo "                                                "



let n=n+1
echo "                                                "
echo "------------------------------------------------"
echo "   Encrypt message with a password: $n          "
echo " 												  "
echo "------------------------------------------------"
echo "                                                "



cat <<EOF  > $tmpData1
{
   "mySecretStuff":{
	  "password":"myVerySecretPassword",
      "header": "A very important secret",
	  "message": "Dear Bob, your name is too short, goodbye - Alice.",   
	}
}
EOF
cat $tmpData1 > ../../docs/examples/zencode_cookbook/scenarioECDHInputDataPart1.json



cat <<EOF  > $tmpZencode1

Scenario 'ecdh': Encrypt a message with the password 
	Given that I have a 'string' named 'password' inside 'mySecretStuff'
	Given that I have a 'string' named 'header' inside 'mySecretStuff'
	Given that I have a 'string' named 'message' inside 'mySecretStuff'
	When I encrypt the secret message 'message' with 'password'
	Then print the 'secret message'	

EOF

cat $tmpZencode1 > ../../docs/examples/zencode_cookbook/scenarioECDHZencodePart1.zen


cat $tmpZencode1 | zexe ../../docs/examples/zencode_cookbook/temp.zen -z -a $tmpData1 | jq . | tee ../../docs/examples/zencode_cookbook/scenarioECDHPart1.json



echo "                                                "
echo "------------------------------------------------"
echo "   	END of script $n       		  			"
echo "------------------------------------------------"
echo "                                                "


let n=n+1
echo "                                                "
echo "------------------------------------------------"
echo "   Decrypt message with a password: $n          "
echo " 												  "
echo "------------------------------------------------"
echo "                                                "



cat <<EOF  > $tmpData2
{
   "mySecretStuff":{
	  "password":"myVerySecretPassword" 
	},
	
  	"secret_message": {
				"checksum": "7B65F+rARhq9RAkjLhdwmA==",
				"header": "Zm9yIHlvdXIgZXllcyBvbmx5",
				"iv": "9EHllNIm81ZxPmNpFeMR2++Dki6TORnbl9UWJ5PRn5Q=",
				"text": "UQM/yZ5Nh4aGkJuWx1cDWBNPhNpS0A2uuDVkmeXgAZfywwzWX49fKh9Q"
			}
}
EOF
cat $tmpData2 > ../../docs/examples/zencode_cookbook/scenarioECDHInputDataPart1.json



cat <<EOF  > $tmpZencode2
Scenario 'ecdh': Decrypt the message with the password 
	Given that I have a valid 'secret message' 
	Given that I have a 'string' named 'password' inside 'mySecretStuff'
	When I decrypt the secret message with 'password' 
	Then print the 'text' as 'string' inside 'message' 
	Then print the 'header' as 'string'  inside 'message' 		
EOF


cat $tmpZencode2 > ../../docs/examples/zencode_cookbook/scenarioECDHZencodePart2.zen


cat $tmpZencode2 | zexe ../../docs/examples/zencode_cookbook/temp.zen -z -a $tmpData2 | jq . | tee ../../docs/examples/zencode_cookbook/scenarioECDHPart2.json




echo "                                                "
echo "------------------------------------------------"
echo "   	END of script $n			       		  "
echo "------------------------------------------------"
echo "                         			              "




let n=n+1
echo "                                                "
echo "------------------------------------------------"
echo "   create the signature of an object: $n          "
echo " 												  "
echo "------------------------------------------------"
echo "                                                "



cat <<EOF  > $tmpData3
{
   "mySecretStuff":{
	  "myMessage": "Dear Bob, your name is too short, goodbye - Alice.",   
	},
  "Andrea": {
    "keypair": {
      "private_key": "Aku7vkJ7K01gQehKELav3qaQfTeTMZKgK+5VhaR3Ui0=",
      "public_key": "BBCQg21VcjsmfTmNsg+I+8m1Cm0neaYONTqRnXUjsJLPa8075IYH+a9w2wRO7rFM1cKmv19Igd7ntDZcUvLq3xI="
    }
  },
   "myStringArray":[
		 "Hello World! This is my string array, element [0]",
		 "Hello World! This is my string array, element [1]",
		 "Hello World! This is my string array, element [2]"
      ],
	

}
EOF
cat $tmpData3 > ../../docs/examples/zencode_cookbook/scenarioECDHInputDataPart2.json



cat <<EOF  > $tmpZencode3
Scenario 'ecdh': create the signature of an object
Given I am 'Andrea'
Given I have my 'keypair'
Given that I have a 'string' named 'myMessage' inside 'mySecretStuff'
Given I have a 'string array' named 'myStringArray'
When I create the signature of 'myStringArray'
When I rename the 'signature' to 'myStringArray.signature'
When I create the signature of 'keypair'
When I rename the 'signature' to 'keypair.signature'
When I create the signature of 'myMessage'
Then print the 'myMessage'
Then print the 'signature'	
Then print the 'myStringArray'
Then print the 'myStringArray.signature'
Then print the 'keypair'
Then print the 'keypair.signature'

EOF


cat $tmpZencode3 > ../../docs/examples/zencode_cookbook/scenarioECDHZencodePart3.zen


cat $tmpZencode3 | zexe ../../docs/examples/zencode_cookbook/temp.zen -z -a $tmpData3 | jq . | tee ../../docs/examples/zencode_cookbook/scenarioECDHPart3.json




echo "                                                "
echo "------------------------------------------------"
echo "   	END of script $n			       		  "
echo "------------------------------------------------"
echo "                         			              "





let n=n+1
echo "                                                "
echo "------------------------------------------------"
echo "   Verify the signature of an object: $n          "
echo " 												  "
echo "------------------------------------------------"
echo "                                                "



cat <<EOF  > $tmpData4
{

 "Andrea": {
      "public_key": "BBCQg21VcjsmfTmNsg+I+8m1Cm0neaYONTqRnXUjsJLPa8075IYH+a9w2wRO7rFM1cKmv19Igd7ntDZcUvLq3xI="
    }
  }

EOF
cat $tmpData4 > ../../docs/examples/zencode_cookbook/scenarioECDHAndreaPublicKey.json



cat <<EOF  > $tmpZencode4
	rule check version 1.0.0 
	Scenario 'ecdh': Bob verifies the signature from Andrea
	Given that I am known as 'Bob' 
	Given I have a 'public key' from 'Andrea' 
	Given I have a 'string' named 'myMessage' 
	Given I have a valid 'signature'  
	When I verify the 'myMessage' is signed by 'Andrea' 
    Then print 'Zenroom certifies that signature is correct!' as 'string' 
	Then print the 'myMessage' 
	Then print the 'myMessage.signature'
EOF


cat $tmpZencode4 > ../../docs/examples/zencode_cookbook/scenarioECDHZencodePart4.zen


cat $tmpZencode4 | zexe ../../docs/examples/zencode_cookbook/temp.zen -z -k $tmpData4 -a ../../docs/examples/zencode_cookbook/scenarioECDHPart3.json | jq . | tee ../../docs/examples/zencode_cookbook/scenarioECDHPart4.json




echo "                                                "
echo "------------------------------------------------"
echo "   	END of script $n			       		  "
echo "------------------------------------------------"
echo "                         			              "







rm -f ../../docs/examples/zencode_cookbook/temp.zen

rm -f $tmp
rm -f $tmpGiven
rm -f $tmpWhen1
rm -f $tmpZen1
rm -f $tmpWhen2
rm -f $tmpZen2
rm -f $tmpWhen3
rm -f $tmpZen3
rm -f $tmpWhen4
rm -f $tmpZen4


rm -f $tmpData1
rm -f $tmpData2
rm -f $tmpData3
rm -f $tmpData4

rm -f $tmpKeys1
rm -f $tmpKeys2
rm -f $tmpKeys3
rm -f $tmpKeys4

rm -f $tmpZencode1
rm -f $tmpZencode2
rm -f $tmpZencode3
rm -f $tmpZencode4