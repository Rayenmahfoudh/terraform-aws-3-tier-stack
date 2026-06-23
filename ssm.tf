resource "aws_ssm_parameter" "db" {
  name      = "/DATABASE_URL"
  type      = "String"
  tier      = "Standard"
  data_type = "text"
  value     = aws_db_instance.main.address

}

resource "aws_ssm_parameter" "cmo" {
  name      = "/CMO_NAME"
  type      = "String"
  tier      = "Standard"
  data_type = "text"
  value     = "Dr. Stangelove"
}

