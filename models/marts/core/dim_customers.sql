with customers as (

    select * from {{ ref('stg_customers')}}

),

orders as (

    select *
    from {{ ref('stg_orders') }}

),

payments as (

    select
        customer_id,
        sum(pay.amount) as lifetime_value
    from
        customers as cust
        join orders as ord using (customer_id)
        join {{ ref('stg_payments') }} as pay using (order_id)
    group by cust.customer_id

),

customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders

    from orders

    group by 1

),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        coalesce(payments.lifetime_value, 0) as lifetime_value

    from customers

    left join customer_orders using (customer_id)

    left join payments using (customer_id)

)

select * from final