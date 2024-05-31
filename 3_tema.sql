use lab_tour_and_travel;

CREATE TABLE tema (
	id_tema INT AUTO_INCREMENT,
    nama_tema VARCHAR(20) NOT NULL,
    jenis VARCHAR(10) CHECK(jenis IN ('wisata', 'resto')),
    PRIMARY KEY (id_tema)
);

-- DROP TABLE tema;

INSERT INTO tema
VALUES
(0, 'Alam', 'wisata'),
(0, 'Kota', 'wisata'),
(0, 'Edukasi', 'wisata'),
(0, 'Seni & Budaya', 'wisata'),
(0, 'Religi', 'wisata'),
(0, 'Keluarga', 'wisata'),
(0, 'Belanja', 'wisata'),
(0, 'Wahana Bermain', 'wisata'),
(0, 'Olahraga', 'wisata'),
(0, 'Kuliner', 'wisata'),
(0, 'Outdoor', 'wisata'),
(0, 'Indoor', 'wisata'),
(0, 'Tanaman', 'wisata'),
(0, 'Binatang', 'wisata'),
(0, 'Street Food', 'resto'),
(0, 'Seafood', 'resto'),
(0, 'Vegetarian', 'resto'),
(0, 'Eksotis', 'resto'),
(0, 'Lokal', 'resto'),
(0, 'Tradisional', 'resto'),
(0, 'Modern', 'resto'),
(0, 'Lesehan', 'resto'),
(0, 'Prasmanan', 'resto'),
(0, 'Kafe', 'resto'),
(0, 'Indoor', 'resto'),
(0, 'Outdoor', 'resto');
