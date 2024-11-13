SHELL Script: List all Active AWS Resources
-	Script accepts AWS Region and Resource Type (below) as in input.

-	List out all the AWS Resources that your organisation uses.
-	Some common resources:
	-	EC2, S3, EBS, SNS, Lambda, VPC, EFS, EKS
-	Any resources other than this, script will throw error “not included”
-	Instead of using Curl along with Authn Authz to talk to AWS API, code becomes lengthy.
-	So script will talk to AWS CLI which then perform task on AWS.
-	In Python, py script talks to Boto3 to talk to AWS API.
-	Only provide execute access to other users i.e. other users can only execute but not change the script.
	i.e. chmod 771 script all access to yourself, and your group but only execute to other users.