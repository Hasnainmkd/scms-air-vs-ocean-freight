-- SCMS Air vs Ocean Freight Analysis
-- SQL queries run in DB Browser for SQLite on the cleaned SCMS data.
-- Scope throughout: ARV product group, usable rows (valid weight + freight).


-- Setup check: list tables in the database
SELECT name FROM sqlite_master WHERE type='table';


-- Quick look at the cost per kg column
SELECT "Shipment Mode", "cost_per_kg"
FROM SCMS_Delivery_History_Dataset_new_one
LIMIT 10;


-- H1: Average cost per kg, air vs ocean (the air premium)
SELECT "Shipment Mode", Count(*) as shipments, avg(cast(cost_per_kg as REAL)) AS avg_cost_per_kg
FROM SCMS_Delivery_History_Dataset_new_one
WHERE "Product Group" = 'ARV'
AND "Shipment Mode" in ('Air', 'Ocean')
AND usable = 'Yes'
GROUP by "Shipment mode";


-- H2: Air shipments by weight band (how much air went to heavy loads)
SELECT weight_bands, Count(*) as Shipments
FROM SCMS_Delivery_History_Dataset_new_one
WHERE "Product Group" = 'ARV'
AND "Shipment Mode" = 'Air'
AND usable = 'Yes'
GROUP by "weight_bands";


-- H3: Count of air shipments where freight cost more than the cargo was worth
SELECT count(*) as high_ratio_shipments
FROM SCMS_Delivery_History_Dataset_new_one
WHERE "Product Group" = 'ARV'
AND "Shipment mode" = 'Air'
AND usable = 'Yes'
AND CAST(freight_clean as REAL) / CAST("line item value" as real) > 1;


-- H4: Late shipments by mode (did air actually arrive on time)
SELECT "Shipment mode", count(*) as late_count
FROM SCMS_Delivery_History_Dataset_new_one
WHERE "Product Group" = 'ARV'
AND "Shipment mode" in ('Air', 'Ocean')
AND usable = 'Yes'
AND CAST(delays as REAL) > 0
GROUP by "Shipment mode";


-- H5 part 1: Total freight paid and total weight for heavy air shipments
SELECT sum(cast(freight_clean as REAL)) as total_air_freight, sum(cast(weight_clean as real)) as total_weight
FROM SCMS_Delivery_History_Dataset_new_one
WHERE "Product Group" = 'ARV'
AND "Shipment mode" = 'Air'
AND usable = 'Yes'
AND weight_bands = 'Heavy';


-- H5 part 2: Total freight and weight for heavy ocean shipments (to get ocean's heavy-band rate)
SELECT sum(cast(freight_clean as REAL)) as total_ocean_freight, sum(cast(weight_clean as REAL)) as total_ocean_weight
FROM SCMS_Delivery_History_Dataset_new_one
WHERE "Product Group" = 'ARV'
AND "Shipment mode" = 'Ocean'
AND usable = 'Yes'
AND weight_bands = 'Heavy';

-- Savings estimate: heavy air freight paid minus (heavy air weight x ocean heavy rate of ~2.09)
-- 17,031,934 - (3,561,139 x 2.09) = about 9.6M
