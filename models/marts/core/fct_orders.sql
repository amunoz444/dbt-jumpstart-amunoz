select
    ord.order_id,
    ord.customer_id,
    pay.amount
from
    stg_orders ord
    join stg_payments pay
        on pay.order_id = ord.order_id
