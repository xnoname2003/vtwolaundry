-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Generation Time: Jan 04, 2025 at 04:21 PM
-- Server version: 8.0.35
-- PHP Version: 8.2.20

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `VTwoLaundryDB`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertTrxLaundry` (IN `p_no_struk` CHAR(6), IN `p_idParfum` CHAR(6), IN `p_idPelanggan` CHAR(6), IN `p_idKasir` CHAR(6), IN `p_idToko` CHAR(6), IN `p_layanan1` CHAR(6), IN `p_kuantitas_layanan1` INT, IN `p_layanan2` CHAR(6), IN `p_kuantitas_layanan2` INT, IN `p_layanan3` CHAR(6), IN `p_kuantitas_layanan3` INT, IN `p_dp` INT)   BEGIN
    -- Deklarasi variabel lokal
    DECLARE p_stok_tersedia INT;
    DECLARE p_harga_layanan1, p_harga_layanan2, p_harga_layanan3 INT DEFAULT 0;
    DECLARE p_total_harga_layanan1, p_total_harga_layanan2, p_total_harga_layanan3 INT DEFAULT 0;
    DECLARE p_grand_total INT DEFAULT 0;
    DECLARE p_total_kuantitas INT DEFAULT 0;

    -- Label untuk prosedur
    transaksi_block:BEGIN

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

-- --------------------------------------------------------

--
-- Table structure for table `Ms_Kasir`
--

CREATE TABLE `Ms_Kasir` (
  `idKasir` char(6) NOT NULL,
  `nama_kasir` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `Ms_Kasir`
--

INSERT INTO `Ms_Kasir` (`idKasir`, `nama_kasir`) VALUES
('KSR001', 'Dian Suryani'),
('KSR002', 'Rizky Permata'),
('KSR003', 'Edi Santoso'),
('KSR004', 'Faisal Anwar'),
('KSR005', 'Ika Nurul'),
('KSR006', 'Beni Setiawan'),
('KSR007', 'Lutfi Ramadhan'),
('KSR008', 'Vina Lestari'),
('KSR009', 'Wawan Gunawan'),
('KSR010', 'Yuni Indah'),
('KSR011', 'Nani Kurnia'),
('KSR012', 'Arif Widodo'),
('KSR013', 'Dewi Sartika'),
('KSR014', 'Fajar Maulana'),
('KSR015', 'Hendra Jaya'),
('KSR016', 'Irfan Saputra'),
('KSR017', 'Maya Kusuma'),
('KSR018', 'Rina Nuraini'),
('KSR019', 'Taufik Rahman'),
('KSR020', 'Zahra Fadillah');

-- --------------------------------------------------------

--
-- Table structure for table `Ms_Layanan`
--

CREATE TABLE `Ms_Layanan` (
  `idLayanan` char(6) NOT NULL,
  `nama_layanan` varchar(255) NOT NULL,
  `satuan` varchar(50) NOT NULL,
  `harga` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `Ms_Layanan`
--

INSERT INTO `Ms_Layanan` (`idLayanan`, `nama_layanan`, `satuan`, `harga`) VALUES
('LYN001', 'Cuci Kering', 'Kg', 15000),
('LYN002', 'Cuci Basah', 'Kg', 10000),
('LYN003', 'Cuci Kering Lipat', 'Kg', 20000),
('LYN004', 'Setrika Saja', 'Kg', 8000),
('LYN005', 'Dry Cleaning', 'Pcs', 25000),
('LYN006', 'Cuci Boneka', 'Pcs', 30000),
('LYN007', 'Cuci Karpet', 'Pcs', 50000),
('LYN008', 'Cuci Selimut', 'Pcs', 40000),
('LYN009', 'Cuci Gordyn', 'Pcs', 60000),
('LYN010', 'Laundry Ekspres', 'Kg', 30000),
('LYN011', 'Laundry Regular', 'Kg', 12000),
('LYN012', 'Cuci Jaket', 'Pcs', 20000),
('LYN013', 'Cuci Sepatu', 'Pcs', 15000),
('LYN014', 'Cuci Helm', 'Pcs', 12000),
('LYN015', 'Cuci Topi', 'Pcs', 10000),
('LYN016', 'Cuci Tas', 'Pcs', 25000),
('LYN017', 'Cuci Baju Delicate', 'Kg', 40000),
('LYN018', 'Laundry Jas', 'Pcs', 35000),
('LYN019', 'Laundry Hotel', 'Kg', 50000),
('LYN020', 'Laundry Industrial', 'Kg', 80000);

-- --------------------------------------------------------

--
-- Table structure for table `Ms_Parfum`
--

CREATE TABLE `Ms_Parfum` (
  `idParfum` char(6) NOT NULL,
  `nama_parfum` varchar(255) NOT NULL,
  `stok_tersedia` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `Ms_Parfum`
--

INSERT INTO `Ms_Parfum` (`idParfum`, `nama_parfum`, `stok_tersedia`) VALUES
('PRF001', 'Lavender', 46),
('PRF002', 'Rose', 108),
('PRF003', 'Jasmine', 50),
('PRF004', 'Ocean', 88),
('PRF005', 'Lemon', 20),
('PRF006', 'Vanilla', 70),
('PRF007', 'Musk', 110),
('PRF008', 'Sandalwood', 50),
('PRF009', 'Mint', 130),
('PRF010', 'Citrus', 140),
('PRF011', 'Pine', 60),
('PRF012', 'Amber', 85),
('PRF013', 'Cedarwood', 75),
('PRF014', 'Peach', 65),
('PRF015', 'Apple', 95),
('PRF016', 'Strawberry', 115),
('PRF017', 'Grapefruit', 125),
('PRF018', 'Coconut', 55),
('PRF019', 'Cherry', 105),
('PRF020', 'Blueberry', 135);

-- --------------------------------------------------------

--
-- Table structure for table `Ms_Pelanggan`
--

CREATE TABLE `Ms_Pelanggan` (
  `idPelanggan` char(6) NOT NULL,
  `nama_pelanggan` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `Ms_Pelanggan`
--

INSERT INTO `Ms_Pelanggan` (`idPelanggan`, `nama_pelanggan`) VALUES
('PLG001', 'Ahmad Setiawan'),
('PLG002', 'Dewi Lestari'),
('PLG003', 'Budi Santoso'),
('PLG004', 'Citra Maharani'),
('PLG005', 'Eka Pratama'),
('PLG006', 'Farah Indah'),
('PLG007', 'Gilang Permana'),
('PLG008', 'Hadi Saputra'),
('PLG009', 'Irma Dwi'),
('PLG010', 'Joko Rahmat'),
('PLG011', 'Kurniawati Ayu'),
('PLG012', 'Lia Santika'),
('PLG013', 'Mario Budiman'),
('PLG014', 'Nina Maharani'),
('PLG015', 'Oki Kurniawan'),
('PLG016', 'Putri Anjani'),
('PLG017', 'Rina Setiani'),
('PLG018', 'Satria Bima'),
('PLG019', 'Tina Handayani'),
('PLG020', 'Utami Lestari');

-- --------------------------------------------------------

--
-- Table structure for table `Ms_Toko`
--

CREATE TABLE `Ms_Toko` (
  `idToko` char(6) NOT NULL,
  `nama_toko` varchar(255) NOT NULL,
  `alamat` varchar(255) NOT NULL,
  `no_tlp` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `Ms_Toko`
--

INSERT INTO `Ms_Toko` (`idToko`, `nama_toko`, `alamat`, `no_tlp`) VALUES
('TOK001', 'Laundry Center 1', 'Jl. Mawar No.1', 6281234567890),
('TOK002', 'Laundry Center 2', 'Jl. Melati No.2', 6281234567891),
('TOK003', 'Laundry Center 3', 'Jl. Anggrek No.3', 6281234567892),
('TOK004', 'Laundry Center 4', 'Jl. Kenanga No.4', 6281234567893),
('TOK005', 'Laundry Center 5', 'Jl. Dahlia No.5', 6281234567894),
('TOK006', 'Laundry Center 6', 'Jl. Teratai No.6', 6281234567895),
('TOK007', 'Laundry Center 7', 'Jl. Kemuning No.7', 6281234567896),
('TOK008', 'Laundry Center 8', 'Jl. Cempaka No.8', 6281234567897),
('TOK009', 'Laundry Center 9', 'Jl. Bougenville No.9', 6281234567898),
('TOK010', 'Laundry Center 10', 'Jl. Kamboja No.10', 6281234567899),
('TOK011', 'Laundry Center 11', 'Jl. Mawar No.11', 6281234567800),
('TOK012', 'Laundry Center 12', 'Jl. Melati No.12', 6281234567801),
('TOK013', 'Laundry Center 13', 'Jl. Anggrek No.13', 6281234567802),
('TOK014', 'Laundry Center 14', 'Jl. Kenanga No.14', 6281234567803),
('TOK015', 'Laundry Center 15', 'Jl. Dahlia No.15', 6281234567804),
('TOK016', 'Laundry Center 16', 'Jl. Teratai No.16', 6281234567805),
('TOK017', 'Laundry Center 17', 'Jl. Kemuning No.17', 6281234567806),
('TOK018', 'Laundry Center 18', 'Jl. Cempaka No.18', 6281234567807),
('TOK019', 'Laundry Center 19', 'Jl. Bougenville No.19', 6281234567808),
('TOK020', 'Laundry Center 20', 'Jl. Kamboja No.20', 6281234567809);

-- --------------------------------------------------------

--
-- Table structure for table `Trx_Laundry`
--

CREATE TABLE `Trx_Laundry` (
  `no_struk` char(6) NOT NULL,
  `idParfum` char(6) DEFAULT NULL,
  `idPelanggan` char(6) DEFAULT NULL,
  `idKasir` char(6) DEFAULT NULL,
  `idToko` char(6) DEFAULT NULL,
  `grand_total` int DEFAULT NULL,
  `dp` int DEFAULT NULL,
  `sisa` int DEFAULT NULL,
  `tgl_transaksi` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `Trx_Laundry`
--

INSERT INTO `Trx_Laundry` (`no_struk`, `idParfum`, `idPelanggan`, `idKasir`, `idToko`, `grand_total`, `dp`, `sisa`, `tgl_transaksi`) VALUES
('TRX001', 'PRF001', 'PLG001', 'KSR001', 'TOK001', 150000, 20000, 130000, '2024-12-27 16:35:35'),
('TRX002', 'PRF002', 'PLG002', 'KSR002', 'TOK002', 110000, 15000, 95000, '2024-12-27 16:35:35'),
('TRX003', 'PRF003', 'PLG003', 'KSR003', 'TOK003', 136000, 18000, 118000, '2024-12-27 16:35:35'),
('TRX004', 'PRF004', 'PLG004', 'KSR004', 'TOK001', 140000, 14000, 126000, '2024-12-27 16:35:35'),
('TRX005', 'PRF005', 'PLG005', 'KSR005', 'TOK002', 137000, 22000, 115000, '2024-12-27 16:35:35'),
('TRX006', 'PRF001', 'PLG006', 'KSR006', 'TOK003', 90000, 16000, 74000, '2024-12-27 16:35:35'),
('TRX007', 'PRF002', 'PLG007', 'KSR007', 'TOK001', 100000, 14000, 86000, '2024-12-27 16:35:35'),
('TRX008', 'PRF003', 'PLG008', 'KSR008', 'TOK002', 106000, 25000, 81000, '2024-12-27 16:35:35'),
('TRX009', 'PRF004', 'PLG009', 'KSR009', 'TOK003', 175000, 30000, 145000, '2024-12-27 16:35:35'),
('TRX010', 'PRF005', 'PLG010', 'KSR010', 'TOK001', 16000, 10000, 6000, '2024-12-27 16:35:35'),
('TRX011', 'PRF001', 'PLG011', 'KSR011', 'TOK002', 105000, 17000, 88000, '2024-12-27 16:35:35'),
('TRX012', 'PRF002', 'PLG012', 'KSR012', 'TOK003', 100000, 15000, 85000, '2024-12-27 16:35:35'),
('TRX013', 'PRF003', 'PLG013', 'KSR013', 'TOK001', 168000, 20000, 148000, '2024-12-27 16:35:35'),
('TRX014', 'PRF004', 'PLG014', 'KSR014', 'TOK002', 130000, 19000, 111000, '2024-12-27 16:35:35'),
('TRX015', 'PRF005', 'PLG015', 'KSR015', 'TOK003', 104000, 22000, 82000, '2024-12-27 16:35:35'),
('TRX016', 'PRF001', 'PLG016', 'KSR016', 'TOK001', 60000, 12000, 48000, '2024-12-27 16:35:35'),
('TRX017', 'PRF002', 'PLG017', 'KSR017', 'TOK002', 100000, 24000, 76000, '2024-12-27 16:35:35'),
('TRX018', 'PRF003', 'PLG018', 'KSR018', 'TOK003', 85000, 13000, 72000, '2024-12-27 16:35:35'),
('TRX019', 'PRF004', 'PLG019', 'KSR019', 'TOK001', 40000, 15000, 25000, '2024-12-27 16:35:35');

-- --------------------------------------------------------

--
-- Table structure for table `Trx_Layanan`
--

CREATE TABLE `Trx_Layanan` (
  `idTrxLayanan` int NOT NULL,
  `no_struk` char(6) DEFAULT NULL,
  `idLayanan` char(6) DEFAULT NULL,
  `kuantitas` int DEFAULT NULL,
  `total_harga` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `Trx_Layanan`
--

INSERT INTO `Trx_Layanan` (`idTrxLayanan`, `no_struk`, `idLayanan`, `kuantitas`, `total_harga`) VALUES
(1, 'TRX001', 'LYN001', 10, 150000),
(2, 'TRX002', 'LYN002', 5, 50000),
(3, 'TRX002', 'LYN003', 3, 60000),
(4, 'TRX003', 'LYN001', 8, 120000),
(5, 'TRX003', 'LYN004', 2, 16000),
(6, 'TRX004', 'LYN003', 7, 140000),
(7, 'TRX005', 'LYN004', 4, 32000),
(8, 'TRX005', 'LYN002', 6, 60000),
(9, 'TRX005', 'LYN001', 3, 45000),
(10, 'TRX006', 'LYN001', 6, 90000),
(11, 'TRX007', 'LYN003', 3, 60000),
(12, 'TRX007', 'LYN002', 4, 40000),
(13, 'TRX008', 'LYN002', 9, 90000),
(14, 'TRX008', 'LYN004', 2, 16000),
(15, 'TRX009', 'LYN001', 5, 75000),
(16, 'TRX009', 'LYN003', 4, 80000),
(17, 'TRX009', 'LYN002', 2, 20000),
(18, 'TRX010', 'LYN004', 2, 16000),
(19, 'TRX011', 'LYN001', 7, 105000),
(20, 'TRX012', 'LYN002', 4, 40000),
(21, 'TRX012', 'LYN003', 3, 60000),
(22, 'TRX013', 'LYN003', 8, 160000),
(23, 'TRX013', 'LYN004', 1, 8000),
(24, 'TRX014', 'LYN001', 6, 90000),
(25, 'TRX014', 'LYN003', 2, 40000),
(26, 'TRX015', 'LYN004', 3, 24000),
(27, 'TRX015', 'LYN002', 5, 50000),
(28, 'TRX015', 'LYN001', 2, 30000),
(29, 'TRX016', 'LYN001', 4, 60000),
(30, 'TRX017', 'LYN002', 10, 100000),
(31, 'TRX018', 'LYN003', 2, 40000),
(32, 'TRX018', 'LYN001', 3, 45000),
(33, 'TRX019', 'LYN004', 5, 40000);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Ms_Kasir`
--
ALTER TABLE `Ms_Kasir`
  ADD PRIMARY KEY (`idKasir`);

--
-- Indexes for table `Ms_Layanan`
--
ALTER TABLE `Ms_Layanan`
  ADD PRIMARY KEY (`idLayanan`);

--
-- Indexes for table `Ms_Parfum`
--
ALTER TABLE `Ms_Parfum`
  ADD PRIMARY KEY (`idParfum`);

--
-- Indexes for table `Ms_Pelanggan`
--
ALTER TABLE `Ms_Pelanggan`
  ADD PRIMARY KEY (`idPelanggan`);

--
-- Indexes for table `Ms_Toko`
--
ALTER TABLE `Ms_Toko`
  ADD PRIMARY KEY (`idToko`);

--
-- Indexes for table `Trx_Laundry`
--
ALTER TABLE `Trx_Laundry`
  ADD PRIMARY KEY (`no_struk`),
  ADD KEY `idParfum` (`idParfum`),
  ADD KEY `idPelanggan` (`idPelanggan`),
  ADD KEY `idKasir` (`idKasir`),
  ADD KEY `idToko` (`idToko`);

--
-- Indexes for table `Trx_Layanan`
--
ALTER TABLE `Trx_Layanan`
  ADD PRIMARY KEY (`idTrxLayanan`),
  ADD KEY `no_struk` (`no_struk`),
  ADD KEY `idLayanan` (`idLayanan`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Trx_Layanan`
--
ALTER TABLE `Trx_Layanan`
  MODIFY `idTrxLayanan` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Trx_Laundry`
--
ALTER TABLE `Trx_Laundry`
  ADD CONSTRAINT `trx_laundry_ibfk_1` FOREIGN KEY (`idParfum`) REFERENCES `Ms_Parfum` (`idParfum`) ON DELETE CASCADE,
  ADD CONSTRAINT `trx_laundry_ibfk_2` FOREIGN KEY (`idPelanggan`) REFERENCES `Ms_Pelanggan` (`idPelanggan`) ON DELETE CASCADE,
  ADD CONSTRAINT `trx_laundry_ibfk_3` FOREIGN KEY (`idKasir`) REFERENCES `Ms_Kasir` (`idKasir`) ON DELETE CASCADE,
  ADD CONSTRAINT `trx_laundry_ibfk_4` FOREIGN KEY (`idToko`) REFERENCES `Ms_Toko` (`idToko`) ON DELETE CASCADE;

--
-- Constraints for table `Trx_Layanan`
--
ALTER TABLE `Trx_Layanan`
  ADD CONSTRAINT `trx_layanan_ibfk_1` FOREIGN KEY (`no_struk`) REFERENCES `Trx_Laundry` (`no_struk`) ON DELETE CASCADE,
  ADD CONSTRAINT `trx_layanan_ibfk_2` FOREIGN KEY (`idLayanan`) REFERENCES `Ms_Layanan` (`idLayanan`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
