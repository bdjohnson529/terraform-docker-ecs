### ECR

resource "aws_ecr_repository" "my_first_ecr_repo" {
  name                 = "my-first-ecr-repo"
  image_tag_mutability = "IMMUTABLE"
}


### ECS

resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster" # Naming the cluster
}


resource "aws_ecs_task_definition" "my_first_task" {
  family = "my-first-task"
  container_definitions = jsonencode([
    {
      name      = "my-first-task"
      image     = aws_ecr_repository.my_first_ecr_repo.repository_url
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 512
  cpu                      = 256
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
}


resource "aws_ecs_service" "my_first_service" {
  name            = "my-first-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_first_task.arn
  launch_type     = "FARGATE"
  desired_count   = 3

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = aws_ecs_task_definition.my_first_task.family
    container_port   = 3000
  }

  network_configuration {
    subnets          = [aws_default_subnet.default_a.id, aws_default_subnet.default_b.id, aws_default_subnet.default_c.id]
    assign_public_ip = true
  }

}


