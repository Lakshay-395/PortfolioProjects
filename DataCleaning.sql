Select * from PortfolioProject.dbo.NashvilleHousing

-- Standardize date Format 
Select SaleDate, Convert(date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing

alter table NashvilleHousing add SalesData date

update NashvilleHousing set
SalesData = CONVERT(date,SaleDate)
alter table NashvilleHousing drop column  SaleDate

Select * from Portfolioproject.dbo.NashvilleHousing 

--Populate property address data
Select a.ParcelID,b.ParcelID,a.PropertyAddress, b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from Portfolioproject.dbo.NashvilleHousing a JOIN Portfolioproject.dbo.NashvilleHousing b
ON a.ParcelID  = b.ParcelID
AND a.[UniqueID ]<> b.[UniqueID ]
where a.propertyaddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from Portfolioproject.dbo.NashvilleHousing a JOIN Portfolioproject.dbo.NashvilleHousing b
ON a.ParcelID  = b.ParcelID
AND a.[UniqueID ]<> b.[UniqueID ]
where a.propertyaddress is null

--Splitting Address into Address, state, city
Select PropertyAddress from Portfolioproject.dbo.NashvilleHousing 

Select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
--SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as State
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as City
from Portfolioproject.dbo.NashvilleHousing

alter table NashvilleHousing add PropertySplitAddress  nvarchar(255)

update NashvilleHousing set
PropertySplitAddress =SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)
alter table NashvilleHousing add PropertySplitCity  nvarchar(255)

update NashvilleHousing set
PropertySplitCity =SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

Select * from PortfolioProject.dbo.NashvilleHousing

--Splitting Owner Address

Select PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from PortfolioProject.dbo.NashvilleHousing


alter table NashvilleHousing add OwnerSplitAddress  nvarchar(255)

update NashvilleHousing set
OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

alter table NashvilleHousing add OwnerSplitCity  nvarchar(255)

update NashvilleHousing set
OwnerSplitCity =  PARSENAME(REPLACE(OwnerAddress,',','.'),2)

alter table NashvilleHousing add OwnerSplitState  nvarchar(255)

update NashvilleHousing set
OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)
Select * from PortfolioProject.dbo.NashvilleHousing


--Changing Y and N to Yes and No respectively
Select distinct(SoldAsVacant),COunt(SoldAsVacant) from PortfolioProject.dbo.NashvilleHousing
Group By SoldAsVacant
Order by 2

Select SoldAsVacant,
CASE
when SoldAsVacant = 'Y' then 'Yes'
when soldAsVacant = 'N' then 'No'
ELSE
SoldAsVacant
END
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing set SoldAsVacant = CASE
when SoldAsVacant = 'Y' then 'Yes'
when soldAsVacant = 'N' then 'No'
ELSE
SoldAsVacant
END


-- Removing Duplicates

With ROWNumCTE AS(
Select *,ROW_NUMBER() OVER (
Partition by
ParcelID,
PropertyAddress,
SalePrice,
SalesDate,
Legalreference
ORDER BY UniqueID
)row_num


from PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *  from ROWNumCTE
where row_num>1

-- Deleting unused Columns

alter table PortfolioProject.dbo.NashvilleHousing drop column OwnerAddress,TaxDistrict,PropertyAddress
Select * from PortfolioProject.dbo.NashvilleHousing