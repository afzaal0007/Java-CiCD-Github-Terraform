resource "aws_iam_role" "eks_admin" {
  name               = "${var.cluster_name}-eks-admin"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.tags
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.trusted_entities
    }
  }
}

resource "aws_iam_role_policy_attachment" "eks_admin" {
  role       = aws_iam_role.eks_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_admin_worker" {
  role       = aws_iam_role.eks_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_admin_cni" {
  role       = aws_iam_role.eks_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_admin_ecr" {
  role       = aws_iam_role.eks_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}