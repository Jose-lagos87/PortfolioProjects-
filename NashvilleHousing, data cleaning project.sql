
-- Standardize date format

select SaleDateConverted, convert(date, SaleDate)
from [SQL Portfolio].dbo.NashvilleHousing

Update NashvilleHousing
set SaleDate = convert(date, SaleDate)

Alter table NashvilleHousing
add SaleDateConverted date;

update NashvilleHousing
set SaleDateConverted = convert(date, SaleDate)

select * 
from [SQL Portfolio].dbo.NashvilleHousing

-- Populate Property Adress data

select PropertyAddress
from [SQL Portfolio].dbo.NashvilleHousing
where PropertyAddress is null

-- Where PropertyAddress is null (Es una union de una misma tabla)
--isnull, donde aparece un valor null colocara el valor de la celda respectiva en el b.PropertyAddress
-- este filtro es para verificar que no aparecen valores null nuevamente

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from [SQL Portfolio].dbo.NashvilleHousing a
join [SQL Portfolio].dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from [SQL Portfolio].dbo.NashvilleHousing a
join [SQL Portfolio].dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

-- BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE)
--substring divide una cadena de caracteres (nombre de columna, numero de caracter 1 sigfnifica desde el primer caracter,
-- charindex muestra el separador y el nombre de columna, -1 significa que el final sera cortado un caracter de los que quedaba
select SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
from [SQL Portfolio].dbo.NashvilleHousing

--
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
--Segundo substring no incluye el , por tanto no comienza desde el primer caracter, sino desde donde termina el separador (,)
From [SQL Portfolio].dbo.NashvilleHousing


-- Agregamos dos columnas a nuestra tabla [SQL Portfolio].dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

select *
from [SQL Portfolio].dbo.NashvilleHousing

-- Dividir la columna owneraddress con la funcion parse name
select owneraddress
from [SQL Portfolio].dbo.NashvilleHousing

select 
parsename(replace(owneraddress,',','.'),1)
from [SQL Portfolio].dbo.NashvilleHousing

-- parsename solo divide periodos, por eso se necesita replace para sustituir la coma por el punto.
--El numero indica el primer punto de izquierda a derecha

select 
parsename(replace(owneraddress,',','.'),3),
parsename(replace(owneraddress,',','.'),2),
parsename(replace(owneraddress,',','.'),1)
from [SQL Portfolio].dbo.NashvilleHousing



ALTER TABLE [SQL Portfolio].dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update [SQL Portfolio].dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [SQL Portfolio].dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update [SQL Portfolio].dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE [SQL Portfolio].dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update [SQL Portfolio].dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


select *
from [SQL Portfolio].dbo.NashvilleHousing


--CHANGE Y AND N TO YES AND NO IN "SOLD AS A VACANT" FIELD

select distinct(SoldAsVacant), count(SoldAsVacant)
from [SQL Portfolio].dbo.NashvilleHousing
group by SoldAsVacant
order by 2 desc

--Primero sustituimos los valores con el case statement
select SoldAsVacant,
case 
	when SoldAsVacant = 'Y'  then 'Yes'
	when SoldAsVacant = 'N'  then 'NO'
	else SoldAsVacant
end


--Luego actualizamos el campo soldasvacant con los valores que cambiamos con el case statement
update [SQL Portfolio].dbo.NashvilleHousing
set SoldAsVacant = case 
	when SoldAsVacant = 'Y'  then 'Yes'
	when SoldAsVacant = 'N'  then 'NO'
	else SoldAsVacant
end


-- REMOVED DUPLICATES
-- Las siguientes lineas sirven para enlistar los duplicados
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
					) row_num

From [SQL Portfolio].dbo.NashvilleHousing
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

--Delete, las siguientes lineas eliminan los duplicados
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
					) row_num

From [SQL Portfolio].dbo.NashvilleHousing
)
delete
From RowNumCTE
Where row_num > 1




Select *
From [SQL Portfolio].dbo.NashvilleHousing
-- DELETE UNUSED COLUMNS

Select *
From [SQL Portfolio].dbo.NashvilleHousing

alter table [SQL Portfolio].dbo.NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress






































