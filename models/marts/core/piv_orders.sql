{%- set methods = ['credit_card', 'coupon', 'bank_transfer', 'gfit_card'] -%}

select
  order_id,
  {% for method in methods -%}
  sum(case when payment_method = '{{ method }}' then amount else 0 end) as {{ method }}_amount,
  sum(case when payment_method = '{{ method }}' then {{ cents_to_dollars('amount') }} else 0 end) as {{ method }}_amount_dol
  {%- if not loop.last %},
  {% endif %}{% endfor %}
from {{ ref('stg_payments') }}
where lower(status) = 'success'
group by order_id