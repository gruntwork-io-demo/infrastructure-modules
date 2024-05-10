package test

import (
	"regexp"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

var vpcIdRegex = regexp.MustCompile("vpc-.+")
var subnetIdRegex = regexp.MustCompile("subnet-.+")

func TestVpcAppLookup(t *testing.T) {
	t.Parallel()

	// Read the name of the VPC to use for testing from an environment variable
	vpcName := GetRequiredEnvVar(t, "TEST_VPC_NAME")

	opts := &terraform.Options{
		TerraformDir: "../examples/networking/vpc-app-lookup",
		Vars: map[string]interface{}{
			"vpc_name": vpcName,
		},
	}

	defer terraform.Destroy(t, opts)
	terraform.InitAndApply(t, opts)

	// Validate a few output variables to check the module is working as expected
	vpcId := terraform.OutputRequired(t, opts, "vpc_id")
	assert.Regexp(t, vpcIdRegex, vpcId)

	actualVpcName := terraform.OutputRequired(t, opts, "vpc_name")
	assert.Equal(t, vpcName, actualVpcName)

	publicSubnetIds := terraform.OutputList(t, opts, "public_subnet_ids")
	assert.NotEmpty(t, publicSubnetIds)
	for _, subnetId := range publicSubnetIds {
		assert.Regexp(t, subnetIdRegex, subnetId)
	}
}
