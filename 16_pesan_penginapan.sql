use lab_tour_and_travel;

CREATE TABLE pesan_penginapan (
	id_pesanpenginapan INT AUTO_INCREMENT,
    id_pemesanan INT NOT NULL,
	id_penginapan INT NOT NULL,
    banyak_kamar INT,
    hari_ke INT NOT NULL,
    catatan TEXT,
    PRIMARY KEY (id_pesanpenginapan),
    FOREIGN KEY (id_pemesanan) REFERENCES pemesanan(id_pemesanan),
    FOREIGN KEY (id_penginapan) REFERENCES penginapan(id_penginapan)
);