#!/usr/bin/env bash

# output path:  ../../docs/examples/zencode_cookbook/

RNGSEED="hex:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"

####################
# common script init
# if ! test -r ../utils.sh; then
#	echo "run executable from its own directory: $0"; exit 1; fi
# . ../utils.sh
# Z="`detect_zenroom_path` `detect_zenroom_conf`"

zexe() {
	out="$1"
	shift 1
	>&2 echo "test: $out"
	tee "$out" | zenroom -z $*
}


####################

n=0

let n=n+1

echo "                                                "
echo "------------------------------------------------"
echo "  script:  $n            1     "
echo " 												  "
echo "------------------------------------------------"
echo "   											  "


cat <<EOF | zexe ../../docs/examples/zencode_cookbook/petitionRequest.zen -k ../../docs/examples/zencode_cookbook/credentialParticipantAggregatedCredential.json -a ../../docs/examples/zencode_cookbook/credentialIssuerVerifier.json | jq . | tee ../../docs/examples/zencode_cookbook/petitionRequest.json
# Two scenarios are needed for this script, "credential" and "petition".
	Scenario credential: read and validate the credentials
	Scenario petition: create the petition
# Here I state my identity
    Given that I am known as 'Alice'
# Here I load everything needed to proceed
    and I have my valid 'credential keypair'
    and I have my valid 'credentials'
    and I have a valid 'verifier' inside 'MadHatter'
# In the "when" phase we have the cryptographical creation of the petition
    When I aggregate the verifiers
    and I create the credential proof
    and I create the petition 'More privacy for all!'
# Here we are printing out what is needed to the get the petition approved
    Then print the 'verifiers'
	and print the 'credential proof'
	and print the 'petition'
# Here we're just printing the "uid" as string, instead of the default base64
# so that it's human readable - this is not needed to advance in the flow
	and print the 'uid' as 'string' inside 'petition' 
EOF

let n=n+1

echo "                                                "
echo "------------------------------------------------"
echo "  script:  $n            2     "
echo " 												  "
echo "------------------------------------------------"
echo "   											  "


cat <<EOF | zexe ../../docs/examples/zencode_cookbook/petitionApprove.zen -k ../../docs/examples/zencode_cookbook/petitionRequest.json -a ../../docs/examples/zencode_cookbook/credentialIssuerVerifier.json | jq . | tee ../../docs/examples/zencode_cookbook/petitionApproved.json
Scenario credential
Scenario petition: approve
    Given that I have a 'verifier' inside 'MadHatter'
    and I have a 'credential proof'
    and I have a 'petition'
    When I aggregate the verifiers
    and I verify the credential proof
    and I verify the new petition to be empty
    Then print the 'petition'
    and print the 'verifiers'
	and print the 'uid' as 'string' inside 'petition' 
EOF

let n=n+1

echo "                                                "
echo "------------------------------------------------"
echo "  script:  $n            3     "
echo " 												  "
echo "------------------------------------------------"
echo "   											  "


cat <<EOF | zexe ../../docs/examples/zencode_cookbook/petitionSign.zen -k ../../docs/examples/zencode_cookbook/credentialParticipantAggregatedCredential.json -a ../../docs/examples/zencode_cookbook/credentialIssuerVerifier.json | jq . | tee ../../docs/examples/zencode_cookbook/petitionSignature.json
Scenario credential
Scenario petition: sign petition
    Given I am 'Alice'
    and I have my valid 'credential keypair'
    and I have my 'credentials'
    and I have a valid 'verifier' inside 'MadHatter'
    When I aggregate the verifiers
    and I create the petition signature 'More privacy for all!'
    Then print the 'petition signature'
EOF

let n=n+1

echo "                                                "
echo "------------------------------------------------"
echo "  script:  $n              4   "
echo " 												  "
echo "------------------------------------------------"
echo "   											  "


cat <<EOF | zexe ../../docs/examples/zencode_cookbook/petitionAddSignature.zen -k ../../docs/examples/zencode_cookbook/petitionApproved.json -a ../../docs/examples/zencode_cookbook/petitionSignature.json | jq . | tee ../../docs/examples/zencode_cookbook/petitionAddSignature.json
Scenario credential
Scenario petition: aggregate signature
    Given that I have a valid 'petition signature'
    and I have a valid 'petition'
    and I have a valid 'verifiers'
    When the petition signature is not a duplicate
    and the petition signature is just one more
    and I add the signature to the petition
    Then print the 'petition'
    and print the 'verifiers'
EOF

let n=n+1

echo "                                                "
echo "------------------------------------------------"
echo "  script:  $n             5    "
echo " 												  "
echo "------------------------------------------------"
echo "   											  "


cat <<EOF | zexe ../../docs/examples/zencode_cookbook/petitionTally.zen -k ../../docs/examples/zencode_cookbook/credentialParticipantAggregatedCredential.json -a ../../docs/examples/zencode_cookbook/petitionAddSignature.json | jq . | tee ../../docs/examples/zencode_cookbook/petitionTally.json
Scenario credential
Scenario petition: tally
    Given that I am 'Alice'
    and I have my valid 'credential keypair'
    and I have a valid 'petition'
    When I create a petition tally
    Then print all data
EOF

let n=n+1

echo "                                                "
echo "------------------------------------------------"
echo "  script:  $n             6    "
echo " 												  "
echo "------------------------------------------------"
echo "   											  "


cat <<EOF | zexe ../../docs/examples/zencode_cookbook/petitionCount.zen -k ../../docs/examples/zencode_cookbook/petitionTally.json -a ../../docs/examples/zencode_cookbook/petitionAddSignature.json
Scenario credential
Scenario petition: count
    Given that I have a valid 'petition'
    and I have a valid 'petition tally'
    When I count the petition results
    Then print the 'petition results' as 'number'
    and print the 'uid' as 'string' inside 'petition'
	and print 'success!'
EOF

echo "   "
echo "---"
echo "   "
echo "The whole script was executed, success!"
