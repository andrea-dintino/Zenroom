#!/usr/bin/env bash

# output path for documentation: ../../docs/examples/zencode_cookbook/


####################
# common script init
if ! test -r ../utils.sh; then
	echo "run executable from its own directory: $0"; exit 1; fi
. ../utils.sh
Z="`detect_zenroom_path` `detect_zenroom_conf`"
####################

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

tmpConfig0=`mktemp`



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
echo "   Generate a keypair with known seed: $n          "
echo " 												  "
echo "------------------------------------------------"
echo "                                                "

cat <<EOF  > $tmpConfig0
debug=0, rngseed=hex:74eeeab870a394175fae808dd5dd3b047f3ee2d6a8d01e14bff94271565625e98a63babe8dd6cbea6fedf3e19de4bc80314b861599522e44409fdd20f7cd6cfc
EOF

echo "stampa roba"
echo $tmpConfig0
echo "fine stampa roba"

cat $tmpZencode0 | zexe ../../docs/examples/zencode_cookbook/temp.zen -z -c rngseed=hex:74eeeab870a394175fae808dd5dd3b047f3ee2d6a8d01e14bff94271565625e98a63babe8dd6cbea6fedf3e19de4bc80314b861599522e44409fdd20f7cd6cfc | jq . | tee ../../docs/examples/zencode_cookbook/scenarioECDHKeypair2.json



echo "                                                "
echo "------------------------------------------------"
echo "   	END of script $n       		  			"
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
	  "password":"123SecretPassword!",
      "header": "A very important secret",
	  "message": "Dear Bob, your name is too short, goodbye - Alice.",   
	}
}
EOF
cat $tmpData1 > ../../docs/examples/zencode_cookbook/scenarioECDHInputDataPart1.json



cat <<EOF  > $tmpZencode1
# Encrypt with password
Scenario 'ecdh': Encrypt a message with the password
# the names "header", "message" and "password" are hardcoded when using the encrypt statement
Given I have a 'string' named 'password'
And I have a 'string' named 'message'
And I have a 'string' named 'header'
When I encrypt the secret message 'message' with 'password'
# anything introduced by 'the' becomes a new variable
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
	  "password":"123SecretPassword!" 
	},
	
  "secret_message": {
    "checksum": "_OLzdMirHBiooaJIqrrFbA",
    "header": "QSB2ZXJ5IGltcG9ydGFudCBzZWNyZXQ",
    "iv": "JamUZPb9oV7Cre8xA9a9sft52L6ZmPMinBYCjDWIlJM",
    "text": "evcBTfLFyTAUKeIet6Dv3y4MdRysdJVdGGyNanq64sqUQbqtfJDAaNNdlJjS-5kQAjg"
  }
}
EOF
cat $tmpData2 > ../../docs/examples/zencode_cookbook/scenarioECDHInputDataPart1.json



cat <<EOF  > $tmpZencode2
# Encrypt with password
Scenario 'ecdh': Decrypt the message with the password
Given I have a 'secret message'
Given I have a 'string' named 'password'
When I decrypt the secret message with 'password'
Then print the 'text' as 'string' in 'message'
and print the 'header' as 'string' in 'message'
EOF


cat $tmpZencode2 > ../../docs/examples/zencode_cookbook/scenarioECDHZencodePart2.zen


cat $tmpZencode2 | zexe ../../docs/examples/zencode_cookbook/temp.zen -z -a $tmpData2 | jq . | tee ../../docs/examples/zencode_cookbook/scenarioECDHPart2.json




echo "                                                "
echo "------------------------------------------------"
echo "   	END of script $n			       		  "
echo "------------------------------------------------"
echo "                                      "

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