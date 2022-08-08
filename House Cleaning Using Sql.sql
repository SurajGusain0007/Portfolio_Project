
-- 1. Read the dataset

Select * from Clean_House;

-- 2.Standarized format

Select CONVERT(Date,SaleDate) as Sale_DateConverted
From Clean_House


Update Clean_House
SET Sale_DateConverted = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE Clean_House
Add Sale_DateConverted Date;

Update Clean_House
SET Sale_DateConverted = CONVERT(Date,SaleDate)


-- 3 Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From Clean_House
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address

From Clean_House


ALTER TABLE Clean_House
Add PropertySplitAddress Nvarchar(255);

Update Clean_House
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE Clean_House
Add PropertySplitCity Nvarchar(255);

Update Clean_House
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))



--4 Breaking out OwnerAddress into Individual Columns



Select OwnerAddress
From Clean_House


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From Clean_House



ALTER TABLE Clean_House
Add OwnerSplitAddress Nvarchar(255);

Update Clean_House
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Clean_House
Add OwnerSplitCity Nvarchar(255);

Update Clean_House
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE Clean_House
Add OwnerSplitState Nvarchar(255);

Update Clean_House
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


--5 Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Clean_House
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From Clean_House

Update Clean_House
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

--6 -- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) as row_num

From Clean_House
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

-- 7.-- Populate Property Address data

Select *
From  Clean_House
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From Clean_House a
JOIN  Clean_House b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From  Clean_House a
JOIN  Clean_House b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


-- 8 Fill null values with zeroes and averages
UPDATE Clean_House
SET Acreage=0
WHERE Acreage IS NULL;


UPDATE Clean_House
SET LandValue=0
WHERE LandValue IS NULL;


UPDATE Clean_House
SET Bedrooms=0
WHERE Bedrooms IS NULL;


UPDATE Clean_House
SET Acreage=0
WHERE Acreage IS NULL;


select avg(BuildingValue) as Building_Value from Clean_House;


UPDATE Clean_House
SET BuildingValue=160784
WHERE BuildingValue IS NULL;

UPDATE Clean_House
SET FullBath=0
WHERE FullBath IS NULL;

UPDATE Clean_House
SET HalfBath=0
WHERE HalfBath IS NULL;
