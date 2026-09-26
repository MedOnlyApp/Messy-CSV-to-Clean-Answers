import pandas as pd
from sqlalchemy import create_engine



df_costumers = pd.read_csv('data/customers.csv')
df_orders = pd.read_csv('data/orders.csv')
df_products = pd.read_csv('data/products.csv')

engine = create_engine('postgresql://postgres:Medonly@localhost:5432/sales')

df_costumers.to_sql(
    name='costumers',
    con=engine,
    if_exists='replace',
    index=False
)
df_orders.to_sql(
    name='orders',
    con=engine,
    if_exists='replace',
    index=False
)
df_products.to_sql(
    name='products',
    con=engine,
    if_exists='replace',
    index=False
)