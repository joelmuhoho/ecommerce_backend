# AWS Infrastructure

The following diagram illustrates the proposed production infrastructure for hosting the E-Commerce Backend on Amazon Web Services (AWS).

```mermaid
graph TD
    Client((Client)) --> Route53[Route 53 DNS]
    
    Route53 -->|Static/Media| CloudFront[CloudFront CDN]
    CloudFront --> S3[S3 Bucket]
    
    Route53 -->|API Traffic| ALB[Application Load Balancer]
    
    subgraph VPC [AWS VPC]
        subgraph PublicSubnets [Public Subnets]
            ALB
            NAT[NAT Gateway]
        end
        
        subgraph PrivateSubnets [Private Subnets]
            ECS[ECS Fargate: Django App]
            RDS[(RDS PostgreSQL)]
        end
        
        ALB -->|HTTPS Proxy| ECS
        ECS -->|TCP:5432| RDS
        ECS -->|Outbound Internet| NAT
    end
```

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
