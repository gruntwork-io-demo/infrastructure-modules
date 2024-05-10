package test

import (
	"fmt"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

const ecsTestFolder = "./ecs-service-test"

func TestEcsFargateServiceWithAlb(t *testing.T) {
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
		serviceName := fmt.Sprintf("ecs-test-%s", uniqueId)
		text := fmt.Sprintf("from ECS Fargate %s", uniqueId)

		opts := &terraform.Options{
			TerraformDir: "../examples/services/ecs-fargate-service-with-alb",
			Vars: map[string]interface{}{
				"vpc_name":     vpcName,
				"service_name": serviceName,
				"text":         text,
			},
		}

		test_structure.SaveTerraformOptions(t, ecsTestFolder, opts)
	})

	defer test_structure.RunTestStage(t, "destroy", func() {
		opts := test_structure.LoadTerraformOptions(t, ecsTestFolder)
		terraform.Destroy(t, opts)
	})

	test_structure.RunTestStage(t, "apply", func() {
		opts := test_structure.LoadTerraformOptions(t, ecsTestFolder)
		terraform.InitAndApply(t, opts)
	})

	// Validate the ECS service and ALB are working by making an HTTP request to the service
	test_structure.RunTestStage(t, "validate", func() {
		opts := test_structure.LoadTerraformOptions(t, ecsTestFolder)

		serviceDnsName := terraform.OutputRequired(t, opts, "service_dns_name")
		url := fmt.Sprintf("http://%s", serviceDnsName)

		text := opts.Vars["text"]
		expectedBody := fmt.Sprintf("Hello %s!", text)

		expectedStatus := 200
		retries := 10
		sleepBetweenRetries := 1 * time.Second

		http_helper.HttpGetWithRetry(t, url, nil, expectedStatus, expectedBody, retries, sleepBetweenRetries)
	})
}
