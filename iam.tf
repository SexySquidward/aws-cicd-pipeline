resource "aws_iam_role" "tf-codebuild-role" {
  name = "tf-codebuild-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })

 
}
resource "aws_iam_role" "tf-codepipeline-role" {
  name = "tf-codepipeline-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      },
    ]
  })

 
}
data "aws_iam_policy_document" "tf-cicd-pipeline-policies" {
    statement {
    sid = ""
    actions = [ "codestar-connections:UseConnection"]
    resources = [ "*" ]
    effect = "Allow"
  }
  statement {
    sid = ""
    actions = [ "cloudwatch:*", "s3:*", "codebuild:*"]
    resources = [ "*" ]
    effect = "Allow"
  }
}
data "aws_iam_policy_document" "tf-cicd-build-policies" {
    statement {
    sid = ""
    actions = [ "logs:*","s3:*","codebuild:*","secretsmanager:*","iam:*"]
    resources = [ "*" ]
    effect = "Allow"
  }
 
}

resource "aws_iam_policy" "tf-cicd-pipeline-policy" {
  name = "tf-cicd-pipeline-policy"
  path = "/"
  description = "Pipeline policy"
  policy = data.aws_iam_policy_document.tf-cicd-pipeline-policies.json
}

resource "aws_iam_policy" "tf-cicd-build-policy" {
  name = "tf-cicd-build-policy"
  path = "/"
  description = "Build policy"
  policy = data.aws_iam_policy_document.tf-cicd-build-policies.json
}


resource "aws_iam_policy_attachment" "tf-cicd-pipeline-attachment" {
  name = "tf-codepipeline-role-policy"
  policy_arn = aws_iam_policy.tf-cicd-pipeline-policy.arn
  roles = [ aws_iam_role.tf-codepipeline-role.id ]
}
resource "aws_iam_policy_attachment" "tf-cicd-pipeline-attachment1" {
  name = "tf-codebuild-role-policy"
  policy_arn = aws_iam_policy.tf-cicd-build-policy.arn
  roles = [ aws_iam_role.tf-codebuild-role.id ]
}
