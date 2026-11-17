SELECT name FROM sqlite_master WHERE type='table';

SELECT cost_per_kg from SCMS_Delivery_History_Dataset_new_one LIMIT 5;

SELECT "Shipment Mode", "cost_per_kg" from SCMS_Delivery_History_Dataset_new_one LIMIT 10;

SELECT "Shipment Mode", "cost_per_kg"
FROM SCMS_Delivery_History_Dataset_new_one
WHERE "Product Group" = 'ARV'
AND "Shipment Mode" IN ('Air', 'Ocean')
AND usable = 'Yes'
LIMIT 10; 

SELECT "Shipment Mode", count(*) as shipments
from SCMS_Delivery_History_Dataset_new_one
group by "Shipment Mode";


SELECT "Shipment Mode", Count(*) as shipments, avg(cast(cost_per_kg as REAL)) AS avg_cost_per_kg
from SCMS_Delivery_History_Dataset_new_one
WHERE "Product Group" = 'ARV'
and "Shipment Mode" in ('Air', 'Ocean')
and usable = 'Yes'
GROUP by "Shipment mode";

SELECT weight_bands, Count(*) as Shipments
from SCMS_Delivery_History_Dataset_new_one
WHERE "Product Group" = 'ARV'
and "Shipment Mode" = 'Air'
and usable = 'Yes'
GROUP by "weight_bands";

SELECT weight_bands, "Line Item Value", freight_clean, CAST(freight_clean as REAL) / CAST("Line item value" as REAL) as freight_to_value
FROM SCMS_Delivery_History_Dataset_new_one
WHERE "Product GROUP" = 'ARV'
AND "Shipment Mode" = 'Air'
and usable = 'Yes'
and "line item value" != '0'
LIMIT 20;


SELECT count(*) as high_ratio_shipments
from SCMS_Delivery_History_Dataset_new_one
WHERE "Product GROUP" = 'ARV'
and "Shipment mode" = 'Air'
and usable = 'Yes'
and CAST(freight_clean as REAL) / CAST("line item value" as real) > 1;

SELECT count(*) as late_shipments
from SCMS_Delivery_History_Dataset_new_one
WHERE "Product GROUP" = 'ARV'
AND usable = 'Yes'
and "Shipment mode" = 'Air'
and CAST(delays as REAL) > 0;

SELECT "Shipment mode", count(*) as late_count
from SCMS_Delivery_History_Dataset_new_one
WHERE "Product GROUP" = 'ARV'
AND "Shipment mode" in('Air', 'Ocean')
and usable = 'Yes'
AND CAST(delays as REAL) > 0
GROUP by "Shipment mode";

SELECT sum(cast(freight_clean as REAL)) as total_air_fleight, sum(cast(weight_clean as real)) as total_weight 
from SCMS_Delivery_History_Dataset_new_one
WHERE "Product GROUP" = 'ARV'
and "Shipment mode" = 'Air'
and usable = 'Yes'
and weight_bands = 'Heavy';

SELECT sum(cast(freight_clean as REAL)) as total_ocean_fleight, sum(cast(weight_clean as REAL)) as total_ocean_weight
from SCMS_Delivery_History_Dataset_new_one
WHERE "Product GROUP" = 'ARV'
AND usable = 'Yes'
and "Shipment mode" = 'Ocean'
and weight_bands = 'Heavy';
