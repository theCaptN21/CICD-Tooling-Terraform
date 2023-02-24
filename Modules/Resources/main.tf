# --- ecs.tf ---

resource "aws_ecs_cluster" "new_ecs_cluster" {
  name = "katorias-cluster"
}

resource "aws_ecs_task_definition" "new-task" {
  family                   = "service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = <<DEFINITION
  [
    {
       "name"         : "week23-centos",
       "image"        : "centos:latest",
       "cpu"          : 1024,
       "memory"       : 2048,
       "essential"    : true,
       "networkMode"  : "awsvpc",
       "portMappings" : [
         {
           "containerPort" : 80,
           "hostPort" : 80
         }
       ]
    }
  ]
  DEFINITION
}

resource "aws_ecs_service" "new-ecs-service" {
  name            = "week23-ecs"
  cluster         = aws_ecs_cluster.new_ecs_cluster.id
  task_definition = aws_ecs_task_definition.new-task.id
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.ecs_private_sg.id]
    subnets         = [aws_subnet.ecs_private.id]

  }
  
  lifecycle {
    ignore_changes = [task_definition]
  }
}

resource "aws_ecs_cluster_capacity_providers" "ecs_cluster" {
  cluster_name = aws_ecs_cluster.new_ecs_cluster.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE_SPOT"
  }
}


