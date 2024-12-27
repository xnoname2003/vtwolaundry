# VTwoLaundry Database Schema

Welcome to the **VTwoLaundry Database Schema** project! This repository contains the SQL scripts to create and manage the database schema for a laundry management system. The schema is designed with modularity and clarity, ensuring scalability and easy maintenance.

## Features
- **Customer Management**: Keep track of customers with their personal details.
- **Cashier Management**: Manage cashier information.
- **Service Management**: Define laundry services with pricing and units.
- **Store Management**: Store details including address and contact information.
- **Perfume Inventory**: Track available perfume stock.
- **Transaction Management**: Handle complete laundry transactions and associated services.

---

## Database Setup

### 1. Create the Database
```sql
CREATE DATABASE VTwoLaundryDB CHARACTER SET utf8 COLLATE utf8_general_ci;
```
<img width="620" alt="image" src="https://github.com/user-attachments/assets/6b01ec1a-0f38-412e-afca-fbe6f96de4b8" />

### 2. Create Tables

#### Customer Table (`Ms_Pelanggan`)
```sql
CREATE TABLE Ms_Pelanggan (
    idPelanggan CHAR(6) PRIMARY KEY,
    nama_pelanggan VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```
<img width="1095" alt="image" src="https://github.com/user-attachments/assets/8a35a813-3271-4e05-9dfc-f4cffa46d5ac" />


#### Cashier Table (`Ms_Kasir`)
```sql
CREATE TABLE Ms_Kasir (
    idKasir CHAR(6) PRIMARY KEY,
    nama_kasir VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```
<img width="993" alt="image" src="https://github.com/user-attachments/assets/baf5f2a0-1bde-4a2d-8d8e-3253e65a494d" />


#### Service Table (`Ms_Layanan`)
```sql
CREATE TABLE Ms_Layanan (
    idLayanan CHAR(6) PRIMARY KEY,
    nama_layanan VARCHAR(255) NOT NULL,
    satuan VARCHAR(50) NOT NULL,
    harga INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```
<img width="1142" alt="image" src="https://github.com/user-attachments/assets/2e5d0125-4a86-4441-ab99-26a542fb9b30" />


#### Store Table (`Ms_Toko`)
```sql
CREATE TABLE Ms_Toko (
    idToko CHAR(6) PRIMARY KEY,
    nama_toko VARCHAR(255) NOT NULL,
    alamat VARCHAR(255) NOT NULL,
    no_tlp BIGINT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```
<img width="1107" alt="image" src="https://github.com/user-attachments/assets/1a1f26e4-6c07-421b-899a-80e8ca9e0576" />


#### Perfume Table (`Ms_Parfum`)
```sql
CREATE TABLE Ms_Parfum (
    idParfum CHAR(6) PRIMARY KEY,
    nama_parfum VARCHAR(255) NOT NULL,
    stok_tersedia INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```
<img width="1126" alt="image" src="https://github.com/user-attachments/assets/0197ce00-7915-4e61-8d6f-22ebc68ad2f9" />


#### Laundry Transaction Table (`Trx_Laundry`)
```sql
CREATE TABLE Trx_Laundry (
  no_struk CHAR(6) PRIMARY KEY,
  idParfum CHAR(6),
  idPelanggan CHAR(6),
  idKasir CHAR(6),
  idToko CHAR(6),
  grand_total INT,
  dp INT,
  sisa INT,
  tgl_transaksi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (idParfum) REFERENCES Ms_Parfum(idParfum),
  FOREIGN KEY (idPelanggan) REFERENCES Ms_Pelanggan(idPelanggan),
  FOREIGN KEY (idKasir) REFERENCES Ms_Kasir(idKasir),
  FOREIGN KEY (idToko) REFERENCES Ms_Toko(idToko)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```
<img width="1193" alt="image" src="https://github.com/user-attachments/assets/5f7efd0a-a509-49b1-9f9f-b8a8a982962a" />


#### Service Transaction Table (`Trx_Layanan`)
```sql
CREATE TABLE Trx_Layanan (
  idTrxLayanan INT AUTO_INCREMENT PRIMARY KEY,
  no_struk CHAR(6),
  idLayanan CHAR(6),
  kuantitas INT,
  total_harga INT,
  FOREIGN KEY (no_struk) REFERENCES Trx_Laundry(no_struk),
  FOREIGN KEY (idLayanan) REFERENCES Ms_Layanan(idLayanan)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```
<img width="1197" alt="image" src="https://github.com/user-attachments/assets/4918dd09-517b-48f5-85dc-645cf83b548b" />


---

## Insert 20 Rows Data Master

### Customer Table (`Ms_Pelanggan`)
```sql
INSERT INTO Ms_Pelanggan (idPelanggan, nama_pelanggan)
    VALUES
('PLG001', 'Ahmad Setiawan'), ('PLG002', 'Dewi Lestari'), ('PLG003', 'Budi Santoso'), ('PLG004', 'Citra Maharani'),('PLG005', 'Eka Pratama'),
('PLG006', 'Farah Indah'), ('PLG007', 'Gilang Permana'), ('PLG008', 'Hadi Saputra'), ('PLG009', 'Irma Dwi'), ('PLG010', 'Joko Rahmat'),
('PLG011', 'Kurniawati Ayu'), ('PLG012', 'Lia Santika'), ('PLG013', 'Mario Budiman'), ('PLG014', 'Nina Maharani'), ('PLG015', 'Oki Kurniawan'),
('PLG016', 'Putri Anjani'), ('PLG017', 'Rina Setiani'), ('PLG018', 'Satria Bima'), ('PLG019', 'Tina Handayani'), ('PLG020', 'Utami Lestari'); 
```
<img width="1188" alt="image" src="https://github.com/user-attachments/assets/81e251fd-b15d-4f49-b884-7131da9b64b3" />


### Cashier Table (`Ms_Kasir`)
```sql
INSERT INTO Ms_Kasir (idKasir, nama_kasir)
    VALUES
('KSR001', 'Dian Suryani'), ('KSR002', 'Rizky Permata'), ('KSR003', 'Edi Santoso'), ('KSR004', 'Faisal Anwar'), ('KSR005', 'Ika Nurul'),
('KSR006', 'Beni Setiawan'), ('KSR007', 'Lutfi Ramadhan'), ('KSR008', 'Vina Lestari'), ('KSR009', 'Wawan Gunawan'), ('KSR010', 'Yuni Indah'),
('KSR011', 'Nani Kurnia'), ('KSR012', 'Arif Widodo'), ('KSR013', 'Dewi Sartika'), ('KSR014', 'Fajar Maulana'), ('KSR015', 'Hendra Jaya'),
('KSR016', 'Irfan Saputra'), ('KSR017', 'Maya Kusuma'), ('KSR018', 'Rina Nuraini'), ('KSR019', 'Taufik Rahman'), ('KSR020', 'Zahra Fadillah'); 
```
<img width="1207" alt="image" src="https://github.com/user-attachments/assets/85144e79-29a8-4bed-93a6-280ca72bbc09" />


### Service Table (`Ms_Layanan`)
```sql

INSERT INTO Ms_Layanan (idLayanan, nama_layanan, satuan, harga)
    VALUES
('LYN001', 'Cuci Kering', 'Kg', 15000), ('LYN002', 'Cuci Basah', 'Kg', 10000), ('LYN003', 'Cuci Kering Lipat', 'Kg', 20000), ('LYN004', 'Setrika Saja', 'Kg', 8000),
('LYN005', 'Dry Cleaning', 'Pcs', 25000), ('LYN006', 'Cuci Boneka', 'Pcs', 30000), ('LYN007', 'Cuci Karpet', 'Pcs', 50000), ('LYN008', 'Cuci Selimut', 'Pcs', 40000),
('LYN009', 'Cuci Gordyn', 'Pcs', 60000), ('LYN010', 'Laundry Ekspres', 'Kg', 30000), ('LYN011', 'Laundry Regular', 'Kg', 12000), ('LYN012', 'Cuci Jaket', 'Pcs', 20000),
('LYN013', 'Cuci Sepatu', 'Pcs', 15000), ('LYN014', 'Cuci Helm', 'Pcs', 12000), ('LYN015', 'Cuci Topi', 'Pcs', 10000), ('LYN016', 'Cuci Tas', 'Pcs', 25000),
('LYN017', 'Cuci Baju Delicate', 'Kg', 40000), ('LYN018', 'Laundry Jas', 'Pcs', 35000), ('LYN019', 'Laundry Hotel', 'Kg', 50000), ('LYN020', 'Laundry Industrial', 'Kg', 80000); 
```
<img width="1204" alt="image" src="https://github.com/user-attachments/assets/ae0493ba-0159-4cde-8ceb-ad33a0d2b215" />


### Store Table (`Ms_Toko`)
```sql
INSERT INTO Ms_Toko (idToko, nama_toko, alamat, no_tlp)
    VALUES
('TOK001', 'Laundry Center 1', 'Jl. Mawar No.1', 6281234567890), ('TOK002', 'Laundry Center 2', 'Jl. Melati No.2', 6281234567891),
('TOK003', 'Laundry Center 3', 'Jl. Anggrek No.3', 6281234567892), ('TOK004', 'Laundry Center 4', 'Jl. Kenanga No.4', 6281234567893),
('TOK005', 'Laundry Center 5', 'Jl. Dahlia No.5', 6281234567894), ('TOK006', 'Laundry Center 6', 'Jl. Teratai No.6', 6281234567895),
('TOK007', 'Laundry Center 7', 'Jl. Kemuning No.7', 6281234567896), ('TOK008', 'Laundry Center 8', 'Jl. Cempaka No.8', 6281234567897),
('TOK009', 'Laundry Center 9', 'Jl. Bougenville No.9', 6281234567898), ('TOK010', 'Laundry Center 10', 'Jl. Kamboja No.10', 6281234567899),
('TOK011', 'Laundry Center 11', 'Jl. Mawar No.11', 6281234567800), ('TOK012', 'Laundry Center 12', 'Jl. Melati No.12', 6281234567801),
('TOK013', 'Laundry Center 13', 'Jl. Anggrek No.13', 6281234567802), ('TOK014', 'Laundry Center 14', 'Jl. Kenanga No.14', 6281234567803),
('TOK015', 'Laundry Center 15', 'Jl. Dahlia No.15', 6281234567804), ('TOK016', 'Laundry Center 16', 'Jl. Teratai No.16', 6281234567805),
('TOK017', 'Laundry Center 17', 'Jl. Kemuning No.17', 6281234567806), ('TOK018', 'Laundry Center 18', 'Jl. Cempaka No.18', 6281234567807),
('TOK019', 'Laundry Center 19', 'Jl. Bougenville No.19', 6281234567808), ('TOK020', 'Laundry Center 20', 'Jl. Kamboja No.20', 6281234567809); 
```
<img width="1211" alt="image" src="https://github.com/user-attachments/assets/2d1faeee-3d85-49f8-92d4-984b6fc0ec1e" />


### Perfume Table (`Ms_Parfum`)
```sql
INSERT INTO Ms_Parfum (idParfum, nama_parfum, stok_tersedia)
    VALUES
('PRF001', 'Lavender', 100), ('PRF002', 'Rose', 80), ('PRF003', 'Jasmine', 120), ('PRF004', 'Ocean', 150), ('PRF005', 'Lemon', 90),
('PRF006', 'Vanilla', 70), ('PRF007', 'Musk', 110), ('PRF008', 'Sandalwood', 50), ('PRF009', 'Mint', 130), ('PRF010', 'Citrus', 140),
('PRF011', 'Pine', 60), ('PRF012', 'Amber', 85), ('PRF013', 'Cedarwood', 75), ('PRF014', 'Peach', 65), ('PRF015', 'Apple', 95),
('PRF016', 'Strawberry', 115), ('PRF017', 'Grapefruit', 125), ('PRF018', 'Coconut', 55), ('PRF019', 'Cherry', 105), ('PRF020', 'Blueberry', 135);
```
<img width="1196" alt="image" src="https://github.com/user-attachments/assets/23a06154-2964-4411-baac-bc87aa681f69" />

---

## Implementation Transaction

### Create Procedures InsertTrxLaundry
```sql
DELIMITER $$

CREATE PROCEDURE InsertTrxLaundry(
    IN p_no_struk CHAR(6),
    IN p_idParfum CHAR(6),
    IN p_idPelanggan CHAR(6),
    IN p_idKasir CHAR(6),
    IN p_idToko CHAR(6),
    IN p_layanan1 CHAR(6),
    IN p_kuantitas_layanan1 INT,
    IN p_layanan2 CHAR(6),
    IN p_kuantitas_layanan2 INT,
    IN p_layanan3 CHAR(6),
    IN p_kuantitas_layanan3 INT,
    IN p_dp INT
)
BEGIN
    -- Deklarasi variabel lokal
    DECLARE p_stok_tersedia INT;
    DECLARE p_harga_layanan1, p_harga_layanan2, p_harga_layanan3 INT DEFAULT 0;
    DECLARE p_total_harga_layanan1, p_total_harga_layanan2, p_total_harga_layanan3 INT DEFAULT 0;
    DECLARE p_grand_total INT DEFAULT 0;
    DECLARE p_total_kuantitas INT DEFAULT 0;

    -- Label untuk prosedur
    transaksi_block: BEGIN

        -- Nilai default jika parameter NULL
        IF p_layanan2 IS NULL THEN
            SET p_layanan2 = '';
        END IF;

        IF p_kuantitas_layanan2 IS NULL THEN
            SET p_kuantitas_layanan2 = 0;
        END IF;

        IF p_layanan3 IS NULL THEN
            SET p_layanan3 = '';
        END IF;

        IF p_kuantitas_layanan3 IS NULL THEN
            SET p_kuantitas_layanan3 = 0;
        END IF;

        -- Mulai transaksi
        START TRANSACTION;

        -- Hitung grand total dan total kuantitas
        IF p_layanan1 IS NOT NULL AND p_kuantitas_layanan1 > 0 THEN
            SELECT harga INTO p_harga_layanan1
            FROM Ms_Layanan
            WHERE idLayanan = p_layanan1;
            SET p_total_harga_layanan1 = p_harga_layanan1 * p_kuantitas_layanan1;
            SET p_total_kuantitas = p_total_kuantitas + p_kuantitas_layanan1;
        END IF;

        IF p_layanan2 IS NOT NULL AND p_kuantitas_layanan2 > 0 THEN
            SELECT harga INTO p_harga_layanan2
            FROM Ms_Layanan
            WHERE idLayanan = p_layanan2;
            SET p_total_harga_layanan2 = p_harga_layanan2 * p_kuantitas_layanan2;
            SET p_total_kuantitas = p_total_kuantitas + p_kuantitas_layanan2;
        END IF;

        IF p_layanan3 IS NOT NULL AND p_kuantitas_layanan3 > 0 THEN
            SELECT harga INTO p_harga_layanan3
            FROM Ms_Layanan
            WHERE idLayanan = p_layanan3;
            SET p_total_harga_layanan3 = p_harga_layanan3 * p_kuantitas_layanan3;
            SET p_total_kuantitas = p_total_kuantitas + p_kuantitas_layanan3;
        END IF;

        SET p_grand_total = p_total_harga_layanan1 + p_total_harga_layanan2 + p_total_harga_layanan3;

        -- Insert ke Trx_Laundry terlebih dahulu
        INSERT INTO Trx_Laundry (
            no_struk, idParfum, idPelanggan, idKasir, idToko,
            grand_total, dp, sisa, tgl_transaksi
        )
        VALUES (
            p_no_struk, p_idParfum, p_idPelanggan, p_idKasir, p_idToko,
            p_grand_total, p_dp, p_grand_total - p_dp, CURRENT_TIMESTAMP
        );

        -- Insert ke Trx_Layanan
        IF p_layanan1 IS NOT NULL AND p_kuantitas_layanan1 > 0 THEN
            INSERT INTO Trx_Layanan (no_struk, idLayanan, kuantitas, total_harga)
            VALUES (p_no_struk, p_layanan1, p_kuantitas_layanan1, p_total_harga_layanan1);
        END IF;

        IF p_layanan2 IS NOT NULL AND p_kuantitas_layanan2 > 0 THEN
            INSERT INTO Trx_Layanan (no_struk, idLayanan, kuantitas, total_harga)
            VALUES (p_no_struk, p_layanan2, p_kuantitas_layanan2, p_total_harga_layanan2);
        END IF;

        IF p_layanan3 IS NOT NULL AND p_kuantitas_layanan3 > 0 THEN
            INSERT INTO Trx_Layanan (no_struk, idLayanan, kuantitas, total_harga)
            VALUES (p_no_struk, p_layanan3, p_kuantitas_layanan3, p_total_harga_layanan3);
        END IF;

        -- Cek stok parfum
        SELECT stok_tersedia INTO p_stok_tersedia
        FROM Ms_Parfum
        WHERE idParfum = p_idParfum;

        IF p_stok_tersedia < p_total_kuantitas THEN
            ROLLBACK;
            SELECT 'Transaksi Gagal: Stok Parfum Tidak Mencukupi.' AS message;
            LEAVE transaksi_block;
        END IF;

        -- Update stok parfum
        UPDATE Ms_Parfum
        SET stok_tersedia = stok_tersedia - p_total_kuantitas
        WHERE idParfum = p_idParfum;

        -- Commit transaksi
        COMMIT;

        SELECT 'Transaksi berhasil' AS Status, p_no_struk AS No_Struk;

    END transaksi_block; -- Label akhir prosedur
END$$

DELIMITER ;
```
<img width="1226" alt="image" src="https://github.com/user-attachments/assets/e4f05d39-8159-41a8-a050-7c0fbf6b7e25" />

