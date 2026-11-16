
-- African Indigenous Seeds
-- Migration 001: Initial database schema

-- 1. Users
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    phone VARCHAR(30) NOT NULL UNIQUE,
    email VARCHAR(255) UNIQUE,
    password_hash TEXT NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'buyer'
        CHECK (role IN ('buyer', 'admin')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. Membership applications
CREATE TABLE membership_applications (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL UNIQUE
        REFERENCES users(id) ON DELETE CASCADE,
    country VARCHAR(100) NOT NULL,
    region VARCHAR(100),
    community VARCHAR(150),
    member_type VARCHAR(30) NOT NULL
        CHECK (member_type IN (
            'farmer',
            'seed_saver',
            'seed_producer'
        )),
    seed_varieties TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'approved', 'rejected')),
    reviewed_by BIGINT REFERENCES users(id),
    reviewed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 3. Approved member profiles
CREATE TABLE member_profiles (
    user_id BIGINT PRIMARY KEY
        REFERENCES users(id) ON DELETE CASCADE,
    application_id BIGINT NOT NULL UNIQUE
        REFERENCES membership_applications(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 4. Indigenous seed listings
CREATE TABLE seed_listings (
    id BIGSERIAL PRIMARY KEY,
    member_id BIGINT NOT NULL
        REFERENCES member_profiles(user_id),
    seed_name VARCHAR(150) NOT NULL,
    category VARCHAR(30) NOT NULL
        CHECK (category IN (
            'vegetables',
            'cereals',
            'fruits',
            'trees'
        )),
    description TEXT,
    price NUMERIC(12, 2) NOT NULL CHECK (price >= 0),
    currency CHAR(3) NOT NULL,
    quantity NUMERIC(14, 3) NOT NULL CHECK (quantity >= 0),
    unit VARCHAR(40) NOT NULL,
    country VARCHAR(100) NOT NULL,
    region VARCHAR(100),
    community VARCHAR(150),
    photo_url TEXT,
    listing_status VARCHAR(20) NOT NULL DEFAULT 'active'
        CHECK (listing_status IN (
            'active',
            'sold_out',
            'inactive'
        )),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 5. Buyer orders
CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    listing_id BIGINT NOT NULL
        REFERENCES seed_listings(id),
    buyer_name VARCHAR(150) NOT NULL,
    buyer_phone VARCHAR(30) NOT NULL,
    buyer_country VARCHAR(100) NOT NULL,
    delivery_location VARCHAR(255) NOT NULL,
    quantity NUMERIC(14, 3) NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(12, 2) NOT NULL CHECK (unit_price >= 0),
    currency CHAR(3) NOT NULL,
    order_status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (order_status IN (
            'pending',
            'accepted',
            'rejected',
            'completed',
            'cancelled'
        )),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 6. Administrator activity logs
CREATE TABLE admin_logs (
    id BIGSERIAL PRIMARY KEY,
    admin_id BIGINT NOT NULL REFERENCES users(id),
    action VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for common searches
CREATE INDEX idx_membership_status
    ON membership_applications(status);

CREATE INDEX idx_seed_category
    ON seed_listings(category);

CREATE INDEX idx_seed_country
    ON seed_listings(country);

CREATE INDEX idx_seed_member
    ON seed_listings(member_id);

CREATE INDEX idx_orders_listing
    ON orders(listing_id);

CREATE INDEX idx_orders_status
    ON orders(order_status);

CREATE INDEX idx_admin_logs_admin
    ON admin_logs(admin_id);
