# Database Relationships

This Entity-Relationship Diagram (ERD) outlines the core database models and their relationships in the E-Commerce Backend.

```mermaid
erDiagram
    USER ||--o{ ORDER : places
    USER {
        uuid id PK
        string email UK
        string password
        string first_name
        string last_name
        boolean is_active
        boolean is_staff
        datetime date_joined
    }

    CATEGORY ||--o{ PRODUCT : contains
    CATEGORY {
        uuid id PK
        string name
        string description
        datetime created_at
        datetime updated_at
    }

    PRODUCT {
        uuid id PK
        uuid category_id FK
        string name
        string description
        decimal price
        datetime created_at
        datetime updated_at
    }
    
    ORDER ||--|{ ORDER_ITEM : contains
    ORDER {
        uuid id PK
        uuid user_id FK
        decimal total_amount
        string status
        datetime created_at
        datetime updated_at
    }
    
    ORDER_ITEM {
        uuid id PK
        uuid order_id FK
        uuid product_id FK
        integer quantity
        decimal price_at_purchase
    }
    
    PRODUCT ||--o{ ORDER_ITEM : "ordered in"
```

> [!NOTE]
> The `Order` and `Order Item` models represent the upcoming Phase 2 implementation for order management. Currently, the system implements `User`, `Category`, and `Product`.

## Key Entities

*   **User**: Represents an authenticated user of the system (customers and admins). Uses an email-based authentication approach.
*   **Category**: A hierarchical grouping for products to allow easy navigation and filtering.
*   **Product**: The core entity representing an item available for purchase. Belongs to a single `Category`.
