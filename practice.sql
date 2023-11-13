/* create,select practice */
use sql_demo;
drop table products;
create table products(
id int(11) not null,
name varchar(255) not null,
description varchar(255) not null,
price double not null,
primary key (id)
);
insert into products values 
(1,"A","good",100),
(2,"B","bad",200),
(3,"C","perfect",400),
(4,"D","good",500),
(5,"E","fantastic",300);
describe products;
show keys from products where key_name='primary';

create view productsview as
select id,price
from products
where price > 100;

explain analyze select * from productsview;

create or replace view productsview as
select id,price,description
from products
where price <= 300;

select * from products order by id asc;

select * from products limit 2 offset 1;

select id,description from products 
where description like 'g%';

select description,sum(price) from products
group by description;

select id,description,sum(price) from products
group by id,description;

select count(*) from products
where price > 200;

select sum(price) from products;
select avg(price) from products;

create table products_source(
id int(11) not null primary key,
name varchar(255) not null,
nation varchar(255) not null,
expiry date not null
);
insert into products_source values
(1,"A","China","2023-11-13"),
(2,"B","VietNam","2023-11-14"),
(3,"C","China","2023-11-13"),
(4,"D","Thailand","2023-11-11"),
(5,"E","Laos","2023-11-12");

insert into products_source values
(6,"F","Korea","2023-11-14"),
(7,"H","VietNam","2023-11-15");

select * from products_source;

/* subquery,join practice */
select id,name,description from products
where id in
(select id from products_source where nation='China');

select products.id,products.name,nation,price,expiry 
from products
inner join products_source
on products.id=products_source.id;

select products_source.id,products.name,nation,price,expiry
from products_source
left join products on products_source.id=products.id;

update products set price=800 where id=1;
select * from products;

delete from products_source where id=6;
select * from products_source;

/* transaction practice */

start transaction;
insert into products(id,name,description,price) values (6,"J","very good",600);
commit;

set sql_safe_updates = 0;
start transaction;
delete from products where id=6;
savepoint sp1;
delete from products where price=300;
rollback to savepoint sp1;
commit;

select * from products;