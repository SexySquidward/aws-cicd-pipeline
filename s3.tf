


resource "aws_s3_bucket" "codepipeline_artifacts" {
  bucket = "pipeline-artifacts-13454234"
  acl = "private"
  
}