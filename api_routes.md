# Point Value API Routes

This document lists every API route in the Flutter app flow that should return, accept, or preserve `point_value`.

Base URL:

```text
https://oleyshop.com/admin
```

## Default Behavior

Until the backend is fully ready, the app manually treats every product as:

```json
{
  "point_value": 500
}
```

When the backend starts sending `point_value`, every route below should use the same field name:

```text
point_value
```

Use an integer value.

## Product Routes

These routes must return `point_value` for every product object. They power product cards, product lists, category pages, search results, wishlist, flash deals, product details, cart creation, and reorder flows.

```text
GET /api/v1/products/all
GET /api/v1/products/featured
GET /api/v1/products/daily-needs
GET /api/v1/products/most-reviewed
GET /api/v1/products/details/{product_id}
GET /api/v1/categories/products/{category_id}
GET /api/v1/products/search
GET /api/v1/products/favorite
GET /api/v1/flash-deals
```

### Product List Response Shape

For list routes, include `point_value` inside every product in `products`.

```json
{
  "total_size": 10,
  "limit": 10,
  "offset": 1,
  "products": [
    {
      "id": 26,
      "name": "Saffron (Kesar)",
      "price": 2250,
      "point_value": 500
    }
  ]
}
```

### Product Details Response Shape

For product details, include `point_value` at the root of the product object.

```json
{
  "id": 26,
  "name": "Saffron (Kesar)",
  "price": 2250,
  "point_value": 500
}
```

## Order Details Routes

These routes should return `point_value` so order details, ordered product rows, and reorder flows can show or preserve the product point value.

```text
POST /api/v1/customer/order/details
```

Expected response item shape:

```json
[
  {
    "id": 101,
    "product_id": 26,
    "order_id": 5001,
    "quantity": 2,
    "price": 2250,
    "product_details": {
      "id": 26,
      "name": "Saffron (Kesar)",
      "point_value": 500
    }
  }
]
```

## Order Submit Routes

These routes receive `point_value` from the app.

```text
POST /api/v1/customer/order/place
POST /api/v1/customer/payment-mobile
```

### Final Order Placement

This is the most important route for storing and validating point value:

```text
POST /api/v1/customer/order/place
```

The app sends:

- root `point_value`: total cart point value
- each `cart[]` item `point_value`: point value for one unit of that product

Example:

```json
{
  "cart": [
    {
      "product_id": 26,
      "price": 2250,
      "discount_amount": 1750,
      "quantity": 2,
      "tax_amount": 0,
      "point_value": 500
    }
  ],
  "order_type": "delivery",
  "order_amount": 3500,
  "payment_method": "cash_on_delivery",
  "point_value": 1000
}
```

Backend should validate the total:

```text
root point_value = sum(cart item point_value * cart item quantity)
```

For the example above:

```text
1000 = 500 * 2
```

### Digital Payment Initialization

This route starts the digital payment flow:

```text
POST /api/v1/customer/payment-mobile
```

It receives the same order body shape as `/api/v1/customer/order/place`.

Backend should accept and preserve `point_value`, because after successful digital payment the app finalizes the order through:

```text
POST /api/v1/customer/order/place
```

## Cart Point Total

The app sends total cart points for order storage/accounting:

```text
root point_value = sum(product point_value * quantity)
```

There is no frontend minimum point-value rule at checkout. The checkout button should remain available for any cart total, and normal checkout validations still apply for address, delivery area, payment method, time slot, and delivery fee state.

Backend should continue validating that the root point total matches the cart item total on final order placement:

```text
POST /api/v1/customer/order/place
```

Recommended backend validation:

```text
Reject order if root point_value does not match cart item total
```

## Customer Membership Status

This route returns the user's membership progress:

```text
GET /api/v1/customer/member-status
```

Response fields:

```json
{
  "total_point_value": 0,
  "is_member": false,
  "next_milestone": 6500,
  "progress_percent": 0,
  "remaining_points": 6500
}
```

The app uses this route for membership progress and status. A user becomes a member after reaching:

```text
total_point_value >= next_milestone
```

The current `next_milestone` is `6500`. This value is only the membership threshold. It is not a checkout minimum, and checkout should not be blocked below 6500 points.

## Member Matrix Flow

These routes power the member network screen:

```text
GET /api/v1/customer/matrix/status
GET /api/v1/customer/matrix/team
GET /api/v1/customer/matrix/tree?depth=2
GET /api/v1/customer/matrix/incentive-history
GET /api/v1/customer/matrix/levels
POST /api/v1/customer/transfer-points
```

`POST /api/v1/customer/transfer-points` sends:

```json
{
  "to_user_id": 2,
  "amount": 100
}
```

The app refreshes profile/member status and the matrix dashboard after a successful transfer, because the receiver may become a member after crossing the `6500` point threshold.

Existing wallet and loyalty routes are already used by the wallet/loyalty flow:

```text
GET /api/v1/customer/wallet-transactions
GET /api/v1/customer/loyalty-point-transactions
POST /api/v1/customer/transfer-point-to-wallet
```
