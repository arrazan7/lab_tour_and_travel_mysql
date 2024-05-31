use lab_tour_and_travel;

CREATE TABLE paket_destinasi (
	id_paketdestinasi INT AUTO_INCREMENT,
    id_profile BIGINT NOT NULL,
    nama_paket VARCHAR(30) NOT NULL,
    durasi_wisata INT,
    harga_wni INT,
    harga_wna INT,
    total_jarak_tempuh DOUBLE,
    foto VARCHAR(200),
    tanggal_dibuat TIMESTAMP NOT NULL,
    PRIMARY KEY (id_paketdestinasi),
    FOREIGN KEY (id_profile) REFERENCES users(id)
);

DROP TABLE paket_destinasi;

DELIMITER //
CREATE PROCEDURE paket_destinasi (
  IN id_profile INT,
  IN nama_paket VARCHAR(30),
  IN foto VARCHAR(200)
)
BEGIN
    INSERT INTO paket_destinasi
    VALUES (0, id_profile, nama_paket, 0, 0, 0, 0, foto, NOW());
END //
DELIMITER ;

CALL paket_destinasi (1, '3 Hari di DIY', '');
CALL paket_destinasi (2, '4 Hari di DIY', '');
CALL paket_destinasi (3, '1 Hari di DIY', '');
CALL paket_destinasi (1, '3 Hari di DIY', '');
CALL paket_destinasi (2, '4 Hari di DIY', '');
CALL paket_destinasi (3, '1 Hari di DIY', '');
CALL paket_destinasi (1, '2 Hari di DIY', '');
CALL paket_destinasi (2, '2 Hari di DIY', '');
