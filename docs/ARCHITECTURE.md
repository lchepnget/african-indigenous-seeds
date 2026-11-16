# African Indigenous Seeds — System Architecture

## 1. Introduction

This document describes the technical architecture of the African Indigenous Seeds platform.

The system uses a Go backend, a web frontend and a PostgreSQL database.

## 2. Architecture Overview

The application has four main layers:

1. Presentation Layer — HTML, CSS and JavaScript.
2. Application Layer — Go HTTP handlers.
3. Security Layer — Authentication and authorization middleware.
4. Data Layer — PostgreSQL database.

## 3. Project Components

### Frontend

Location: `static/`

Responsibilities:
- Display the public website.
- Provide membership registration and login pages.
- Display the seed marketplace.
- Allow buyers to submit order requests.
- Provide member and administrator dashboards.

### Backend

Location: `handlers/`

Responsibilities:
- Process registration requests.
- Authenticate members and administrators.
- Manage membership applications.
- Manage seed listings.
- Process buyer orders.
- Manage notifications.

### Middleware

Location: `middleware/`

Responsibilities:
- Verify administrator sessions.
- Verify member sessions.
- Protect private API routes.
- Enforce access permissions.

### Database

Location: `database/` and `migrations/`

Responsibilities:
- Establish database connections.
- Store member information.
- Store membership applications.
- Store indigenous seed listings.
- Store orders and notifications.

### Models

Location: `models/`

Responsibilities:
- Define application data structures.
- Represent members, seeds, orders and notifications.
- Support communication between handlers and the database.

## 4. Main User Workflows

### Membership Workflow

1. A person submits a membership application.
2. The application is saved with pending status.
3. An administrator reviews the application.
4. The administrator approves or rejects it.
5. Approved members receive seller access.

### Seed Marketplace Workflow

1. An approved member signs in.
2. The member creates an indigenous seed listing.
3. The backend verifies membership approval.
4. The listing becomes available in the public marketplace.
5. Buyers can browse and request seeds.

### Order Workflow

1. A buyer submits an order request.
2. The system records the request as pending.
3. The seller reviews the request.
4. The seller accepts or declines it.
5. The buyer can check the order status.

## 5. Security Principles

- Passwords must be securely hashed.
- Authentication sessions must be protected.
- Only administrators can approve membership applications.
- Only approved members can publish seed listings.
- Sellers can only manage orders belonging to their own listings.
- User input must be validated by the backend.
- Sensitive information must not be exposed unnecessarily.

## 6. Database Technology

The platform uses PostgreSQL for persistent data storage.

Database changes will be managed through SQL migration files.

## 7. Future Improvements

- Email notifications.
- WhatsApp notifications.
- Secure seed photograph uploads.
- Advanced marketplace search.
- Improved order tracking.
- Country-specific seed trade compliance information.

## 8. Development Status

This architecture is the initial development design. It will be updated as the application is implemented and tested.