use lab_tour_and_travel;

CREATE TABLE destinasi_tutup (
	id_destinasitutup INT AUTO_INCREMENT,
    id_destinasi INT NOT NULL,
    hari_tutup VARCHAR(20) CHECK(hari_tutup IN ('Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu')),
    PRIMARY KEY (id_destinasitutup),
    FOREIGN KEY (id_destinasi) REFERENCES destinasi(id_destinasi)
);

-- DROP TABLE destinasi_tutup;

INSERT INTO destinasi_tutup
VALUES
(0, 1, 'Senin'),
(0, 2, 'Selasa'),
(0, 3, 'Rabu'),
(0, 4, 'Kamis'),
(0, 5, 'Jumat'),
(0, 6, 'Sabtu'),
(0, 7, 'Minggu'),
(0, 8, 'Senin'),
(0, 8, 'Selasa'),
(0, 9, 'Selasa'),
(0, 9, 'Rabu'),
(0, 10, 'Rabu'),
(0, 10, 'Kamis'),
(0, 11, 'Kamis'),
(0, 11, 'Jumat'),
(0, 12, 'Jumat'),
(0, 12, 'Sabtu'),
(0, 13, 'Sabtu'),
(0, 13, 'Minggu'),
(0, 14, 'Minggu'),
(0, 14, 'Senin'),
(0, 15, 'Senin'),
(0, 16, 'Selasa'),
(0, 17, 'Rabu'),
(0, 18, 'Kamis'),
(0, 19, 'Jumat'),
(0, 20, 'Sabtu'),
(0, 21, 'Minggu');