use portfolio;
select * from housing;
select UniqueID,SalePrice from housing;
select SaleDate from housing;


alter table housing
add salesdate date ;
SET SQL_SAFE_UPDATES = 0;
UPDATE housing
SET salesdate = STR_TO_DATE(SaleDate, '%M %e, %Y')
WHERE SaleDate IS NOT NULL;
SET SQL_SAFE_UPDATES = 1;
select salesdate from housing;

ALTER TABLE housing
DROP COLUMN SaleDate;



select * from housing 
order by ParcelID;

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress from 
housing a join housing b 
on b.ParcelID=a.ParcelID 
And a.UniqueID<>b.UniqueID
WHERE a.PropertyAddress = '';

UPDATE housing a
JOIN housing b
  ON a.ParcelID = b.ParcelID
 AND a.UniqueID <> b.UniqueID
SET b.PropertyAddress = a.PropertyAddress
WHERE a.PropertyAddress = '' ;




alter table housing 
add splitaddress varchar(255);

update housing 
set splitaddress = SUBSTRING(PropertyAddress, 1, INSTR(PropertyAddress, ',') - 1);

alter table housing 
add splitcity varchar(255);

update housing
set splitcity = SUBSTRING(PropertyAddress,  INSTR(PropertyAddress, ',') +1,length(PropertyAddress));

select OwnerAddress from housing;
alter table housing 
add ownerplace varchar(256);

update housing
set owneraddress=substring(OwnerAddress,1,instr(OwnerAddress, ',')-1);

select distinct(SoldAsVacant),count(SoldAsVacant) 
from housing 
group by SoldAsVacant
order by SoldAsVacant asc;


alter table housing
add sold varchar(256);
ALTER TABLE housing
DROP COLUMN sold;
update housing
set SoldAsVacant =
       CASE 
           WHEN SoldAsVacant = 'Y' THEN 'Yes'
           WHEN SoldAsVacant = 'N' THEN 'No'
           ELSE SoldAsVacant
            End;
            
WITH cte AS (
    SELECT UniqueId,
           ROW_NUMBER() OVER (
               PARTITION BY ParcelID, PropertyAddress, SalePrice, LegalReference
               ORDER BY UniqueId
           ) AS row_numbers
    FROM housing
)
DELETE h
FROM housing h
JOIN cte c ON h.UniqueId = c.UniqueId
WHERE c.row_numbers > 1;



            


