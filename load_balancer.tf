resource "aws_lb" "application_load_balancer" {
  name               = "test-lb-tf"
  load_balancer_type = "application"
  subnets = [
    aws_default_subnet.default_a.id,
    aws_default_subnet.default_b.id,
    aws_default_subnet.default_c.id
  ]

  security_groups = [aws_security_group.load_balancer_security_group.id]
}


resource "aws_lb_target_group" "target_group" {
  name        = "target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_default_vpc.default_vpc.id
  health_check {
    matcher = "200,301,302"
    path    = "/"
  }
}


resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}
