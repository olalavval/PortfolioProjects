SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [PortfolioProject].[dbo].[NashVilleHousing]


  select *

  from PortfolioProject..nashvillehousing

  --- standardized the sales date

    select saledateconverted, convert(date, saledate)

  from PortfolioProject..nashvillehousing

  UPDATE nashvillehousing

  SET saledate = convert(date, saledate)

  ALTER Table nashvillehousing

  ADD saledateconverted date;

   UPDATE nashvillehousing

  SET saledateconverted = convert(date, saledate)

  ---populate property address

   select *

  from PortfolioProject..nashvillehousing

  where propertyaddress is null

  order by parcelID

   select a.parcelID, a.propertyaddress, b.parcelID, b.propertyaddress, isnull (a.propertyaddress,b.propertyaddress)

  from PortfolioProject..nashvillehousing a
  join 
  PortfolioProject..nashvillehousing b
  on 
  a.parcelID= b.parcelID
  AND a.uniqueID <> b.uniqueID
  where a.propertyaddress is null

  update a

  SET propertyaddress = isnull (a.propertyaddress,b.propertyaddress)

   from PortfolioProject..nashvillehousing a
  join 
  PortfolioProject..nashvillehousing b
  on 
  a.parcelID= b.parcelID
  AND a.uniqueID <> b.uniqueID
  where a.propertyaddress is null


  ---Breaking addres into individual column (address, city, state)
  select propertyaddress

from PortfolioProject..nashvillehousing

-where propertyaddress is null

select 
substring (propertyaddress,1, charindex(',',propertyaddress)-1) as address,
substring (propertyaddress, charindex(',',propertyaddress)+1,len(propertyaddress))as address

from PortfolioProject..nashvillehousing

 ALTER Table nashvillehousing

  ADD propertysplitaddress nvarchar(255);

   UPDATE nashvillehousing

  SET propertysplitaddress = substring (propertyaddress,1, charindex(',',propertyaddress)-1) 

   ALTER Table nashvillehousing

  ADD propertysplitcity nvarchar(255);

   UPDATE nashvillehousing

  SET propertysplitcity = substring (propertyaddress, charindex(',',propertyaddress)+1,len(propertyaddress))

  select * 

from PortfolioProject..nashvillehousing







  select owneraddress

from PortfolioProject..nashvillehousing

select
parsename(replace(owneraddress, ',','.'),3 )
,parsename(replace(owneraddress, ',','.'),2 )
,parsename(replace(owneraddress, ',','.'),1)

from PortfolioProject..nashvillehousing

 ALTER Table nashvillehousing

  ADD ownersplitaddress nvarchar(255);

   UPDATE nashvillehousing

  SET ownersplitaddress = parsename(replace(owneraddress, ',','.'),3 )

 ALTER Table nashvillehousing

  ADD ownersplitcity nvarchar(255);

   UPDATE nashvillehousing

  SET ownersplitcity = parsename(replace(owneraddress, ',','.'),2)

  ALTER Table nashvillehousing

  ADD ownersplitstate nvarchar(255);

   UPDATE nashvillehousing

  SET ownersplitstate = parsename(replace(owneraddress, ',','.'),1 )

  select *

  from nashvillehousing


  ---change the Y and N in soldasvacant to Yes and No
  select distinct(soldasvacant), count(soldasvacant)

  from PortfolioProject..nashvillehousing

  group by soldasvacant
  order by 2;

  select soldasvacant
  , CASE WHEN soldasvacant = 'Y' THEN 'YES'
     WHEN soldasvacant = 'N' THEN 'NO'
	ELSE soldasvacant
	END
  from PortfolioProject..nashvillehousing

  update nashvillehousing
  
  SET soldasvacant = CASE WHEN soldasvacant = 'Y' THEN 'YES'
     WHEN soldasvacant = 'N' THEN 'NO'
	ELSE soldasvacant
	END

	---Remove Duplicates
	
	WITH RownumCTE as (
	select *,
	ROW_NUMBER() OVER (
	PARTITION BY parcelID,
	             propertyaddress,
				 saleprice,
				 saledate,
				 legalreference
				 ORDER BY
				 UniqueID) as row_num

	from PortfolioProject..nashvillehousing
	)
	select *
	from RownumCTE
	where row_num > 1
	
	---DELETE UNUSED COLUMN
	select *

	from PortfolioProject..nashvillehousing


	alter table PortfolioProject..nashvillehousing

	drop column owneraddress, taxdistrict, propertyaddress

	alter table PortfolioProject..nashvillehousing

	drop column saledate