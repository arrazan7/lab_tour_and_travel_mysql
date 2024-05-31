use lab_tour_and_travel;

CREATE TABLE pengajuan_paket_destinasi (
	id_pengajuanpaket INT AUTO_INCREMENT,
    id_profile BIGINT NOT NULL,
    nama_paket VARCHAR(30) NOT NULL,
    durasi_wisata INT,
    harga INT,
    total_jarak_tempuh INT,
    tanggal_dibuat DATE NOT NULL,
    status_ajuan VARCHAR(15) CHECK(status_ajuan IN ('menunggu', 'diterima', 'ditolak')) DEFAULT('menunggu'),
    PRIMARY KEY (id_pengajuanpaket),
    FOREIGN KEY (id_profile) REFERENCES users(id)
);

-- DROP TABLE pengajuan_paket_destinasi;