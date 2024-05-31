use lab_tour_and_travel; 

CREATE TABLE jadwal_destinasi (
	id_jadwaldestinasi INT AUTO_INCREMENT,
    id_paketdestinasi INT NOT NULL,
	hari VARCHAR(20) CHECK(hari IN ('Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu')),
    hari_ke INT NOT NULL,
    destinasi_ke INT NOT NULL,
    koordinat_berangkat VARCHAR(100),
    koordinat_tiba VARCHAR(100),
    jarak_tempuh DOUBLE NOT NULL,
    waktu_tempuh INT NOT NULL,
    waktu_sebenarnya INT NOT NULL,
    id_destinasi INT NOT NULL,
    jam_mulai TIME NOT NULL,
    jam_selesai TIME NOT NULL,
    zona_mulai char(5) CHECK(zona_mulai IN ('WIB', 'WITA', 'WIT')),
    zona_selesai char(5) CHECK(zona_selesai IN ('WIB', 'WITA', 'WIT')),
    catatan TEXT,
    PRIMARY KEY (id_jadwaldestinasi),
    FOREIGN KEY (id_paketdestinasi) REFERENCES paket_destinasi(id_paketdestinasi),
    FOREIGN KEY (id_destinasi) REFERENCES destinasi(id_destinasi)
);


DROP TABLE jadwal_destinasi;

-- CALL jadwal_destinasi (id_paketdestinasi, hari, koordinat_berangkat, koordinat_tiba, 
-- jarak_tempuh, waktu_tempuh, id_destinasi, jam_mulai, jam_selesai, zona_mulai, zona_selesai, catatan)
CALL jadwal_destinasi (1, 'Rabu', '', '', 0, 0, 1, '06:00', '08:00', 'WIB', 'WIB', '');
CALL jadwal_destinasi (1, 'Rabu', '', '', 4.4, 20, 2, '08:20', '10:40', 'WIB', 'WIB', '');
CALL jadwal_destinasi (1, 'Rabu', '', '', 4.9, 19, 4, '11:00', '13:20', 'WIB', 'WIB', '');
CALL jadwal_destinasi (1, 'Rabu', '', '', 4.1, 51, 5, '14:15', '16:35', 'WIB', 'WIB', '');
CALL jadwal_destinasi (1, 'Kamis', '', '', 0, 0, 6, '09:00', '10:00', 'WIB', 'WIB', '');
CALL jadwal_destinasi (1, 'Kamis', '', '', 7.2, 25, 7, '10:25', '11:45', 'WIB', 'WIB', '');
CALL jadwal_destinasi (1, 'Kamis', '', '', 3.7, 31, 8, '12:20', '14:40', 'WIB', 'WIB', '');
CALL jadwal_destinasi (1, 'Kamis', '', '', 2.2, 10, 5, '14:50', '17:10', 'WIB', 'WIB', '');
CALL jadwal_destinasi (1, 'Jumat', '', '', 0, 0, 1, '06:00', '08:00', 'WIB', 'WIB', '');
CALL jadwal_destinasi (1, 'Jumat', '', '', 9.5, 30, 2, '08:30', '10:50', 'WIB', 'WIB', '');
CALL jadwal_destinasi (1, 'Jumat', '', '', 7.3, 13, 3, '11:05', '13:25', 'WIB', 'WIB', '');
CALL jadwal_destinasi (1, 'Jumat', '', '', 7, 10, 4, '13:35', '15:55', 'WIB', 'WIB', '');

CALL jadwal_destinasi (3, 'Minggu', '', '', 0, 0, 17, '09:00', '11:00', 'WIB', 'WIB', '');
CALL jadwal_destinasi (3, 'Minggu', '', '', 4.4, 20, 18, '11:20', '13:40', 'WIB', 'WIB', '');
CALL jadwal_destinasi (3, 'Minggu', '', '', 4.9, 19, 19, '14:00', '15:20', 'WIB', 'WIB', '');
CALL jadwal_destinasi (3, 'Minggu', '', '', 4.1, 51, 20, '16:15', '17:15', 'WIB', 'WIB', '');

CALL jadwal_destinasi (2, 'Senin', '', '', 0, 1, 2, '06:00', '08:00', 'WIB', 'WIB', '');
CALL jadwal_destinasi (2, 'Senin', '', '', 4.4, 20, 3, '08:20', '10:40', 'WIB', 'WIB', '');
CALL jadwal_destinasi (2, 'Senin', '', '', 4.9, 19, 4, '11:00', '13:20', 'WIB', 'WIB', '');
CALL jadwal_destinasi (2, 'Senin', '', '', 4.1, 51, 5, '14:15', '16:35', 'WIB', 'WIB', '');
CALL jadwal_destinasi (2, 'Selasa', '', '', 0, 0, 6, '09:00', '10:00', 'WIB', 'WIB', '');
CALL jadwal_destinasi (2, 'Selasa', '', '', 4.4, 20, 7, '10:20', '11:40', 'WIB', 'WIB', '');
CALL jadwal_destinasi (2, 'Selasa', '', '', 4.9, 19, 10, '12:00', '13:20', 'WIB', 'WIB', '');
CALL jadwal_destinasi (2, 'Selasa', '', '', 4.1, 51, 11, '14:15', '16:35', 'WIB', 'WIB', '');
CALL jadwal_destinasi (2, 'Rabu', '', '', 0, 0, 12, '08:00', '09:00', 'WIB', 'WIB', '');
CALL jadwal_destinasi (2, 'Rabu', '', '', 4.4, 20, 13, '09:20', '10:40', 'WIB', 'WIB', '');
CALL jadwal_destinasi (2, 'Rabu', '', '', 4.9, 19, 14, '11:00', '13:20', 'WIB', 'WIB', '');
CALL jadwal_destinasi (2, 'Rabu', '', '', 4.1, 51, 15, '14:15', '15:35', 'WIB', 'WIB', '');
CALL jadwal_destinasi (2, 'Kamis', '', '', 0, 0, 16, '09:00', '10:00', 'WIB', 'WIB', '');
CALL jadwal_destinasi (2, 'Kamis', '', '', 4.4, 20, 17, '10:20', '11:40', 'WIB', 'WIB', '');
CALL jadwal_destinasi (2, 'Kamis', '', '', 4.9, 19, 19, '12:00', '13:20', 'WIB', 'WIB', '');
CALL jadwal_destinasi (2, 'Kamis', '', '', 4.1, 51, 20, '14:15', '16:35', 'WIB', 'WIB', '');

CALL jadwal_destinasi (3, 'Senin', '', '', 0, 0, 2, '09:00', '11:00', 'WIB', 'WIB', '');
CALL jadwal_destinasi (3, 'Senin', '', '', 4.4, 20, 3, '11:20', '13:40', 'WIB', 'WIB', '');
CALL jadwal_destinasi (3, 'Senin', '', '', 4.9, 19, 4, '14:00', '15:20', 'WIB', 'WIB', '');
CALL jadwal_destinasi (3, 'Senin', '', '', 4.1, 51, 5, '16:15', '17:15', 'WIB', 'WIB', '');

CALL jadwal_destinasi (4, 'Rabu', '', '', 0, 0, 1, '06:00', '08:00', 'WIB', 'WIB', '');
CALL jadwal_destinasi (4, 'Rabu', '', '', 4.4, 20, 2, '08:20', '10:40', 'WIB', 'WIB', '');
CALL jadwal_destinasi (4, 'Rabu', '', '', 4.9, 19, 4, '11:00', '13:20', 'WIB', 'WIB', '');
CALL jadwal_destinasi (4, 'Rabu', '', '', 4.1, 51, 5, '14:15', '16:35', 'WIB', 'WIB', '');
CALL jadwal_destinasi (4, 'Kamis', '', '', 0, 0, 6, '09:00', '10:00', 'WIB', 'WIB', '');
CALL jadwal_destinasi (4, 'Kamis', '', '', 7.2, 25, 7, '10:25', '11:45', 'WIB', 'WIB', '');
CALL jadwal_destinasi (4, 'Kamis', '', '', 3.7, 31, 8, '12:20', '14:40', 'WIB', 'WIB', '');
CALL jadwal_destinasi (4, 'Kamis', '', '', 2.2, 10, 5, '14:50', '17:10', 'WIB', 'WIB', '');
CALL jadwal_destinasi (4, 'Jumat', '', '', 0, 0, 1, '06:00', '08:00', 'WIB', 'WIB', '');
CALL jadwal_destinasi (4, 'Jumat', '', '', 9.5, 30, 2, '08:30', '10:50', 'WIB', 'WIB', '');
CALL jadwal_destinasi (4, 'Jumat', '', '', 7.3, 13, 3, '11:05', '13:25', 'WIB', 'WIB', '');
CALL jadwal_destinasi (4, 'Jumat', '', '', 7, 10, 4, '13:35', '15:55', 'WIB', 'WIB', '');

CALL jadwal_destinasi (5, 'Senin', '', '', 0, 1, 2, '06:00', '08:00', 'WIB', 'WIB', '');
CALL jadwal_destinasi (5, 'Senin', '', '', 4.4, 20, 3, '08:20', '10:40', 'WIB', 'WIB', '');
CALL jadwal_destinasi (5, 'Senin', '', '', 4.9, 19, 4, '11:00', '13:20', 'WIB', 'WIB', '');
CALL jadwal_destinasi (5, 'Senin', '', '', 4.1, 51, 5, '14:15', '16:35', 'WIB', 'WIB', '');
CALL jadwal_destinasi (5, 'Selasa', '', '', 0, 0, 6, '09:00', '10:00', 'WIB', 'WIB', '');
CALL jadwal_destinasi (5, 'Selasa', '', '', 4.4, 20, 7, '10:20', '11:40', 'WIB', 'WIB', '');
CALL jadwal_destinasi (5, 'Selasa', '', '', 4.9, 19, 10, '12:00', '13:20', 'WIB', 'WIB', '');
CALL jadwal_destinasi (5, 'Selasa', '', '', 4.1, 51, 11, '14:15', '16:35', 'WIB', 'WIB', '');
CALL jadwal_destinasi (5, 'Rabu', '', '', 0, 0, 12, '08:00', '09:00', 'WIB', 'WIB', '');
CALL jadwal_destinasi (5, 'Rabu', '', '', 4.4, 20, 13, '09:20', '10:40', 'WIB', 'WIB', '');
CALL jadwal_destinasi (5, 'Rabu', '', '', 4.9, 19, 14, '11:00', '13:20', 'WIB', 'WIB', '');
CALL jadwal_destinasi (5, 'Rabu', '', '', 4.1, 51, 15, '14:15', '15:35', 'WIB', 'WIB', '');
CALL jadwal_destinasi (5, 'Kamis', '', '', 0, 0, 16, '09:00', '10:00', 'WIB', 'WIB', '');
CALL jadwal_destinasi (5, 'Kamis', '', '', 4.4, 20, 17, '10:20', '11:40', 'WIB', 'WIB', '');
CALL jadwal_destinasi (5, 'Kamis', '', '', 4.9, 19, 19, '12:00', '13:20', 'WIB', 'WIB', '');
CALL jadwal_destinasi (5, 'Kamis', '', '', 4.1, 51, 20, '14:15', '16:35', 'WIB', 'WIB', '');

CALL jadwal_destinasi (6, 'Minggu', '', '', 0, 0, 17, '09:00', '11:00', 'WIB', 'WIB', '');
CALL jadwal_destinasi (6, 'Minggu', '', '', 4.4, 20, 18, '11:20', '13:40', 'WIB', 'WIB', '');
CALL jadwal_destinasi (6, 'Minggu', '', '', 4.9, 19, 19, '14:00', '15:20', 'WIB', 'WIB', '');
CALL jadwal_destinasi (6, 'Minggu', '', '', 4.1, 51, 20, '16:15', '17:15', 'WIB', 'WIB', '');
CALL jadwal_destinasi (6, 'Senin', '', '', 0, 0, 2, '09:00', '11:00', 'WIB', 'WIB', '');
CALL jadwal_destinasi (6, 'Senin', '', '', 4.4, 20, 3, '11:20', '13:40', 'WIB', 'WIB', '');
CALL jadwal_destinasi (6, 'Senin', '', '', 4.9, 19, 4, '14:00', '15:20', 'WIB', 'WIB', '');
CALL jadwal_destinasi (6, 'Senin', '', '', 4.1, 51, 5, '16:15', '17:15', 'WIB', 'WIB', '');

CALL jadwal_destinasi (7, 'Minggu', '', '', 0, 0, 17, '09:00', '11:00', 'WIB', 'WIB', '');
CALL jadwal_destinasi (7, 'Minggu', '', '', 4.4, 20, 18, '11:20', '13:40', 'WIB', 'WIB', '');
CALL jadwal_destinasi (7, 'Minggu', '', '', 4.9, 19, 19, '14:00', '15:20', 'WIB', 'WIB', '');
CALL jadwal_destinasi (7, 'Minggu', '', '', 4.1, 51, 20, '16:15', '17:15', 'WIB', 'WIB', '');
CALL jadwal_destinasi (7, 'Senin', '', '', 0, 0, 2, '09:00', '11:00', 'WIB', 'WIB', '');
CALL jadwal_destinasi (7, 'Senin', '', '', 4.4, 20, 3, '11:20', '13:40', 'WIB', 'WIB', '');
CALL jadwal_destinasi (7, 'Senin', '', '', 4.9, 19, 4, '14:00', '15:20', 'WIB', 'WIB', '');
CALL jadwal_destinasi (7, 'Senin', '', '', 4.1, 51, 5, '16:15', '17:15', 'WIB', 'WIB', '');

CALL jadwal_destinasi (8, 'Minggu', '', '', 0, 0, 17, '09:00', '11:00', 'WIB', 'WIB', '');
CALL jadwal_destinasi (8, 'Minggu', '', '', 4.4, 20, 18, '11:20', '13:40', 'WIB', 'WIB', '');
CALL jadwal_destinasi (8, 'Minggu', '', '', 4.9, 19, 19, '14:00', '15:20', 'WIB', 'WIB', '');
CALL jadwal_destinasi (8, 'Minggu', '', '', 4.1, 51, 20, '16:15', '17:15', 'WIB', 'WIB', '');
CALL jadwal_destinasi (8, 'Senin', '', '', 0, 0, 2, '09:00', '11:00', 'WIB', 'WIB', '');
CALL jadwal_destinasi (8, 'Senin', '', '', 4.4, 20, 3, '11:20', '13:40', 'WIB', 'WIB', '');
CALL jadwal_destinasi (8, 'Senin', '', '', 4.9, 19, 4, '14:00', '15:20', 'WIB', 'WIB', '');
CALL jadwal_destinasi (8, 'Senin', '', '', 4.1, 51, 5, '16:15', '17:15', 'WIB', 'WIB', '');

-- (id_jadwaldestinasi, id_paketdestinasi, hari, hari_ke, destinasi_ke, koordinat_berangkat, koordinat_tiba, jarak_tempuh, waktu_tempuh, waktu_sebenarnya, id_destinasi, 
-- jam_mulai, jam_selesai, jam_lokasi, catatan)
-- INSERT INTO jadwal_destinasi
-- VALUES
-- (0, 1, 'Rabu', 1, 1, '', '', 0, 0, 0, 1, '06:00', '08:00', 'WIB', ''),
-- (0, 1, 'Rabu', 1, 2, '', '', 4.4, 20, 40, 2, '08:40', '10:40', 'WIB', ''),
-- (0, 1, 'Rabu', 1, 3, '', '', 4.9, 19, 40, 4, '11:20', '13:20', 'WIB', ''),
-- (0, 1, 'Rabu', 1, 4, '', '', 4.1, 51, 75, 5, '14:35', '16:35', 'WIB', ''),
-- (0, 1, 'Kamis', 2, 1, '', '', 0, 0, 0, 6, '09:00', '10:00', 'WIB', ''),
-- (0, 1, 'Kamis', 2, 2, '', '', 7.2, 25, 45, 7, '10:45', '11:45', 'WIB', ''),
-- (0, 1, 'Kamis', 2, 3, '', '', 3.7, 31, 55, 8, '12:40', '14:40', 'WIB', ''),
-- (0, 1, 'Kamis', 2, 4, '', '', 2.2, 10, 30, 5, '15:10', '17:10', 'WIB', ''),
-- (0, 1, 'Jumat', 3, 1, '', '', 0, 0, 0, 1, '06:00', '08:00', 'WIB', ''),
-- (0, 1, 'Jumat', 3, 2, '', '', 9.5, 30, 50, 2, '08:50', '10:50', 'WIB', ''),
-- (0, 1, 'Jumat', 3, 3, '', '', 7.3, 13, 35, 3, '11:25', '13:25', 'WIB', ''),
-- (0, 1, 'Jumat', 3, 4, '', '', 7, 10, 30, 4, '13:55', '15:55', 'WIB', ''),

-- (0, 3, 'Minggu', 1, 1, '', '', 0, 0, 0, 17, '09:00', '11:00', 'WIB', ''),
-- (0, 3, 'Minggu', 1, 2, '', '', 4.4, 20, 40, 18, '11:40', '13:40', 'WIB', ''),
-- (0, 3, 'Minggu', 1, 3, '', '', 4.9, 19, 40, 19, '14:20', '15:20', 'WIB', ''),
-- (0, 3, 'Minggu', 1, 4, '', '', 4.1, 51, 75, 20, '14:35', '16:35', 'WIB', ''),

-- (0, 2, 'Senin', 1, 1, '', '', 0, 0, 0, 2, '06:00', '08:00', 'WIB', ''),
-- (0, 2, 'Senin', 1, 2, '', '', 4.4, 20, 40, 3, '08:40', '10:40', 'WIB', ''),
-- (0, 2, 'Senin', 1, 3, '', '', 4.9, 19, 40, 4, '11:20', '13:20', 'WIB', ''),
-- (0, 2, 'Senin', 1, 4, '', '', 4.1, 51, 75, 5, '14:35', '16:35', 'WIB', ''),
-- (0, 2, 'Selasa', 2, 1, '', '', 0, 0, 0, 6, '09:00', '10:00', 'WIB', ''),
-- (0, 2, 'Selasa', 2, 2, '', '', 4.4, 20, 40, 7, '10:40', '11:40', 'WIB', ''),
-- (0, 2, 'Selasa', 2, 3, '', '', 4.9, 19, 40, 10, '12:20', '13:20', 'WIB', ''),
-- (0, 2, 'Selasa', 2, 4, '', '', 4.1, 51, 75, 11, '14:35', '16:35', 'WIB', ''),
-- (0, 2, 'Rabu', 3, 1, '', '', 0, 0, 0, 12, '08:00', '09:00', 'WIB', ''),
-- (0, 2, 'Rabu', 3, 2, '', '', 4.4, 20, 40, 13, '09:40', '10:40', 'WIB', ''),
-- (0, 2, 'Rabu', 3, 3, '', '', 4.9, 19, 40, 14, '11:20', '13:20', 'WIB', ''),
-- (0, 2, 'Rabu', 3, 4, '', '', 4.1, 51, 75, 15, '14:35', '15:35', 'WIB', ''),
-- (0, 2, 'Kamis', 4, 1, '', '', 0, 0, 0, 16, '09:00', '10:00', 'WIB', ''),
-- (0, 2, 'Kamis', 4, 2, '', '', 4.4, 20, 40, 17, '10:40', '11:40', 'WIB', ''),
-- (0, 2, 'Kamis', 4, 3, '', '', 4.9, 19, 40, 19, '12:20', '13:20', 'WIB', ''),
-- (0, 2, 'Kamis', 4, 4, '', '', 4.1, 51, 75, 20, '14:35', '16:35', 'WIB', '');


-- Yang perlu diperiksa pada TRIGGER:
-- BEFORE INSERT
-- -> kolom id_destinasi. Pastikan antara kolom hari dan hari pada destinasi tutup tidak sama. Menghindari pemesanan tiket destinasi di hari destinasi tutup.
-- -> kolom hari. Pastikan hari yang diinput berurutan dan tidak melompat. Seperti contoh salah, senin lalu rabu lalu kamis lalu sabtu. 
-- -> kolom hari_ke bisa diotomatiskan berdasarkan hari yang sudah diinputkan.
-- -> kolom waktu_sebenarnya bisa diotomatiskan berdasarkan waktu_tempuh. tambahkankan 20 menit.
-- -> kolom jam_mulai dan jam_selesai. Pastikan tidak tumpang tindih. dan pastikan sesuai dengan jadwal jam layanan destinasi. Contohnya, jangan sampai jam layanan selesai jam 16:00 tapi di jadwal sampai jam 17:00.
-- -> mengotomatiskan bagi 'destinasi_ke' yang bernilai 1 maka jarak_tempuh, waktu_tempuh otomatis 0.

-- AFTER INSERT
-- -> kolom-kolom durasi_wisata, harga, dan total_jarak_tempuh pada tabel paket_destinasi berubah sesuai perhitungan di tabel jadwal_destinasi ini.

-- BEFORE DELETE
-- -> Memastikan bahwa destinasi_ke 1 pada pertengahan nilai hari_ke tidak bisa dihapus. Karena akan berpengaruh pada data hari setelahnya. Yang bisa dilakukan hanyalah update
--    id_destinasi serta insert destinasi-destinasi baru. Jadi, jika ingin menghapus full 1 hari maka hari tersebut harus hari_ke yang terakhir karena setelah hari terakhir
--    tersebut tidak ada data jadwal destinasi lagi.

-- AFTER DELETE
-- -> Menghitung kembali durasi_wisata, harga, dan total_jarak_tempuh pada tabel paket_destinasi saat ada destinasi yang dihapus

-- PROCEDURE DESTINASI KE
-- -> jika destinasi_ke 1 dihapus maka otomatis nilai jarak_tempuh, waktu_tempuh pada destinasi_ke 2 menjadi 0
-- -> Menyesuaikan kembali nilai destinasi_ke agar selalu berurutan 1 2 3 4 5

-- BEFORE UPDATE
-- -> Memastikan yang hanya bisa di-update adalah jarak_tempuh, waktu_tempuh, id_testinasi, jam_mulai, jam_selesai, jam_lokasi, catatan.
-- -> Tidak diijinkan mengubah jarak_tempuh dan waktu_tempuh pada destinasi_ke 1
-- -> Jika waktu_tempuh bertambah, memastikan perubahan pada waktu_tempuh tidak lebih dari durasi berkunjung jam_mulai dan jam_selesai. Serta tidak boleh negatif.
-- -> Memastikan id_destinasi yang diganti masih dalam hari dan jam layanan. Jadi, pemilihan id_destinasi sangat bergantung pada hari, jam_mulai, dan jam_selesai pada nilai kolom yang ada.

-- -> Menjaga konsistensi jadwal pada jam_mulai dan jam_selesai:
-- jam_mulai destinasi_ke 1 bisa mundur dan maju. tetapi majunya tidak boleh lebih dari jam_selesai + 10 mnt. Udah itu saja.

-- jam_selesai destinasi_ke 1 bisa mundur tetapi tidak boleh kurang dari jam_mulai. 
-- Bisa maju tetapi tidak boleh lebih dari durasi berkunjung destinasi setelahnya + 10 mnt. 
-- Saat jam_selesai berubah, maka jam_mulai destinasi setelahnya akan berpengaruh maju ataupun mundur tergantung seberapa banyak perubahan menit jam_selesainya.

-- jam_mulai destinasi_ke 2 bisa mundur tetapi tidak boleh lebih dari durasi berkunjung destinasi sebelumnya + 10 mnt. 
-- Bisa maju tetapi tidak boleh lebih dari jam_selesai + 10 mnt.
-- Saat jam_mulai berubah, maka jam_selesai destinasi sebelumnya akan berpengaruh maju ataupun mundur tergantung seberapa banyak perubahan menit jam_mulainya.

-- jam_selesai destinasi_ke 2 bisa mundur tetapi tidak boleh kurang dari jam_mulai. 
-- Bisa maju tetapi tidak boleh lebih dari durasi berkunjung destinasi setelahnya + 10 mnt. 
-- Saat jam_selesai berubah, maka jam_mulai destinasi setelahnya akan berpengaruh maju ataupun mundur tergantung seberapa banyak perubahan menit jam_selesainya.

-- jam_selesai destinasi_ke terakhir bisa mundur tetapi tidak boleh kurang dari jam_mulai. Udah itu saja.

-- -> TENTUNYA SAAT MENGUBAH jam_mulai dan jam_selesai PASTIKAN MASIH DI DALAM JAM LAYANAN DESTINASI !!!

-- AFTER UPDATE
-- -> Menghitung lagi total_jarak_tempuh pada tabel paket_destinasi akibat perubahan pada jarak_tempuh.
-- -> Menghitung lagi harga pada tabel paket_destinasi akibat perubahan pada id_destinasi.

-- PROCEDURE JAM MULAI DAN JAM SELESAI
-- -> Menyesuaikan maju mundur jam_mulai dan jam_selesai untuk destinasi sebelum maupun sesudah.
-- -> Menghitung lagi waktu_sebenarnya akibat dari perubahan waktu_tempuh.


SELECT paket_destinasi.nama_paket, jadwal_destinasi.hari, jadwal_destinasi.hari_ke, jadwal_destinasi.destinasi_ke, 
destinasi.nama_destinasi, destinasi.harga, 
jadwal_destinasi.jam_mulai, jadwal_destinasi.zona_mulai, jadwal_destinasi.jam_selesai, jadwal_destinasi.zona_selesai
FROM jadwal_destinasi
JOIN paket_destinasi ON jadwal_destinasi.id_paketdestinasi = paket_destinasi.id_paketdestinasi
JOIN destinasi ON jadwal_destinasi.id_destinasi = destinasi.id_destinasi;
