# AWS Infrastructure

The following diagram illustrates the proposed production infrastructure for hosting the E-Commerce Backend on Amazon Web Services (AWS).

```mermaid
architecture-beta
    group aws(logos:aws)[AWS Cloud]
    group vpc(logos:aws-vpc)[VPC] in aws
    group public_subnets(logos:aws-vpc)[Public Subnets] in vpc
    group private_subnets(logos:aws-vpc)[Private Subnets] in vpc

    service route53(logos:aws-route-53)[Route 53] in aws
    service cloudfront(logos:aws-cloudfront)[CloudFront] in aws
    service s3(logos:aws-s3)[S3 Bucket (Static/Media)] in aws
    
    service alb(logos:aws-elastic-load-balancing)[Application Load Balancer] in public_subnets
    service nat(logos:aws-nat-gateway)[NAT Gateway] in public_subnets

    service ecs(logos:aws-ecs)[ECS Fargate (Django App)] in private_subnets
    service rds(logos:aws-rds)[RDS PostgreSQL] in private_subnets
    
    route53:R -- L:cloudfront
    cloudfront:R -- L:s3
    route53:R -- L:alb
    alb:R -- L:ecs
    ecs:R -- L:rds
    ecs:R -- L:nat
```

> [!NOTE]
> We are using the experimental `architecture-beta` Mermaid diagram type here to visualize cloud infrastructure.

## Component Overview

1.  **Route 53**: DNS management, routing traffic to either CloudFront (for static assets) or the Application Load Balancer (for API requests).
2.  **CloudFront & S3**: Used to serve Django static files (CSS, JS, images) and user-uploaded media files efficiently via a CDN.
3.  **Application Load Balancer (ALB)**: Distributes incoming API traffic across multiple ECS tasks (containers). Handles SSL/TLS termination.
4.  **ECS (Elastic Container Service) with Fargate**: Serverless compute engine for containers. Runs the Dockerized Django application. Automatically scales based on traffic.
5.  **RDS (Relational Database Service)**: Managed PostgreSQL database instance, placed in a private subnet for security. Configured for high availability (Multi-AZ) and automated backups.
6.  **NAT Gateway**: Allows ECS tasks in the private subnet to access the internet (e.g., to download updates or interact with external third-party APIs) without being exposed to incoming internet traffic.

## Security Considerations

*   **Network Isolation**: The core application (ECS) and database (RDS) reside in private subnets and are inaccessible directly from the internet.
*   **Minimal Exposure**: Only the Load Balancer and CloudFront distribution are exposed publicly.
*   **Encryption**: Traffic is encrypted in transit via HTTPS/SSL at the ALB and CloudFront level. Data at rest is encrypted in RDS and S3.
