use lab_tour_and_travel;

CREATE TABLE transportasi (
	id_transportasi INT AUTO_INCREMENT,
    nomor_plat INT NOT NULL,
	jenis INT NOT NULL,
    deskripsi INT,
    daya_tampung INT NOT NULL,
    biaya_sewa_perhari INT NOT NULL,
    biaya_sewa_perkilo INT NOT NULL,
    status INT NOT NULL,
    foto VARCHAR(255),
    PRIMARY KEY (id_pesanpenginapan),
    FOREIGN KEY (id_pemesanan) REFERENCES pemesanan(id_pemesanan),
    FOREIGN KEY (id_penginapan) REFERENCES penginapan(id_penginapan)
);