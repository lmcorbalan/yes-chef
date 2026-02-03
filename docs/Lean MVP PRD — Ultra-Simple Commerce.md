# Lean MVP PRD — Ultra-Simple Commerce

## 1. Objective & Success Criteria

### Objective
Deliver a production-ready MVP for the **Retreat**, enabling buyers to purchase new electronics with extreme simplicity using **crypto payments on Ethereum**.

This MVP is a **learning tool**, not a production-grade marketplace.

### Success Criteria
- Buyer purchase flow completed in **≤ 4 clicks**
- Buyer can complete the flow without guidance
- Seller can list and delist products without friction
- Qualitative feedback collected on friction points

---

## 2. In Scope / Out of Scope

### In Scope
- Buyer-first experience
- Simple product catalog
- Product detail page
- Guest checkout
- Crypto payment (Ethereum only)
- Minimal order confirmation / status page
- Seller listing + delisting
- Telegram link-out messaging

### Out of Scope (Hard)
- Returns or refunds
- Used products
- International shipping
- Product variants
- Discounts or promotions
- Ratings or reviews
- In-app messaging
- Escrow
- Seller analytics or dashboards
- Multiple sellers per product
- Custom storefronts
- Moderation tools
- Buyer accounts or profiles

---

## 3. User Roles

### Buyer
- Can browse products without authentication
- Can purchase as a guest
- Can view minimal order status
- Can contact seller via Telegram

### Seller
- Registered user
- Defines an Ethereum wallet address
- Creates and delists product listings
- Views basic order information

---

## 4. Core User Flows

### 4.1 Buyer Flow (Happy Path)
1. Land on catalog
2. Select product
3. Review product details
4. Initiate crypto payment
5. Complete payment
6. View order confirmation / status

---

### 4.2 Seller Flow (Minimal)
1. Register account
2. Define Ethereum wallet address
3. Create product listing
4. Publish listing
5. Delist product
6. View incoming orders (basic list)

---

## 5. Functional Requirements

### 5.1 Buyer-Facing
- Browse catalog without authentication
- View product detail page with title, images, description, specs, price, shipping
- Initiate purchase with minimal steps
- Complete guest checkout

---

### 5.2 Seller-Facing
- Register as a seller
- Define Ethereum wallet address
- Create and delist product listings
- View basic order data

---

### 5.3 Payments & Orders
- Support crypto payments on **Ethereum only**
- Do not custody funds
- Detect payment confirmation
- Create order record post-confirmation
- Display minimal order status to buyer

---

### 5.4 Messaging
- Buyer can contact seller via Telegram link-out
- No in-app messaging
- No message history stored

---

## 6. Non-Functional Constraints

### Simplicity
- ≤ 4 clicks to purchase
- One payment method
- One shipping option

### Security
- No custody of crypto
- No private key handling

### Performance
- Pages load fast enough to not disrupt buying flow
- No advanced optimization required

---

## 7. Assumptions
- Buyers are willing to pay via crypto
- Sellers accept Telegram-based communication
- Trust comes from payment rail and transparency
- Fraud risk is acceptable for MVP

---

## 8. Risks
- Crypto UX friction
- Low trust without guarantees
- Electronics category expectations
- Scope creep toward full marketplace

---

## 9. Open Questions (Deferred)
- DeFi payment UX specifics
- Escrow via smart contracts
- Telegram messaging via intermediate system (bot vs direct)
- DeFi integration depth
- Payment confirmation UX
- Abuse and fraud handling
- Sufficiency of Telegram messaging
