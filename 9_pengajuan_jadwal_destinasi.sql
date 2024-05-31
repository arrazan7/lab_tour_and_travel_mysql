use lab_tour_and_travel;

CREATE TABLE pengajuan_jadwal_destinasi (
	id_pengajuanjadwal INT AUTO_INCREMENT,
    id_pengajuanpaket INT NOT NULL,
    id_destinasi INT NOT NULL,
	hari VARCHAR(20) CHECK(hari IN ('Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu')),
    hari_ke INT NOT NULL,
    destinasi_ke INT NOT NULL,
    koordinat_berangkat VARCHAR(100),
    koordinat_tiba VARCHAR(100),
    jarak_tempuh INT NOT NULL,
    waktu_tempuh INT NOT NULL,
    waktu_sebenarnya INT NOT NULL,
    jam_mulai TIME NOT NULL,
    jam_selesai TIME NOT NULL,
    jam_lokasi char(5) CHECK(jam_lokasi IN ('WIB', 'WITA', 'WIT')),
    PRIMARY KEY (id_pengajuanjadwal),
    FOREIGN KEY (id_pengajuanpaket) REFERENCES pengajuan_paket_destinasi(id_pengajuanpaket),
    FOREIGN KEY (id_destinasi) REFERENCES destinasi(id_destinasi)
);

-- DROP TABLE pengajuan_jadwal_destinasi;