package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestNull(t *testing.T) {
	t.Parallel()

	opts := &terraform.Options{
		TerraformDir: "../examples/mock/null",
	}

	defer terraform.Destroy(t, opts)
	terraform.InitAndApply(t, opts)

	// Validate `id` output to check the module is working as expected
	id := terraform.OutputRequired(t, opts, "id")
	assert.NotNil(t, id)
}
