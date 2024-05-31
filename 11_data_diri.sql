use lab_tour_and_travel;

CREATE TABLE data_diri (
	id_datadiri INT AUTO_INCREMENT,
    id_pemesanan INT NOT NULL,
    nama VARCHAR(255) NOT NULL,
	jenis_kelamin char(3) CHECK(jenis_kelamin IN ('L', 'P')),
    nomor_hp VARCHAR(20),
    status_warga char(5) CHECK(status_warga IN ('WNI', 'WNA')),
    email VARCHAR(255),
    catatan TEXT,
    PRIMARY KEY (id_pemesanan),
    FOREIGN KEY (id_user) REFERENCES users(id),
    FOREIGN KEY (id_paketdestinasi) REFERENCES paket_destinasi(id_paketdestinasi)
);

-- DROP TABLE data_diri;

DELIMITER //
CREATE TRIGGER respon_to_pemesanan
AFTER INSERT ON data_diri
FOR EACH ROW
BEGIN
	DECLARE status_warga INT;
	DECLARE harga_wni INT;
	DECLARE harga_wna INT;
	DECLARE jaraktempuh_paketwisata DOUBLE;
    
    -- Perhitungan harga WNI WNA pada tabel pemesanan
    IF NEW.status_warga = WNI THEN
		SELECT harga_wni INTO harga_wni 
		FROM paket_destinasi 
		WHERE id_paketdestinasi = (SELECT id_paketdestinasi FROM pemesanan WHERE id_pemesanan = NEW.id_pemesanan);
		UPDATE pemesanan SET harga_paket_wni = harga_paket_wni + harga_wni WHERE id_pemesanan = NEW.id_pemesanan;
    ELSEIF NEW.status_warga = WNA THEN
		SELECT harga_wna INTO harga_wna
		FROM paket_destinasi 
		WHERE id_paketdestinasi = (SELECT id_paketdestinasi FROM pemesanan WHERE id_pemesanan = NEW.id_pemesanan);
        UPDATE pemesanan SET harga_paket_wna = harga_paket_wna + harga_wna WHERE id_pemesanan = NEW.id_pemesanan;
	END IF;
END;