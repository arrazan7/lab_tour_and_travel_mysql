use lab_tour_and_travel;

CREATE TABLE pemesanan (
	id_pemesanan INT AUTO_INCREMENT,
    id_user INT NOT NULL,
    id_paketdestinasi INT NOT NULL,
	banyak_paket INT NOT NULL,
    dimulai_tanggal DATE NOT NULL,
    berakhir_tanggal DATE NOT NULL,
    harga_paket_wni INT,
    harga_paket_wna INT,
    total_harga_paket INT,
    catatan TEXT,
    PRIMARY KEY (id_pemesanan),
    FOREIGN KEY (id_user) REFERENCES users(id),
    FOREIGN KEY (id_paketdestinasi) REFERENCES paket_destinasi(id_paketdestinasi)
);

-- DROP TABLE pemesanan;

-- (id_paketdestinasi, hari, koordinat_berangkat, koordinat_tiba, jarak_tempuh, waktu_tempuh, id_destinasi, jam_mulai, jam_selesai, jam_lokasi, catatan)
-- CALL jadwal_destinasi (1, 'Rabu', '', '', 4.4, 20, 2, '08:40', '10:40', 'WIB', '');
DELIMITER //
CREATE PROCEDURE pemesanan (
  IN id_user INT,
  IN id_paketdestinasi INT,
  IN banyak_paket INT,
  IN dimulai_tanggal DATE,
  IN berakhir_tanggal DATE,
  IN catatan TEXT
)
BEGIN
	INSERT INTO pemesanan
    VALUES (0, id_user, id_paketdestinasi, banyak_paket, dimulai_tanggal, berakhir_tanggal, harga_wni, harga_wna, total_harga, catatan); 
END 
// DELIMITER ;
-- DROP PROCEDURE pemesanan;


DELIMITER //
CREATE TRIGGER respon_update_pemesanan
AFTER UPDATE ON pemesanan
FOR EACH ROW
BEGIN
	DECLARE harga_wni INT;
	DECLARE harga_wna INT;
    
    -- Perhitungan harga WNI WNA pada tabel pemesanan
    IF (OLD.harga_wni != NEW.harga_wni) OR (OLD.harga_wna != NEW.harga_wna) THEN
		SELECT harga_paket_wni, harga_paket_wna INTO harga_wni, harga_wna 
		FROM pemesanan 
		WHERE id_pemesanan = NEW.id_pemesanan;
		UPDATE pemesanan SET total_harga_paket = harga_paket_wni + harga_paket_wna WHERE id_pemesanan = NEW.id_pemesanan;
	END IF;
END;