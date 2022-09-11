resource "aws_flow_log" "this" {
  count = var.enable_flow_log ? 1 : 0

  log_destination      = "arn:aws:s3:::${var.flow_log_bucket}/${var.name}/"
  log_destination_type = "s3"
  traffic_type         = "ALL"
  log_format           = "$${version} $${account-id} $${interface-id} $${pkt-srcaddr} $${pkt-dstaddr} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${protocol} $${pkt-src-aws-service} $${pkt-dst-aws-service} $${flow-direction} $${packets} $${bytes} $${start} $${end} $${action} $${log-status}"
  vpc_id               = aws_vpc.this.id
}
