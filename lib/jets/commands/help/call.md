Invoke the lambda function on AWS. The `jets call` command can do a few extra things for your convenience:

It adds the function namespace to the function name.  So, you pass in "posts_controller-index" and the Lambda function is "demo-dev-posts_controller-index".

It can print out the last 4KB of the lambda logs. The logging output is directed to stderr.  The response output from the lambda function itself is directed to stdout.  This is done so you can safely pipe the results of the call command to other tools like jq.

For controllers, the event you pass at the CLI is automatically transformed into Lambda Proxy payload that contains the params as the queryStringParameters.  For example:

  {"test":1}

Gets changed to:

{"queryStringParameters":{"test":1}}

This spares you from assembling the event payload manually to the payload that Jets controllers normally recieve.  If you would like to disable this Lambda Proxy transformation then use the `--no-lambda-proxy` flag.

For jobs, the event is passed through untouched.

Examples:

  jets call hard_job-drive '{"test":1}'
  jets call hard_job-drive '{"test":1}' | jq .
  jets call hard_job-drive file://event.json | jq . # load event with a file
  jets call posts_controller-index # event payload is optional
  jets call posts_controller-index '{"test":1}' --show-log | jq .
  jets call posts_controller-index 'file://event.json' --show-log | jq .

The equivalent AWS Lambda CLI command:

  aws lambda invoke --function-name demo-dev-hard_job-dig --payload '{"test":1}' outfile.txt
  cat outfile.txt | jq '.'

  aws lambda invoke --function-name demo-dev-posts_controller-index --payload '{"queryStringParameters":{"test":1}}' outfile.txt
  cat outfile.txt | jq '.'

For convenience, you can also provide the function name with only dashes and jets call will gets what function you intend to call. Examples:

  jets call posts-controller-index
  jets call admin-related-pages-controller-index

Are the same as:

  aws lambda invoke --function-name demo-dev-posts_controller-index
  aws lambda invoke --function-name demo-dev-admin/related_pages_controller-index

In order to allow calling functions with all dashes, the call method evaluates the app code and finds if the controller and method actually exists.  If you want to turn this off and want to always explicitly provide the method name use the `--no-guess` option.  The function name will then have to match the lambda function without the namespace. Example:

  jets call admin-related_pages_controller-index --no-guess

Local mode:

Instead of calling AWS lambda remote, you can also have `jets call` use the code directly on your machine.  To enable this use the `--local` flag. Example:

  jets call hard_job-drive --local
