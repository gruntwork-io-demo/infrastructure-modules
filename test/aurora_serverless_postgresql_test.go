package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

const auroraTestFolder = "./aurora-test"

func TestAuroraServerlessPostgresql(t *testing.T) {
	t.Parallel()

	// Uncomment the items below to skip certain parts of the test
	//os.Setenv("SKIP_setup", "true")
	//os.Setenv("SKIP_destroy", "true")
	//os.Setenv("SKIP_apply", "true")
	//os.Setenv("SKIP_validate", "true")

	test_structure.RunTestStage(t, "setup", func() {
		// Read the name of the VPC to use for testing from an environment variable
		vpcName := GetRequiredEnvVar(t, "TEST_VPC_NAME")

		uniqueId := random.UniqueId()
		name := fmt.Sprintf("aurora-test-%s", uniqueId)
		dbName := uniqueId
		masterUsername := "masteruser"
		masterPassword := uniqueId

		opts := &terraform.Options{
			TerraformDir: "../examples/services/ecs-fargate-service-with-alb",
			Vars: map[string]interface{}{
				"vpc_name": vpcName,
				"name":     name,
				"db_name":  dbName,
			},
			EnvVars: map[string]string{
				"TF_VAR_master_username": masterUsername,
				"TF_VAR_master_password": masterPassword,
			},
		}

		test_structure.SaveTerraformOptions(t, auroraTestFolder, opts)
	})

	defer test_structure.RunTestStage(t, "destroy", func() {
		opts := test_structure.LoadTerraformOptions(t, auroraTestFolder)
		terraform.Destroy(t, opts)
	})

	test_structure.RunTestStage(t, "apply", func() {
		opts := test_structure.LoadTerraformOptions(t, auroraTestFolder)
		terraform.InitAndApply(t, opts)
	})
}
