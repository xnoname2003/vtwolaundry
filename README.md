<img width="620" alt="image" src="https://github.com/user-attachments/assets/6b01ec1a-0f38-412e-afca-fbe6f96de4b8" /># VTwoLaundry Database Schema

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

### 2. Create Tables

#### Customer Table (`Ms_Pelanggan`)
```sql
CREATE TABLE Ms_Pelanggan (
    idPelanggan CHAR(6) PRIMARY KEY,
    nama_pelanggan VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

#### Cashier Table (`Ms_Kasir`)
```sql
CREATE TABLE Ms_Kasir (
    idKasir CHAR(6) PRIMARY KEY,
    nama_kasir VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

#### Service Table (`Ms_Layanan`)
```sql
CREATE TABLE Ms_Layanan (
    idLayanan CHAR(6) PRIMARY KEY,
    nama_layanan VARCHAR(255) NOT NULL,
    satuan VARCHAR(50) NOT NULL,
    harga INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

#### Store Table (`Ms_Toko`)
```sql
CREATE TABLE Ms_Toko (
    idToko CHAR(6) PRIMARY KEY,
    nama_toko VARCHAR(255) NOT NULL,
    alamat VARCHAR(255) NOT NULL,
    no_tlp BIGINT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

#### Perfume Table (`Ms_Parfum`)
```sql
CREATE TABLE Ms_Parfum (
    idParfum CHAR(6) PRIMARY KEY,
    nama_parfum VARCHAR(255) NOT NULL,
    stok_tersedia INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

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

---

## Getting Started

### Prerequisites
- MySQL Server
- MySQL Workbench or any SQL client

### Installation
1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/VTwoLaundry-DB.git
   ```
2. Open the SQL file in your preferred SQL client.
3. Execute the scripts in order to set up the database and tables.

---

## Contributing
We welcome contributions! Feel free to fork this repository, make your changes, and submit a pull request.

---

## License
This project is licensed under the MIT License. See the `LICENSE` file for more details.

---

## Contact
For questions or suggestions, feel free to open an issue or contact [Your Name](mailto:your-email@example.com).

---

Happy coding! ✨
