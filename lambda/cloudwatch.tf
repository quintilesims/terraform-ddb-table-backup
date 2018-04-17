resource "aws_cloudwatch_event_rule" "every_day" {
    name = "every-day"
    description = "Fires every 24 hours"
    schedule_expression = "rate(24 hours)"
}

resource "aws_cloudwatch_event_target" "backup_every_day" {
    rule = "${aws_cloudwatch_event_rule.every_day.name}"
    target_id = "backup_ddb_table"
    arn = "${aws_lambda_function.backup_ddb_table.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_backup_ddb_table" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.backup_ddb_table.function_name}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.every_day.arn}"
}
