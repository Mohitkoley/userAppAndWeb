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

## Minimum Cart Points Rule

Current frontend rule:

```text
Minimum total cart point_value = 6500
```

The checkout button is disabled until:

```text
sum(product point_value * quantity) >= 6500
```

With default `500` points per product unit, the user needs at least:

```text
13 units * 500 = 6500
```

Backend should enforce the same rule on final order placement:

```text
POST /api/v1/customer/order/place
```

Recommended backend validation:

```text
Reject order if root point_value < 6500
Reject order if root point_value does not match cart item total
```

