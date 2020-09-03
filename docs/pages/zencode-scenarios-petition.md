

<!-- Unused files
 
givenDebugOutputVerbose.json
givenLongOutput.json
 

Link file with relative path: <a href="./_media/examples/zencode_cookbook/givenArraysLoadInput.json">givenArraysLoadInput.json</a>
 
-->


Zenroom's *petition scenario* was developed within [DDDC pilot of the DECODE project](https://decodeproject.eu/pilots) and its cryptography is defined in the [Coconut paper](https://arxiv.org/abs/1802.07344) and uses zero knowledge proof credentials defined in the same paper.
The flow includes: 
 - The creation and approval of a cryptographical petition object.
 - The participant's cryptographical signature of the petition, based on a zero knowledge proof credential.
 - The tally: the cryptographical closing of the petition, counting petitions is not possible before the tally and signing petitions won't be possible afterwards.
 - Counting of the signatures.

The participant's credentials can be anonymous and each participant (or each credential possessor) can only sign the petition once. 

 
## Create a the petition: creation and request
 
Any participant can create a petition. The requirements to become a participant are:
 
 - A keypair: generated by Zenroom using the *ecdh* or *credential* scenarios
 - A credential: this needs to be produced by a credential issuer and later aggregated with the participant keypair (using the *credential* scenario) 
 - The credential issuer's verifier: this allows the creation and verification to be executed by any party and offline
 
Any participant can create a petition, but the requests needs to later be cryptographically approved by a second peer. The basic script to create a petition and request its approval, *petitionRequest.zen* is: 

[](../_media/examples/zencode_cookbook/petitionRequest.zen ':include :type=code gherkin')

The script requires the aggregagated credentials from the participant (*credentialParticipantAggregatedCredential.json*), which is created using the *credential* scenario by aggregating:
 - the participant keypair 
 - and a credential, produced by the *credential issuer*, that will be unique for each petition

[](../_media/examples/zencode_cookbook/credentialParticipantAggregatedCredential.json ':include :type=code json')

as well the verifier from the credential issuer (*credentialIssuerVerifier.json*): 

[](../_media/examples/zencode_cookbook/credentialIssuerVerifier.json ':include :type=code json')

The result should look like this (*petitionRequest.json*):

[](../_media/examples/zencode_cookbook/petitionRequest.json ':include :type=code json')




## Approve the petition request

In the second step, theorethically anybody can check if the petition created in the first step is valid and if the creator was allowed to create one. This script can be run be a central verifier or as a smart contract on a blockchain, along with a consensus algorythm.


The script needs as input the *credentialIssuerVerifier.json* (that would ideally be retrieved from a blockchain or web address) as long as the output of the previous script, the file *petitionRequest.json*. The script to approve the creation of the petition looks like:

[](../_media/examples/zencode_cookbook/petitionApprove.zen ':include :type=code gherkin')

and if successful the result *petitionApproved.json* contains: 
 - crypto-data about the petition 
 - the *verifiers*, which contain crypto-data aimed to identify the *credential issuer* that produces the credentials used to create, approve and sign the petition.
 
The *petitionApproved.json* should look like this:

[](../_media/examples/zencode_cookbook/petitionApproved.json ':include :type=code json')

After the petition has been approved it can be published and signatures can be added (*aggregated*) to it.

## Signing the petition

Once the petition has been created and approved, in the next step, any participant can sign the petition.

The data needed are the *credentialParticipantAggregatedCredential.json* and the *credentialIssuerVerifier.json*, and the *uid* of the petition itself (in the script below the *uid* is passed as an *inline* value). The credential used by the participant is unique to this petition and can only be **counted** along with signatures produced using similar credentials. A basic script to sign a petition looks like:

[](../_media/examples/zencode_cookbook/petitionSign.zen ':include :type=code gherkin')

The result *petitionSignature.json* should look like this:

[](../_media/examples/zencode_cookbook/petitionSignature.json ':include :type=code json')


## Aggregating the signatures: building the signature list 

Once the petition has been signed by a participant


[](../_media/examples/zencode_cookbook/petitionAddSignature.zen ':include :type=code gherkin')

output

[](../_media/examples/zencode_cookbook/petitionAddSignature.json ':include :type=code json')





## Tally 

[](../_media/examples/zencode_cookbook/petitionTally.json ':include :type=code json')
