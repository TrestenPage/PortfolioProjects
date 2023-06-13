/*

Cleaning Data in SQL Queries

*/

Select TOP(100) *
From PortfolioProject.dbo.NashvilleHousingData

-------------------------------------------------------------------------------------------------
-- Standardize Date Format

Select TOP(100) SaleDateConverted, CONVERT(Date, SaleDate)
From PortfolioProject.dbo.NashvilleHousingData

Update [NashvilleHousingData]
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE PortfolioProject.dbo.NashvilleHousingData
Add SaleDateConverted Date;

Update PortfolioProject.dbo.NashvilleHousingData
SET SaleDateConverted = CONVERT(Date, SaleDate)


-------------------------------------------------------------------------------------------------
-- Populate Property Address data

Select TOP(100) *
From PortfolioProject.dbo.NashvilleHousingData
-- Where PropertyAddress is NULL
Order By ParcelID

Select TOP(100) a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousingData a 
Join PortfolioProject.dbo.NashvilleHousingData b 
    On a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
Where a.PropertyAddress is NULL

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousingData a 
Join PortfolioProject.dbo.NashvilleHousingData b 
    On a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID



-------------------------------------------------------------------------------------------------
-- Breaking out Address into Individual Columns (Address, City, State)

Select TOP(100) PropertyAddress
From PortfolioProject.dbo.NashvilleHousingData
-- Where PropertyAddress is NULL
-- Order By ParcelID


----------

-- Using Substring to split 

Select TOP(100)
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
From PortfolioProject.dbo.NashvilleHousingData


ALTER TABLE PortfolioProject.dbo.NashvilleHousingData
Add PropertySplitAddress NVARCHAR(255)

Update PortfolioProject.dbo.NashvilleHousingData
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)


ALTER TABLE PortfolioProject.dbo.NashvilleHousingData
Add PropertySplitCity NVARCHAR(255)

Update PortfolioProject.dbo.NashvilleHousingData
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))



Select TOP(100) *
From PortfolioProject.dbo.NashvilleHousingData

----------

-- Using Parsname to split 

select OwnerAddress
From PortfolioProject.dbo.NashvilleHousingData


Select TOP(100)
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
, PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
, PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
From PortfolioProject.dbo.NashvilleHousingData


ALTER TABLE PortfolioProject.dbo.NashvilleHousingData
Add OwnerSplitAddress NVARCHAR(255)

Update PortfolioProject.dbo.NashvilleHousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)


ALTER TABLE PortfolioProject.dbo.NashvilleHousingData
Add OwnerSplitCity NVARCHAR(255)

Update PortfolioProject.dbo.NashvilleHousingData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE PortfolioProject.dbo.NashvilleHousingData
Add OwnerSplitState NVARCHAR(255)

Update PortfolioProject.dbo.NashvilleHousingData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)


Select TOP(100)*
From PortfolioProject.dbo.NashvilleHousingData

-------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field 

Select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousingData
Group By SoldAsVacant
Order By 2

----------
-- Case Statement 

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
        When SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
        END
From PortfolioProject.dbo.NashvilleHousingData


Update [PortfolioProject].dbo.NashvilleHousingData
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
        When SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
        END




-------------------------------------------------------------------------------------------------
-- Remove Duplicates 

WITH RowNumCTE AS (
Select *, 
ROW_NUMBER() OVER (
    PARTITION BY ParcelID,
                    PropertyAddress,
                    SalePrice,
                    SaleDate,
                    LegalReference
                    ORDER BY
                        UniqueID 
                        ) row_num
From PortfolioProject.dbo.NashvilleHousingData
--Order By ParcelID
)

Select * 
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

---- 

WITH RowNumCTE AS (
Select *, 
ROW_NUMBER() OVER (
    PARTITION BY ParcelID,
                    PropertyAddress,
                    SalePrice,
                    SaleDate,
                    LegalReference
                    ORDER BY
                        UniqueID 
                        ) row_num
From PortfolioProject.dbo.NashvilleHousingData
--Order By ParcelID
)

DELETE
From RowNumCTE
Where row_num > 1
-- Order by PropertyAddress


-------------------------------------------------------------------------------------------------
-- Delete Unused Columns

Select TOP(100)*
From PortfolioProject.dbo.NashvilleHousingData

ALTER TABLE PortfolioProject.dbo.NashvilleHousingData
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousingData
DROP COLUMN SaleDate 