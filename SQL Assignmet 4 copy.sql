
	CREATE DATABASE Manufacturer;
	
	
	CREATE TABLE Product (
	  product_id INT PRIMARY KEY,
	  product_name VARCHAR(50) NOT NULL,
	  quantity_on_hand INT
	);
	
	CREATE TABLE Component (
	  component_id INT PRIMARY KEY,
	  component_name VARCHAR(50) NOT NULL,
	  description VARCHAR(50),
	  quantity_on_hand INT
	);
	
	CREATE TABLE Supplier (
	  supplier_id INT PRIMARY KEY,
	  supplier_name NVARCHAR(50) NOT NULL,
	  is_active BIT
	);
	
	CREATE TABLE Component_supplier (
	  component_id INT,
	  supplier_id INT, 
	  supply_date DATE,
	  supplied_amount INT,
	  FOREIGN KEY (component_id) REFERENCES Component(component_id),
	  FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id)
	);
	
	CREATE TABLE Product_component (
	  product_id INT,
	  component_id INT,
	  FOREIGN KEY (product_id) REFERENCES Product(product_id),
	  FOREIGN KEY (component_id) REFERENCES Component(component_id)
	);
	
	
	-- c) Define table constraints:
	
	ALTER TABLE Component
	  ADD CONSTRAINT component_quantity_on_hand CHECK (quantity_on_hand >= 0);
	
	ALTER TABLE Supplier
	  ADD CONSTRAINT supplier_status CHECK (is_active IN (0, 1, NULL));
	
	ALTER TABLE Component_supplier
	  ADD CONSTRAINT supplied_amount_check CHECK (supplied_amount >= 0);
