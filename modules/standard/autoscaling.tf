################################################################################
# Storage Autoscaling
################################################################################

resource "aws_appautoscaling_target" "this" {
  count = var.storage_autoscaling_config.enabled ? 1 : 0

  max_capacity       = var.storage_autoscaling_config.max_capacity
  min_capacity       = 1
  role_arn           = var.storage_autoscaling_config.role_arn != "" ? var.storage_autoscaling_config.role_arn : null
  resource_id        = aws_msk_cluster.this.arn
  scalable_dimension = "kafka:broker-storage:VolumeSize"
  service_namespace  = "kafka"

  tags = var.tags
}

resource "aws_appautoscaling_policy" "this" {
  count = var.storage_autoscaling_config.enabled ? 1 : 0

  name               = "${var.cluster_name}-broker-storage-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_msk_cluster.this.arn
  scalable_dimension = aws_appautoscaling_target.this[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.this[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "KafkaBrokerStorageUtilization"
    }

    target_value = var.storage_autoscaling_config.target_value
  }
}
