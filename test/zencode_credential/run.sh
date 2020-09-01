#!/usr/bin/env bash

# output path: ../../docs/examples/zencode_cookbook/


####################
# common script init
if ! test -r ../utils.sh; then
	echo "run executable from its own directory: $0"; exit 1; fi
. ../utils.sh
Z="`detect_zenroom_path` `detect_zenroom_conf`"
####################

# credential request

cat << EOF | zexe ../../docs/examples/zencode_cookbook/credentialParticipantKeygen.zen | tee ../../docs/examples/zencode_cookbook/credentiaParticipantKeypair.json
Scenario credential: credential keygen
    Given that I am known as 'Alice'
    When I create the credential keypair
    Then print my 'credential keypair'
EOF

cat << EOF | zexe ../../docs/examples/zencode_cookbook/credentialParticipantSignatureRequest.zen -k ../../docs/examples/zencode_cookbook/credentiaParticipantKeypair.json | tee ../../docs/examples/zencode_cookbook/credentiaParticipantSignatureRequest.json
Scenario credential: create request
    Given that I am known as 'Alice'
    and I have my valid 'credential keypair'
    When I create the credential request
    Then print my 'credential request'
EOF

# credential issuance

cat << EOF | zexe ../../docs/examples/zencode_cookbook/credentiaIssuerKeygen.zen | tee ../../docs/examples/zencode_cookbook/credentiaIssuerKeypair.json
Scenario credential: issuer keygen
    Given that I am known as 'MadHatter'
    When I create the issuer keypair
    Then print my 'issuer keypair'
EOF

cat << EOF | zexe ../../docs/examples/zencode_cookbook/credentiaIssuerPublishVerifier.zen -k ../../docs/examples/zencode_cookbook/credentiaIssuerKeypair.json | tee ../../docs/examples/zencode_cookbook/credentiaIssuerVerifier.json
Scenario credential: publish verifier
    Given that I am known as 'MadHatter'
    and I have my valid 'issuer keypair'
    Then print my 'verifier' from 'issuer keypair'
EOF

# credential signature

cat << EOF | zexe ../../docs/examples/zencode_cookbook/credentiaIssuerSignRequest.zen -a ../../docs/examples/zencode_cookbook/credentiaParticipantSignatureRequest.json -k ../../docs/examples/zencode_cookbook/credentiaIssuerKeypair.json | tee ../../docs/examples/zencode_cookbook/credentiaIssuerSignedCredential.json
Scenario credential: issuer sign
    Given that I am known as 'MadHatter'
    and I have my valid 'issuer keypair'
    and I have a 'credential request' inside 'Alice'
    When I create the credential signature
    Then print the 'credential signature'
    and print the 'verifier'
EOF

cat << EOF | zexe ../../docs/examples/zencode_cookbook/credentialParticipantAggregateCredential.zen -a ../../docs/examples/zencode_cookbook/credentiaIssuerSignedCredential.json -k ../../docs/examples/zencode_cookbook/credentiaParticipantKeypair.json | tee ../../docs/examples/zencode_cookbook/credenParticipantAggregatedCredential.json
Scenario credential: aggregate signature
    Given that I am known as 'Alice'
    and I have my valid 'credential keypair'
    and I have a valid 'credential signature'
    When I create the credentials
    Then print my 'credentials'
    and print my 'credential keypair'
EOF

# zero-knowledge credential proof emission and verification

cat << EOF | zexe ../../docs/examples/zencode_cookbook/credentialParticipantCreateProof.zen -k ../../docs/examples/zencode_cookbook/credenParticipantAggregatedCredential.json -a ../../docs/examples/zencode_cookbook/credentiaIssuerVerifier.json | tee ../../docs/examples/zencode_cookbook/credentialParticipantProof.json
Scenario credential: create proof
    Given that I am known as 'Alice'
    and I have my valid 'credential keypair'
    and I have a valid 'verifier' inside 'MadHatter'
    and I have my valid 'credentials'
    When I aggregate the verifiers
    and I create the credential proof
    Then print the 'credential proof'
EOF


cat << EOF | zexe ../../docs/examples/zencode_cookbook/credentialAnyoneVerifyProof.zen -k ../../docs/examples/zencode_cookbook/credentialParticipantProof.json -a ../../docs/examples/zencode_cookbook/credentiaIssuerVerifier.json
Scenario credential: verify proof
    Given that I have a valid 'verifier' inside 'MadHatter'
    and I have a valid 'credential proof'
    When I aggregate the verifiers
    and I verify the credential proof
    Then print 'Success'
EOF

success
