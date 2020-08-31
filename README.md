# YnabSync

Utility to keep YNAB in sync with your bank accounts using Plaid.

## Usage

Once set up, you can just sync your YNAB account with:

`bundle exec bin/sync`

But setting this up is difficult: You need to set up a Plaid account & link it
to your bank accounts, then configure access to both YNAB & Plaid APIs and
optionally you can configure the categorizations.

## Deployment

Development happens in `master`. The most convenient way to deploy this to a
server is using a free Heroku account. You can use Heroku Scheduler to run
this every 10m or every hour.

To deploy the configuration files, the easiest is to have them committed to
a secret branch (never push it to origin). For example:

```
$ git checkout -b master-with-secrets           # Create "secret" branch
$ git push heroku master-with-secrets:master    # Push it to Heroku
$ git checkout master                           # Return to master
```

Then you'll need to rebase `master-with-secrets` from `master` next time you
want to deploy.
