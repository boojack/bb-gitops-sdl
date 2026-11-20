# Bytebase SDL GitOps test

Manage the desired PostgreSQL schema in `schema/**/*.sql`. Bytebase computes the
migration from the current Neon database to that desired state.

## Configuration

- Bytebase: https://cloud.bytebase.com
- Project: `projects/bb-gitops-nuxa`
- Database: `instances/new-instance-q2h6/databases/neondb`
- Environment: `environments/test`
- Workload identity: `boojack-ci@bb-gitops-nuxa.workload.bytebase.com`

The workload identity must trust `boojack/bb-gitops-sdl`, accept the audience
`bytebase`, and hold the **GitOps Service Agent** role in the project. The action
requests a GitHub OIDC token and signs in with it; no Bytebase or Neon secret is
stored in GitHub.

## Test the workflow

1. Merge the workflow setup pull request. It contains no schema SQL, so neither
   workflow runs.
2. Export the current database schema from Bytebase and place the desired schema
   files under `schema/`. If the database has no application objects, start with
   a new table definition. Keep the complete desired schema in this folder.
3. Open a pull request into `main` with the SQL files. **Bytebase SDL review**
   checks the proposed schema and comments on the pull request. SQL review
   errors fail the job.
4. Merge the schema pull request. **Bytebase SDL deploy** applies the desired
   schema to Neon and waits for the `test` stage to complete.

Merging schema changes deploys to the database. With the GitOps Service Agent
role, the rollout has no Bytebase issue and does not wait for issue approval.
Removing an object from the desired schema can generate a destructive migration.
Require the SDL review check in GitHub branch protection if passing review must
be a condition of merging.

Use schema definitions such as `CREATE TABLE`, rather than incremental
`ALTER TABLE` migrations. Filenames need no version prefix. Reviews run for
pull requests from this repository; fork pull requests are skipped.
