### OIDC Provider
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://${var.github_token_domain}"

  client_id_list = [
    "sigstore",
  ]

  # ref: https://github.com/aws-actions/configure-aws-credentials/tree/v1.6.0#sample-iam-role-cloudformation-template
  thumbprint_list = [
    "a031c46782e6e6c662c2c87c76da9aa62ccabd8e",
  ]
}

### IAM Role
resource "aws_iam_role" "aws-action" {
  name               = "iamrole-aws-action"
  assume_role_policy = data.aws_iam_policy_document.aws-action.json
}

data "aws_iam_policy_document" "aws-action" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    principals {
      type = "Federated"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${var.github_token_domain}",
      ]
    }

    effect = "Allow"

    condition {
      test     = "StringLike"
      variable = "${var.github_token_domain}:sub"

      values = [
        "repo:${var.github_organization_name}/${var.github_repo_name}:*"
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "readonly-access" {
  role       = aws_iam_role.aws-action.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}