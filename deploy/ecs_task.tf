resource "aws_ecs_task_definition" "web_app" {
  family                   = "web_app"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn #"arn:aws:iam::743794601996:role/ecsTaskExecutionRole"
  task_role_arn            = aws_iam_role.ecs_task_role.arn #"arn:aws:iam::743794601996:role/ecsTaskExecutionRole"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "3072"
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = "first"
      image     = "743794601996.dkr.ecr.us-east-2.amazonaws.com/app-one:feb-13-9-35"
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      "environment" : jsondecode(local.container_env_variables)
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.app5.name
          awslogs-region        = "us-east-2"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}
