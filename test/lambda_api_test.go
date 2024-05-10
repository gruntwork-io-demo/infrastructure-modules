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

const lambdaApiTestFolder = "./lambda-api-test"

func TestLambdaAPI(t *testing.T) {
	t.Parallel()

	// Uncomment the items below to skip certain parts of the test
	//os.Setenv("SKIP_setup", "true")
	//os.Setenv("SKIP_destroy", "true")
	//os.Setenv("SKIP_apply", "true")
	//os.Setenv("SKIP_validate", "true")

	test_structure.RunTestStage(t, "setup", func() {
		uniqueId := random.UniqueId()
		serviceName := fmt.Sprintf("lambda-test-%s", uniqueId)

		opts := &terraform.Options{
			TerraformDir: "../examples/services/lambda-api",
			Vars: map[string]interface{}{
				"service_name": serviceName,
			},
		}

		test_structure.SaveTerraformOptions(t, lambdaApiTestFolder, opts)
	})

	defer test_structure.RunTestStage(t, "destroy", func() {
		opts := test_structure.LoadTerraformOptions(t, lambdaApiTestFolder)
		terraform.Destroy(t, opts)
	})

	test_structure.RunTestStage(t, "apply", func() {
		opts := test_structure.LoadTerraformOptions(t, lambdaApiTestFolder)
		terraform.InitAndApply(t, opts)
	})

	// Validate the ECS service and ALB are working by making an HTTP request to the service
	test_structure.RunTestStage(t, "validate", func() {
		opts := test_structure.LoadTerraformOptions(t, lambdaApiTestFolder)

		apiEndpoint := terraform.OutputRequired(t, opts, "api_endpoint")

		expectedBody := "\"Hello from Lambda!\""

		expectedStatus := 200
		retries := 10
		sleepBetweenRetries := 1 * time.Second

		http_helper.HttpGetWithRetry(t, apiEndpoint, nil, expectedStatus, expectedBody, retries, sleepBetweenRetries)
	})
}
