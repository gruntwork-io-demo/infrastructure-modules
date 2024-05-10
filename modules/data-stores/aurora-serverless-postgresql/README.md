# Aurora Serverless V2 PostgreSQL

This is an example module that wraps several Gruntwork modules to deploy an Aurora Serverless V2 Database with 
PostgreSQL compatibility. 

## What this module does

**Note**: this module is meant as a _starting point_. It makes a number of assumptions, as listed below, that you may 
need to tweak for your use cases. We fully expect you to customize this module to your needs!

1. Create an Aurora Serverless V2 database. If you want Serverless v1 or provisioned or some other type of Aurora DB,
   modify the `engine_mode` parameter.
2. Configure the database for PostgreSQL compatibility. If you want MySQL compatibility, modify the `engine` and 
   `port` parameters.
3. Pass in the master username and password via Terraform variables. If you wish to read this data from AWS Secrets
   Manager, see the `db_config_secrets_manager_id` parameter.
4. Not enable copying snapshots to other AWS accounts. If you wish to enable this, see the `share_snapshot_xxx` 
   parameters.

## How to try out this module in a sandbox / testing environment

See the [aurora-serverless-postgresql example](/examples/data-stores/aurora-serverless-postgresql).

## How to deploy this module in a real environment (e.g., dev/stage/prod)

1. Install [Terragrunt](https://terragrunt.gruntwork.io/).

2. Check out your team's `infra-live` repo (replace `INFRA_LIVE_REPO_URL` with the repo URL in the command below): 

    ```bash
    git clone <INFRA_LIVE_REPO_URL>
    ```

3. Create a new branch (replace `DB_NAME` with the name for the DB in the command below): 

    ```bash
    git checkout -b deploy-<DB_NAME>
    ```

4. Create a folder for this DB and go into that folder (replace `DB_NAME` with the name for the DB 
   and `AWS_REGION` with the AWS region you're using in your `infra-live` repo in the command below): 

    ```bash
    mkdir -p dev/<AWS_REGION>/data-stores/<DB_NAME>
    cd dev/<AWS_REGION>/data-stores/<DB_NAME>
    ```

5. Run Terragrunt to scaffold out a `terragrunt.hcl` for the DB: 

    ```bash
    terragrunt scaffold github.com/gruntwork-io/infrastructure-modules//modules/data-stores/aurora-serverless-postgresql
    ```

6. The previous step will create a `terragrunt.hcl` file. Open it up and fill in the input variables as specified.

7. Add, commit, and push your changes to Git (replace `DB_NAME` with the name for the DB in the command below): 

    ```bash
    git add terragrunt.hcl
    git commit -m "Deploy DB <DB_NAME>"
    git push origin deploy-<DB_NAME>
    ```

8. Navigate to your `infra-live` repo in your web browser and [open a pull 
   request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request#creating-the-pull-request).

9. The CI / CD pipeline will automatically run `plan` on your pull request.

10. If everything looks OK with the code changes and `plan` output, merge the pull request, and the CI / CD pipeline 
    will automatically run `apply` to deploy your DB. 