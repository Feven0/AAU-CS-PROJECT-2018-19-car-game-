/*Cleaning data from sql queries*/

Select*
from Projects..NashvilleHousing$

/*Standardize date format*/

Alter Table NashvilleHousing$
Add SaleDateConverted Date
Update NashvilleHousing$
Set SaleDateConverted = CONVERT(Date, SaleDate)
Select SaleDateConverted
From Projects..NashvilleHousing$   ---remove SaleDate

/*Populate property Address data*/
Select *
from Projects.dbo.NashvilleHousing$
order by ParcelID

Select a.ParcelId, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From Projects..NashvilleHousing$ a
Join Projects..NashvilleHousing$ b
	on a.ParcelID= b.ParcelID
	AND a.[uniqueID]<>b.[uniqueID]
Where a.propertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.propertyAddress,b.propertyAddress)
From Projects..NashvilleHousing$ a
Join Projects..NashvilleHousing$ b
	on a.ParcelID=b.ParcelID
	AND a.[uniqueID]<>b.[uniqueID]
Where a.propertyAddress is null


/*Breaking Address column into individual coulmns(Address, City, State)*/
Select *
from Projects.dbo.NashvilleHousing$

Select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address
From Projects.dbo.NashvilleHousing$

Alter Table Projects.dbo.NashvilleHousing$
Add PropertySplitAddress Nvarchar(255);
Update Projects.dbo.NashvilleHousing$
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter table Projects.dbo.NashvilleHousing$
Add PropertySplitCity Nvarchar(255);
Update Projects.dbo.NashvilleHousing$
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

Select*
From Projects.dbo.NashvilleHousing$

Select OwnerAddress
From Projects.dbo.NashvilleHousing$

Select 
PARSENAME(REPLACE(OwnerAddress, ',','.'),3),
PARSENAME(REPLACE(OwnerAddress, ',','.'),2),
PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
From Projects.dbo.NashvilleHousing$

Alter Table Projects.dbo.NashvilleHousing$
Add OwnerSplitAddress Nvarchar(255);
Update Projects.dbo.NashvilleHousing$
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

Alter table Projects.dbo.NashvilleHousing$
Add OwnerSplitCity Nvarchar(255);
Update Projects.dbo.NashvilleHousing$
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

Alter Table Projects.dbo.NashvilleHousing$
Add OwnerSplitState Nvarchar(255);
Update Projects.dbo.NashvilleHousing$
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

Select *
From Projects.dbo.NashvilleHousing$



----------------------------------------------------------------------------------------------------------------------
--Change 'Y' and 'N'  to Yes and No in "Sold and Vacant" field
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Projects.dbo.NashvilleHousing$
Group by SoldAsVacant
--order by 2
Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'YES'
       When SoldAsVacant = 'N' THEN 'NO'
	   Else SoldAsVacant
	   END
From Projects.dbo.NashvilleHousing$

Update Projects.dbo.NashvilleHousing$
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'YES'
       When SoldAsVacant = 'N' THEN 'NO'
	   Else SoldAsVacant
	   END

-------Remove duplicates
With RownumCTE AS(
Select *,
    ROW_NUMBER() OVER(
	Partition by ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order by
				UniqueId
				) row_num
From Projects.dbo.NashvilleHousing$
--order by ParcelId
)
Delete 
From RownumCTE
Where row_num>1

---Removing unused columns
Select *
From Projects.dbo.NashvilleHousing$
Alter table Projects.dbo.NashvilleHousing$
Drop column OwnerAddress, TaxDistrict,PropertyAddress, Saledate






































