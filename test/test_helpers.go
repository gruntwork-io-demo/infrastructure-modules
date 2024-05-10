package test

import (
	"os"
	"testing"
)

func GetRequiredEnvVar(t *testing.T, envVarName string) string {
	value := os.Getenv(envVarName)
	if value == "" {
		t.Fatalf("This test requires that you set the environment variable '%s'", envVarName)
	}
	return value
}
