### ELB
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
  target_type = "instance"
  vpc_id      = "${var.vpc_id}"

  health_check { # 상태 확인
    port                = 8080
    interval            = 60  # 주기 (sec)
    path                = "/api/intro" # ping 경로
    healthy_threshold   = 3   # 정상 간주 성공 횟수
    unhealthy_threshold = 3   # 비정상 간주 실패 횟수
  }

  tags = {
    Name = "tg-${var.env}"
  }
}

# ELB target group attachment
# resource "aws_alb_target_group_attachment" "default" {
#   target_group_arn = aws_alb_target_group.default.id # 어떤 그룹에 컨테이너 등록
#   target_id        = aws_ecs_service.fargate.id   # 어떤 컨테이너를 등록
# }

# ELB listener
resource "aws_alb_listener" "default" {
  load_balancer_arn = aws_lb.default.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"      # ssl 정책
  certificate_arn   = data.aws_acm_certificate.acm.arn #인증서

  default_action {
    type             = "forward" # 대상 그룹에 포워딩
    target_group_arn = aws_alb_target_group.default.arn
  }
}

data "aws_acm_certificate" "acm" {
  domain   = "${var.domain}"
  statuses = ["ISSUED"]
}

# ELB listener rule
# resource "aws_alb_listener_rule" "elb" {
#   listener_arn = aws_alb_listener.default.arn
#   action {
#     type = "redirect" # 리디렉션 작업

#     redirect {
#       port        = "443"
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }
#   condition {
#     path_pattern {
#       values = ["/**"]
#     }
#   }
# }
