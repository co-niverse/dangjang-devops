###################
#       ELB       #
###################

resource "aws_lb" "default" {
  name               = "elb-${var.env}"
  internal           = false
  load_balancer_type = "application" # ALB
  security_groups    = ["${var.default_sg}"]
  subnets            = var.public_subnets

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "elb-${var.env}"
  }
}

# ELB target group
resource "aws_alb_target_group" "default" {
  name        = "tg-${var.env}"
  port        = 8080 # 대상이 수신하는 포트
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check { # 상태 확인
    port                = 8080
    interval            = 300            # 주기 (sec)
    path                = "/healthcheck" # ping 경로
    matcher             = "404"          # 상태 확인 성공 코드
    healthy_threshold   = 2              # 정상 간주 성공 횟수
    unhealthy_threshold = 2              # 비정상 간주 실패 횟수
  }

  tags = {
    Name = "tg-${var.env}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ELB listener
resource "aws_alb_listener" "default" {
  load_balancer_arn = aws_lb.default.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06" # ssl 정책
  certificate_arn   = data.aws_acm_certificate.acm.arn      #인증서

  default_action {
    type             = "forward" # 대상 그룹에 포워딩
    target_group_arn = aws_alb_target_group.default.arn
  }
}

data "aws_acm_certificate" "acm" {
  domain   = var.domain
  statuses = ["ISSUED"]
}
