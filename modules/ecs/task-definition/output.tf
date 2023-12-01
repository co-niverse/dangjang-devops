output "arn" {
  value = aws_ecs_task_definition.task.arn
}

output "arn_with_revision" {
  value = aws_ecs_task_definition.task.arn_without_revision
}