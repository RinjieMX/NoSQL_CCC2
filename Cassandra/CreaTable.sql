DROP TABLE restaurants;
DROP TABLE addresses;
DROP TABLE grades;

CREATE TABLE restaurants (
restaurant_id text PRIMARY KEY, 
name text, 
borough text, 
cuisine text
);
ALTER TABLE restaurants WITH GC_GRACE_SECONDS=0;

CREATE TABLE addresses (
    address_id text PRIMARY KEY,
    building text,
    street text,
    zipcode text,
    coord_type text,
    coord_X float,
    coord_Y float
);
ALTER TABLE addresses WITH GC_GRACE_SECONDS=0;

CREATE TABLE grades (
    restaurant_id text,
    date timestamp,
    grade text,
    score int,
    PRIMARY KEY (restaurant_id, date)
);
ALTER TABLE grades WITH GC_GRACE_SECONDS=0;
