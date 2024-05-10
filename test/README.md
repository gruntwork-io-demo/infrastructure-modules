# Testing Modules

This repo contains an example test demonstrating how to use [Terratest](https://terratest.gruntwork.io/) to validate 
your modules.

## Running Tests Locally

Pre-requisites:

1. Install [Go](https://go.dev/).
2. Install [Terraform](https://www.terraform.io/).
3. Authenticate to a real AWS account. **This must be an AWS account dedicated to automated testing and should NOT 
   contain any production workloads.**

To run all tests:

```bash
cd test
go test -v . -timeout 90m
```

To run one specific test called `Foo`:

```bash
cd test
go test -v -run '^foo$' -timeout 90m
```
We intentionally set a lengthy timeout as infrastructure code can sometimes take a long period of time to deploy and
undeploy.

## Running Tests in CI

A GitHub Actions file has been provided for your preconfigured to run the example test on any change. To enable this 
behavior:

1. Rename the file from `.github/workflows/test.yml.template` to `.github/workflows/test.yml`.
2. Follow the instrucitons in the TODO comments.
