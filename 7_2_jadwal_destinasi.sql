DELIMITER //
CREATE TRIGGER cek_insert_jadwal_destinasi
BEFORE INSERT ON jadwal_destinasi
FOR EACH ROW
BEGIN
	DECLARE last_hari VARCHAR(20);
	DECLARE last_hari_ke INT;
    DECLARE last_jam_mulai TIME;
    DECLARE last_jam_selesai TIME;
    DECLARE jam_mulai_seharusnya TIME;
    DECLARE jam_buka_destinasi TIME;
    DECLARE jam_tutup_destinasi TIME;
    DECLARE hitung_waktu_sebenarnya INT DEFAULT 0;
    DECLARE detect_hari INT;
    DECLARE cek_id_paketdestinasi INT;

    
	SET cek_id_paketdestinasi = (SELECT DISTINCT id_paketdestinasi FROM jadwal_destinasi WHERE id_paketdestinasi = NEW.id_paketdestinasi);
	
	-- Jika id_paketdestinasi belum ada atau sedang menginput id_paketdestinasi yang baru
	IF cek_id_paketdestinasi IS NULL THEN 
		-- 1. Mengatur nilai awal 'hari_ke' ketika 'id_paketdestinasi' yang baru dimasukkan
		SET NEW.hari_ke = 1;
		SET NEW.destinasi_ke = 1;
        SET NEW.jarak_tempuh = 0;
        SET NEW.waktu_tempuh = 0;
        
        -- Menolak input 'jam_mulai' dan 'jam_selesai' yang tumpang tindih
		IF NEW.jam_mulai > NEW.jam_selesai THEN
			SIGNAL SQLSTATE '45003' SET MESSAGE_TEXT = 'Input jam_mulai dan jam_selesai tumpang tindih';
		END IF;
	END IF;
	
	-- Jika sudah ada id_paketdestinasi yang sama di tabel jadwal_destinasi dengan input id_paketdestinasi
	IF NEW.id_paketdestinasi = cek_id_paketdestinasi THEN
		-- 2. Menolak input 'hari' yang tidak berurutan atau tidak sama dengan sebelumnya
		SELECT hari, hari_ke INTO last_hari, last_hari_ke FROM jadwal_destinasi
		WHERE id_paketdestinasi = NEW.id_paketdestinasi ORDER BY hari_ke DESC LIMIT 1;
		SELECT COUNT(hari) INTO detect_hari FROM jadwal_destinasi WHERE id_paketdestinasi = NEW.id_paketdestinasi AND hari = NEW.hari;

		IF (NEW.hari != CASE last_hari
							WHEN 'Senin' THEN 'Selasa'
							WHEN 'Selasa' THEN 'Rabu'
							WHEN 'Rabu' THEN 'Kamis'
							WHEN 'Kamis' THEN 'Jumat'
							WHEN 'Jumat' THEN 'Sabtu'
							WHEN 'Sabtu' THEN 'Minggu'
							WHEN 'Minggu' THEN 'Senin'
							ELSE 'Senin'
							END) AND detect_hari = 0 THEN
				SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Input hari tidak berurutan';
		END IF;
		
		-- 3. Increment 'hari_ke' ketika input 'hari' berubah
		IF detect_hari = 0 THEN
			SET NEW.hari_ke = last_hari_ke + 1;
		END IF;
		IF detect_hari > 0 THEN
			SET NEW.hari_ke = (SELECT hari_ke FROM jadwal_destinasi WHERE id_paketdestinasi = NEW.id_paketdestinasi AND hari = NEW.hari LIMIT 1);
		END IF;
		
		-- 4. Increment 'destinasi_ke' ketika input 'hari' masih sama dan atur ulang ke 1 jika input 'hari' telah berbeda
		IF detect_hari > 0 THEN 
			SET NEW.destinasi_ke = detect_hari + 1;
		END IF;
		IF detect_hari = 0 THEN 
			SET NEW.destinasi_ke = 1;
		END IF;
		
		-- 5. Menolak input jarak_tempuh dan waktu_tempuh bukan 0 pada destinasi_ke 1
		IF NEW.destinasi_ke = 1 AND (NEW.jarak_tempuh != 0 OR NEW.waktu_tempuh != 0) THEN
			SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'Input jarak_tempuh dan waktu_tempuh pada destinasi_ke 1 harus bernilai 0';
		END IF;
		
		-- 6. Menolak input 'jam_mulai' dan 'jam_selesai' yang tumpang tindih
		IF detect_hari > 0 THEN 
			SELECT jam_mulai, jam_selesai INTO last_jam_mulai, last_jam_selesai
			FROM jadwal_destinasi WHERE id_paketdestinasi = NEW.id_paketdestinasi AND hari_ke = NEW.hari_ke AND destinasi_ke = NEW.destinasi_ke - 1;
			IF NEW.jam_mulai < last_jam_selesai OR NEW.jam_selesai < last_jam_mulai OR NEW.jam_mulai > NEW.jam_selesai THEN
				SIGNAL SQLSTATE '45003' SET MESSAGE_TEXT = 'Input jam_mulai dan jam_selesai tumpang tindih';
			END IF;
		END IF;
		
		-- 7. Menolak input 'jarak_tempuh' dan 'waktu_tempuh' bernilai negatif
		IF NEW.jarak_tempuh < 0 OR NEW.waktu_tempuh < 0 THEN
			SIGNAL SQLSTATE '45004' SET MESSAGE_TEXT = 'Input jarak_tempuh atau waktu_tempuh tidak boleh negatif';
		END IF;

		-- 8. Mengotomatiskan nilai waktu_sebenarnya
		IF detect_hari > 0 THEN
			SET hitung_waktu_sebenarnya = NEW.waktu_tempuh;
		END IF;
		IF (hitung_waktu_sebenarnya % 10) < 5 AND (hitung_waktu_sebenarnya % 10) != 0 THEN
			SET hitung_waktu_sebenarnya = hitung_waktu_sebenarnya + (5 - (hitung_waktu_sebenarnya % 10)); -- Membulatkan ke atas jika digit terakhir < 5
		END IF;
		IF (hitung_waktu_sebenarnya % 10) > 5 THEN
			SET hitung_waktu_sebenarnya = hitung_waktu_sebenarnya + (10 - (hitung_waktu_sebenarnya % 10)); -- Membulatkan ke puluhan jika digit terakhir > 5
		END IF;
		SET NEW.waktu_sebenarnya = hitung_waktu_sebenarnya;
		
		-- 9. Memastikan jadwal 'jam_mulai' tidak kurang dari perhitungan waktu_sebenarnya
		IF detect_hari > 0 THEN
			SET jam_mulai_seharusnya = SEC_TO_TIME(TIME_TO_SEC(last_jam_selesai) + (hitung_waktu_sebenarnya * 60));
			IF NEW.jam_mulai < jam_mulai_seharusnya THEN
				SIGNAL SQLSTATE '45005' SET MESSAGE_TEXT = 'Input jam_mulai tidak sesuai dengan perhitungan waktu_tempuh atau waktu_sebenarnya';
			END IF;
		END IF;
	END IF;
	
	-- 10. Menolak input 'hari' yang ada di tabel destinasi_tutup
	IF EXISTS (SELECT 1 FROM destinasi_tutup WHERE id_destinasi = NEW.id_destinasi AND hari_tutup = NEW.hari) THEN
		SIGNAL SQLSTATE '45006' SET MESSAGE_TEXT = 'Destinasi tutup pada hari yang dipilih';
	END IF;
	
	-- 11. Menolak input 'jam_mulai' dan 'jam_selesai' yang destinasinya masih jam tutup
	SELECT jam_buka, jam_tutup INTO jam_buka_destinasi, jam_tutup_destinasi FROM destinasi WHERE id_destinasi = NEW.id_destinasi; 
	IF NEW.jam_mulai < jam_buka_destinasi OR NEW.jam_selesai > jam_tutup_destinasi THEN
		SIGNAL SQLSTATE '45007' SET MESSAGE_TEXT = 'Input jam_mulai dan jam_selesai tidak sesuai dengan jam layanan destinasi';
	END IF;
    
    -- 12. Menolak durasi wisata kurang dari 15 menit
	IF TIME_TO_SEC(NEW.jam_mulai) > (TIME_TO_SEC(NEW.jam_selesai) - 15 * 60) THEN
		SIGNAL SQLSTATE '45023' SET MESSAGE_TEXT = 'Durasi wisata terlalu cepat. Minimal 15 menit';
	END IF;
END;
// DELIMITER;


DELIMITER //
CREATE TRIGGER respon_insert_jadwal_destinasi
AFTER INSERT ON jadwal_destinasi
FOR EACH ROW
BEGIN
	DECLARE durasi_paketwisata INT;
	DECLARE add_harga_wni INT;
	DECLARE add_harga_wna INT;
	DECLARE jaraktempuh_paketwisata DOUBLE;
    
    -- 1. Perhitungan durasi_wisata pada tabel paket_destinasi
    SELECT MAX(hari_ke) INTO durasi_paketwisata 
    FROM jadwal_destinasi 
    WHERE id_paketdestinasi = NEW.id_paketdestinasi 
    GROUP BY id_paketdestinasi;
    UPDATE paket_destinasi SET durasi_wisata = durasi_paketwisata WHERE id_paketdestinasi = NEW.id_paketdestinasi;
    
    -- 2. Perhitungan harga pada tabel paket_destinasi
    SELECT harga_wni, harga_wna INTO add_harga_wni, add_harga_wna FROM destinasi WHERE id_destinasi = NEW.id_destinasi;
    UPDATE paket_destinasi SET harga_wni = harga_wni + add_harga_wni WHERE id_paketdestinasi = NEW.id_paketdestinasi;
    UPDATE paket_destinasi SET harga_wna = harga_wna + add_harga_wna WHERE id_paketdestinasi = NEW.id_paketdestinasi;
    
    -- 3. Perhitungan total_jarak_tempuh pada tabel paket_destinasi
    -- SELECT ROUND(SUM(jadwal_destinasi.jarak_tempuh), 1) INTO jaraktempuh_paketwisata
-- 	FROM jadwal_destinasi
-- 	JOIN paket_destinasi ON jadwal_destinasi.id_paketdestinasi = paket_destinasi.id_paketdestinasi
--     WHERE jadwal_destinasi.id_paketdestinasi = NEW.id_paketdestinasi 
--     GROUP BY paket_destinasi.id_paketdestinasi;
--     UPDATE paket_destinasi SET total_jarak_tempuh = jaraktempuh_paketwisata WHERE id_paketdestinasi = NEW.id_paketdestinasi;
	UPDATE paket_destinasi SET total_jarak_tempuh = ROUND(total_jarak_tempuh + NEW.jarak_tempuh, 1) WHERE id_paketdestinasi = NEW.id_paketdestinasi;
END;
// DELIMITER;


DELIMITER //
CREATE TRIGGER cek_delete_jadwal_destinasi
BEFORE DELETE ON jadwal_destinasi
FOR EACH ROW
BEGIN
    DECLARE last_hari_ke INT;
    DECLARE count_destinasi_ke INT;
    
    SELECT MAX(hari_ke) INTO last_hari_ke
    FROM jadwal_destinasi
    WHERE id_paketdestinasi = OLD.id_paketdestinasi
    GROUP BY id_paketdestinasi;
    SELECT COUNT(destinasi_ke) INTO count_destinasi_ke
    FROM jadwal_destinasi
    WHERE id_paketdestinasi = OLD.id_paketdestinasi AND hari_ke = OLD.hari_ke;
    
    IF OLD.hari_ke != last_hari_ke AND count_destinasi_ke = 1 THEN
		SIGNAL SQLSTATE '45008' SET MESSAGE_TEXT = 'DELETE hari seutuhnya hanya berlaku pada hari terakhir wisata'; -- Verifikasi
    END IF;
END;
// DELIMITER;


DELIMITER //
CREATE TRIGGER respon_delete_jadwal_destinasi
AFTER DELETE ON jadwal_destinasi
FOR EACH ROW
BEGIN
	-- Menghitung kembali durasi, harga, dan jarak_tempuh jika ada jadwal destinasi dihapus.
	DECLARE durasi_paketwisata INT;
	DECLARE deleted_harga_wni INT;
	DECLARE deleted_harga_wna INT;
    
    -- 1. Perhitungan durasi_wisata pada tabel paket_destinasi
    SELECT MAX(hari_ke) INTO durasi_paketwisata 
    FROM jadwal_destinasi 
    WHERE id_paketdestinasi = OLD.id_paketdestinasi 
    GROUP BY id_paketdestinasi;
    UPDATE paket_destinasi SET durasi_wisata = durasi_paketwisata WHERE id_paketdestinasi = OLD.id_paketdestinasi;
    
    -- 2. Perhitungan harga pada tabel paket_destinasi
    SELECT harga_wni, harga_wna INTO deleted_harga_wni, deleted_harga_wna FROM destinasi WHERE id_destinasi = OLD.id_destinasi;
    UPDATE paket_destinasi SET harga_wni = harga_wni - deleted_harga_wni WHERE id_paketdestinasi = OLD.id_paketdestinasi;
    UPDATE paket_destinasi SET harga_wna = harga_wna - deleted_harga_wna WHERE id_paketdestinasi = OLD.id_paketdestinasi;
    
    -- 3. Perhitungan total_jarak_tempuh pada tabel paket_destinasi  
    UPDATE paket_destinasi SET total_jarak_tempuh = ROUND(total_jarak_tempuh - OLD.jarak_tempuh, 1)
    WHERE id_paketdestinasi = OLD.id_paketdestinasi;
END;
// DELIMITER;


DELIMITER //
CREATE TRIGGER cek_update_jadwal_destinasi
BEFORE UPDATE ON jadwal_destinasi
FOR EACH ROW
BEGIN
	DECLARE durasi_berkunjung INT;
    DECLARE durasi_berkunjung_setelahnya INT;
    DECLARE durasi_berkunjung_sebelumnya INT;
    DECLARE perubahan_waktu_tempuh INT;
    DECLARE jam_buka_destinasi TIME;
    DECLARE jam_tutup_destinasi TIME;
    DECLARE last_destinasi_ke INT;

	-- 1. Memastikan yang hanya bisa di-update adalah destinasi_ke, jarak_tempuh, waktu_tempuh, waktu_sebenarnya, id_testinasi, jam_mulai, jam_selesai, jam_lokasi, catatan.
	IF NEW.id_jadwaldestinasi != OLD.id_jadwaldestinasi OR
	NEW.id_paketdestinasi != OLD.id_paketdestinasi OR
    NEW.hari != OLD.hari OR
    NEW.hari_ke != OLD.hari_ke
    THEN
        SIGNAL SQLSTATE '45009'
        SET MESSAGE_TEXT = 'Anda tidak diizinkan untuk mengupdate kolom id_jadwaldestinasi, id_paketdestinasi, hari, dan hari_ke.';
    END IF; 
    
    -- 2. Tidak diijinkan mengubah jarak_tempuh dan waktu_tempuh pada destinasi_ke 1
    IF NEW.destinasi_ke = 1 AND (NEW.jarak_tempuh != OLD.jarak_tempuh OR NEW.waktu_tempuh != OLD.waktu_tempuh) THEN
		SIGNAL SQLSTATE '45010'
        SET MESSAGE_TEXT = 'Tidak diijinkan mengubah jarak_tempuh dan waktu_tempuh pada destinasi_ke 1.';
    END IF; 
    
    -- 3. Menolak input 'jarak_tempuh' bernilai negatif
	IF NEW.jarak_tempuh < 0 THEN
		SIGNAL SQLSTATE '45011' SET MESSAGE_TEXT = 'Update nilai jarak_tempuh tidak boleh negatif';
	END IF; 
    
    -- 4. Jika waktu_tempuh bertambah, memastikan perubahan pada waktu_tempuh tidak lebih dari durasi berkunjung jam_mulai dan jam_selesai. Serta tidak boleh negatif.
    SET durasi_berkunjung = TIME_TO_SEC(TIMEDIFF(OLD.jam_selesai, OLD.jam_mulai)) / 60;
    SET perubahan_waktu_tempuh = NEW.waktu_tempuh - OLD.waktu_tempuh + 10;
    IF NEW.waktu_tempuh < 0 THEN
		SIGNAL SQLSTATE '45012'
        SET MESSAGE_TEXT = 'Update nilai waktu_tempuh tidak boleh negatif.';
    END IF;
    IF perubahan_waktu_tempuh > durasi_berkunjung THEN
		SIGNAL SQLSTATE '45013'
        SET MESSAGE_TEXT = 'Pertambahan nilai pada waktu_tempuh terlalu besar sehingga durasi berkunjung destinasi terlalu cepat.';
    END IF; 
    
    -- 5. Memastikan id_destinasi yang diganti masih dalam hari dan jam layanan. 
    --    Jadi, pemilihan id_destinasi sangat bergantung pada hari, jam_mulai, dan jam_selesai pada nilai kolom yang ada.
    -- Menolak update id_destinasi yang hari layanan tutup berdasarkan di tabel destinasi_tutup
	IF EXISTS (SELECT 1 FROM destinasi_tutup WHERE id_destinasi = NEW.id_destinasi AND hari_tutup = OLD.hari) THEN
		SIGNAL SQLSTATE '45014' SET MESSAGE_TEXT = 'Destinasi tutup pada hari yang dipilih';
	END IF;
	-- Menolak update id_destinasi yang 'jam_mulai' dan 'jam_selesai' nya termasuk jam tutup destinasi
    SET jam_buka_destinasi = (SELECT jam_buka FROM destinasi WHERE id_destinasi = NEW.id_destinasi);
    SET jam_tutup_destinasi = (SELECT jam_tutup FROM destinasi WHERE id_destinasi = NEW.id_destinasi);
	IF OLD.jam_mulai < jam_buka_destinasi OR OLD.jam_selesai > jam_tutup_destinasi THEN
		SIGNAL SQLSTATE '45015' SET MESSAGE_TEXT = 'Input id_destinasi tidak sesuai dengan jam layanan destinasi';
	END IF;
    
    -- 6. Menjaga konsistensi jadwal pada jam_mulai dan jam_selesai:
    SET last_destinasi_ke = (SELECT MAX(destinasi_ke) FROM jadwal_destinasi 
    WHERE id_paketdestinasi = OLD.id_paketdestinasi AND hari = OLD.hari AND hari_ke = OLD.hari_ke ORDER BY hari_ke);
    
    -- TENTUNYA SAAT MENGUBAH jam_mulai dan jam_selesai PASTIKAN MASIH DI DALAM JAM LAYANAN DESTINASI !!!
    SET jam_buka_destinasi = (SELECT jam_buka FROM destinasi WHERE id_destinasi = OLD.id_destinasi);
    SET jam_tutup_destinasi = (SELECT jam_tutup FROM destinasi WHERE id_destinasi = OLD.id_destinasi);
	IF NEW.jam_mulai < jam_buka_destinasi OR NEW.jam_selesai > jam_tutup_destinasi THEN
		SIGNAL SQLSTATE '45016' SET MESSAGE_TEXT = 'Input jam_mulai atau jam_selesai tidak sesuai dengan jam layanan destinasi';
	END IF;
	-- jam_mulai destinasi_ke 1 bisa mundur dan maju. tetapi majunya tidak boleh lebih dari jam_selesai - 10 mnt. Udah itu saja.
    IF OLD.destinasi_ke = 1 THEN
		IF TIME_TO_SEC(NEW.jam_mulai) > (TIME_TO_SEC(OLD.jam_selesai) - 10 * 60) THEN
			SIGNAL SQLSTATE '45017' SET MESSAGE_TEXT = 'jam_mulai pada destinasi_ke 1 terlalu maju sehingga mendekati jam_selesai';
		END IF;
    END IF;
	-- jam_selesai destinasi_ke 1 bisa mundur tetapi tidak boleh kurang dari jam_mulai. 
	-- Bisa maju tetapi tidak boleh lebih dari durasi berkunjung destinasi setelahnya - 10 mnt. 
	-- Saat jam_selesai berubah, maka jam_mulai destinasi setelahnya akan berpengaruh maju ataupun mundur tergantung seberapa banyak perubahan menit jam_selesainya.
    IF OLD.destinasi_ke != last_destinasi_ke THEN
		IF TIME_TO_SEC(NEW.jam_selesai) < (TIME_TO_SEC(OLD.jam_mulai) + 10 * 60) THEN
			SIGNAL SQLSTATE '45018' SET MESSAGE_TEXT = 'jam_selesai terlalu mundur sehingga mendekati jam_mulai';
		END IF;
        SET durasi_berkunjung_setelahnya = (SELECT TIME_TO_SEC(TIMEDIFF(jam_selesai, jam_mulai)) FROM jadwal_destinasi
        WHERE id_paketdestinasi = OLD.id_paketdestinasi AND hari = OLD.hari AND hari_ke = OLD.hari_ke AND destinasi_ke = OLD.destinasi_ke + 1);
        IF TIME_TO_SEC(TIMEDIFF(NEW.jam_selesai, OLD.jam_selesai)) > (durasi_berkunjung_setelahnya - 10 * 60) THEN
			SIGNAL SQLSTATE '45019' SET MESSAGE_TEXT = 'jam_selesai terlalu maju sehingga durasi kunjungan untuk destinasi setelahnya terlalu cepat';
		END IF;
    END IF;
	-- jam_mulai destinasi_ke 2 bisa mundur tetapi tidak boleh lebih dari durasi berkunjung destinasi sebelumnya - 10 mnt. 
	-- Bisa maju tetapi tidak boleh lebih dari jam_selesai - 10 mnt.
    -- Saat jam_mulai berubah, maka jam_selesai destinasi sebelumnya akan berpengaruh maju ataupun mundur tergantung seberapa banyak perubahan menit jam_mulainya.
    IF OLD.destinasi_ke != 1 THEN
		SET durasi_berkunjung_sebelumnya = (SELECT TIME_TO_SEC(TIMEDIFF(jam_selesai, jam_mulai)) FROM jadwal_destinasi
        WHERE id_paketdestinasi = OLD.id_paketdestinasi AND hari = OLD.hari AND hari_ke = OLD.hari_ke AND destinasi_ke = OLD.destinasi_ke - 1);
		IF TIME_TO_SEC(TIMEDIFF(OLD.jam_mulai, NEW.jam_mulai)) > (durasi_berkunjung_sebelumnya - 10 * 60) THEN
			SIGNAL SQLSTATE '45020' SET MESSAGE_TEXT = 'jam_mulai terlalu mundur sehingga durasi kunjungan untuk destinasi sebelumnya terlalu cepat';
		END IF;
        IF TIME_TO_SEC(NEW.jam_mulai) > (TIME_TO_SEC(OLD.jam_selesai) - 10 * 60) THEN
			SIGNAL SQLSTATE '45021' SET MESSAGE_TEXT = 'jam_mulai terlalu maju sehingga mendekati jam_selesai';
		END IF;
    END IF;
	-- jam_selesai destinasi_ke terakhir bisa mundur tetapi tidak boleh kurang dari jam_mulai. Udah itu saja.
    IF OLD.destinasi_ke = last_destinasi_ke THEN
		IF TIME_TO_SEC(NEW.jam_selesai) < (TIME_TO_SEC(OLD.jam_mulai) + 10 * 60) THEN
			SIGNAL SQLSTATE '45022' SET MESSAGE_TEXT = 'jam_selesai destinasi_ke terakhir terlalu mundur sehingga mendekati jam_mulai';
		END IF;
    END IF;
END;
// DELIMITER;


DELIMITER //
CREATE TRIGGER respon_update_jadwal_destinasi
AFTER UPDATE ON jadwal_destinasi
FOR EACH ROW
BEGIN
    DECLARE perbedaan_jarak_tempuh DOUBLE;
    DECLARE perbedaan_harga_wni INT;
    DECLARE perbedaan_harga_wna INT;
    DECLARE harga_lama_wni INT;
    DECLARE harga_baru_wni INT;
    DECLARE harga_lama_wna INT;
    DECLARE harga_baru_wna INT;
    
	-- 1. Menghitung lagi total_jarak_tempuh pada tabel paket_destinasi akibat perubahan pada jarak_tempuh.
    SET perbedaan_jarak_tempuh = ROUND(NEW.jarak_tempuh - OLD.jarak_tempuh, 1);
    UPDATE paket_destinasi SET total_jarak_tempuh = ROUND(total_jarak_tempuh + perbedaan_jarak_tempuh, 1) WHERE id_paketdestinasi = OLD.id_paketdestinasi;
    
	-- 2. Menghitung lagi harga pada tabel paket_destinasi akibat perubahan pada id_destinasi.
    SELECT harga_wni, harga_wna INTO harga_lama_wni, harga_lama_wna FROM destinasi WHERE id_destinasi = OLD.id_destinasi;
    SELECT harga_wni, harga_wna INTO harga_baru_wni, harga_baru_wna FROM destinasi WHERE id_destinasi = NEW.id_destinasi;
    SET perbedaan_harga_wni = harga_baru_wni - harga_lama_wni;
    SET perbedaan_harga_wna = harga_baru_wna - harga_lama_wna;
    UPDATE paket_destinasi SET harga_wni = harga_wni + perbedaan_harga_wni WHERE id_paketdestinasi = OLD.id_paketdestinasi;
    UPDATE paket_destinasi SET harga_wna = harga_wna + perbedaan_harga_wna WHERE id_paketdestinasi = OLD.id_paketdestinasi;
END;
// DELIMITER


-- (id_paketdestinasi, hari, koordinat_berangkat, koordinat_tiba, jarak_tempuh, waktu_tempuh, id_destinasi, jam_mulai, jam_selesai, jam_lokasi, catatan)
-- CALL jadwal_destinasi (1, 'Rabu', '', '', 4.4, 20, 2, '08:40', '10:40', 'WIB', '');
DELIMITER //
CREATE PROCEDURE jadwal_destinasi (
  IN id_paketdestinasi INT,
  IN hari VARCHAR(20),
  IN koordinat_berangkat VARCHAR(100),
  IN koordinat_tiba VARCHAR(100),
  IN jarak_tempuh DOUBLE,
  IN waktu_tempuh INT,
  IN id_destinasi INT,
  IN jam_mulai TIME,
  IN jam_selesai TIME,
  IN zona_mulai char(5),
  IN zona_selesai char(5),
  IN catatan TEXT
)
BEGIN
    INSERT INTO jadwal_destinasi
    VALUES (0, id_paketdestinasi, hari, 0, 0, koordinat_berangkat, koordinat_tiba, jarak_tempuh, waktu_tempuh, 0, 
    id_destinasi, jam_mulai, jam_selesai, zona_mulai, zona_selesai, catatan);
END 
// DELIMITER ;
-- DROP PROCEDURE jadwal_destinasi;


-- Mengurutkan kembali angka destinasi_ke setelah menghapus salah satu baris jadwal destinasi
-- CALL delete_jadwal_destinasi (OLD.id_paketdestinasi, OLD.hari_ke, OLD.destinasi_ke);
DELIMITER //
CREATE PROCEDURE delete_jadwal_destinasi (
  IN proce_id_paketdestinasi INT,
  IN proce_hari_ke INT,
  IN proce_destinasi_ke INT
)
BEGIN
	IF proce_destinasi_ke = 1 THEN
		DELETE FROM jadwal_destinasi
		WHERE id_paketdestinasi = proce_id_paketdestinasi AND 
		hari_ke = proce_hari_ke AND destinasi_ke = 1;
        UPDATE jadwal_destinasi SET jarak_tempuh = 0, waktu_tempuh = 0, waktu_sebenarnya = 0
		WHERE id_paketdestinasi = proce_id_paketdestinasi AND 
		hari_ke = proce_hari_ke AND destinasi_ke = 2;
	ELSE
		DELETE FROM jadwal_destinasi
		WHERE id_paketdestinasi = proce_id_paketdestinasi AND 
		hari_ke = proce_hari_ke AND destinasi_ke = proce_destinasi_ke;
    END IF;
	
    UPDATE jadwal_destinasi SET destinasi_ke = destinasi_ke - 1 
	WHERE id_paketdestinasi = proce_id_paketdestinasi AND hari_ke = proce_hari_ke AND destinasi_ke > proce_destinasi_ke;
END 
// DELIMITER ;
-- DROP PROCEDURE delete_jadwal_destinasi;


-- CALL update_waktu_tempuh (OLD.id_paketdestinasi, OLD.hari_ke, OLD.destinasi_ke, NEW.waktu_tempuh);
DELIMITER //
CREATE PROCEDURE update_waktu_tempuh (
  IN proce_id_paketdestinasi INT,
  IN proce_hari_ke INT,
  IN proce_destinasi_ke INT,
  IN proce_waktu_tempuh TIME
)
BEGIN
	DECLARE hitung_waktu_sebenarnya INT DEFAULT 0;
    DECLARE old_waktu_sebenarnya INT;
    DECLARE old_jam_mulai TIME;
    DECLARE perubahan_waktu_sebenarnya INT;
    
	-- Menghitung lagi waktu_sebenarnya akibat dari perubahan waktu_tempuh.
    -- Mengotomatiskan nilai waktu_sebenarnya
    UPDATE jadwal_destinasi SET waktu_tempuh = proce_waktu_tempuh
	WHERE id_paketdestinasi = proce_id_paketdestinasi AND hari_ke = proce_hari_ke AND destinasi_ke = proce_destinasi_ke;
	SET hitung_waktu_sebenarnya = proce_waktu_tempuh + 20;
	IF (hitung_waktu_sebenarnya % 10) < 5 AND (hitung_waktu_sebenarnya % 10) != 0 THEN
		SET hitung_waktu_sebenarnya = hitung_waktu_sebenarnya + (5 - (hitung_waktu_sebenarnya % 10)); -- Membulatkan ke atas jika digit terakhir < 5
	END IF;
	IF (hitung_waktu_sebenarnya % 10) > 5 THEN
		SET hitung_waktu_sebenarnya = hitung_waktu_sebenarnya + (10 - (hitung_waktu_sebenarnya % 10)); -- Membulatkan ke puluhan jika digit terakhir > 5
	END IF;
    
    SET old_waktu_sebenarnya = (SELECT waktu_sebenarnya FROM jadwal_destinasi 
	WHERE id_paketdestinasi = proce_id_paketdestinasi AND hari_ke = proce_hari_ke AND destinasi_ke = proce_destinasi_ke);
    SET old_jam_mulai = (SELECT jam_mulai FROM jadwal_destinasi 
	WHERE id_paketdestinasi = proce_id_paketdestinasi AND hari_ke = proce_hari_ke AND destinasi_ke = proce_destinasi_ke);
    SET perubahan_waktu_sebenarnya = hitung_waktu_sebenarnya - old_waktu_sebenarnya;
    UPDATE jadwal_destinasi SET waktu_sebenarnya = hitung_waktu_sebenarnya
	WHERE id_paketdestinasi = proce_id_paketdestinasi AND hari_ke = proce_hari_ke AND destinasi_ke = proce_destinasi_ke;
    UPDATE jadwal_destinasi SET jam_mulai = SEC_TO_TIME(TIME_TO_SEC(old_jam_mulai) + (perubahan_waktu_sebenarnya * 60))
	WHERE id_paketdestinasi = proce_id_paketdestinasi AND hari_ke = proce_hari_ke AND destinasi_ke = proce_destinasi_ke;
END
// DELIMITER ;
-- DROP PROCEDURE update_waktu_tempuh;


-- CALL update_jam_mulai (OLD.id_paketdestinasi, OLD.hari_ke, OLD.destinasi_ke, NEW.jam_mulai);
DELIMITER //
CREATE PROCEDURE update_jam_mulai (
  IN proce_id_paketdestinasi INT,
  IN proce_hari_ke INT,
  IN proce_destinasi_ke INT,
  IN proce_jam_mulai TIME
)
BEGIN
    DECLARE old_jam_mulai TIME;
    DECLARE perubahan_jam_mulai INT;
    DECLARE jam_selesai_sebelumnya INT;
    
	-- Saat jam_mulai berubah, maka jam_selesai destinasi sebelumnya akan berpengaruh maju ataupun mundur 
    -- tergantung seberapa banyak perubahan menit jam_mulainya.
    SET old_jam_mulai = (SELECT jam_mulai FROM jadwal_destinasi 
	WHERE id_paketdestinasi = proce_id_paketdestinasi AND hari_ke = proce_hari_ke AND destinasi_ke = proce_destinasi_ke);
    
    UPDATE jadwal_destinasi SET jam_mulai = proce_jam_mulai
	WHERE id_paketdestinasi = proce_id_paketdestinasi AND hari_ke = proce_hari_ke AND destinasi_ke = proce_destinasi_ke;
    IF proce_destinasi_ke != 1 THEN
		SET perubahan_jam_mulai = TIME_TO_SEC(TIMEDIFF(proce_jam_mulai, old_jam_mulai));
		SET jam_selesai_sebelumnya = (SELECT TIME_TO_SEC(jam_selesai) FROM jadwal_destinasi
		WHERE id_paketdestinasi = proce_id_paketdestinasi AND hari_ke = proce_hari_ke AND destinasi_ke = proce_destinasi_ke - 1);
		UPDATE jadwal_destinasi SET jam_selesai = SEC_TO_TIME(jam_selesai_sebelumnya + perubahan_jam_mulai)
		WHERE id_paketdestinasi = proce_id_paketdestinasi AND hari_ke = proce_hari_ke AND destinasi_ke = proce_destinasi_ke - 1;
    END IF;
END
// DELIMITER ;
-- DROP PROCEDURE update_jam_mulai;


-- CALL update_jam_selesai (OLD.id_paketdestinasi, OLD.hari_ke, OLD.destinasi_ke, NEW.jam_selesai);
DELIMITER //
CREATE PROCEDURE update_jam_selesai (
  IN proce_id_paketdestinasi INT,
  IN proce_hari_ke INT,
  IN proce_destinasi_ke INT,
  IN proce_jam_selesai TIME
)
BEGIN
	DECLARE last_destinasi_ke INT;
    DECLARE old_jam_selesai TIME;
    DECLARE perubahan_jam_selesai INT;
    DECLARE jam_mulai_setelahnya INT;
    
    SET last_destinasi_ke = (SELECT MAX(destinasi_ke) FROM jadwal_destinasi 
    WHERE id_paketdestinasi = proce_id_paketdestinasi AND hari_ke = proce_hari_ke ORDER BY hari_ke);
    SET old_jam_selesai = (SELECT jam_selesai FROM jadwal_destinasi 
	WHERE id_paketdestinasi = proce_id_paketdestinasi AND hari_ke = proce_hari_ke AND destinasi_ke = proce_destinasi_ke);
    
    -- Saat jam_selesai berubah, maka jam_mulai destinasi setelahnya akan berpengaruh maju ataupun mundur 
    -- tergantung seberapa banyak perubahan menit jam_selesainya.
    IF proce_destinasi_ke != last_destinasi_ke THEN
		SET perubahan_jam_selesai = TIME_TO_SEC(TIMEDIFF(proce_jam_selesai, old_jam_selesai));
		SET jam_mulai_setelahnya = (SELECT TIME_TO_SEC(jam_mulai) FROM jadwal_destinasi
		WHERE id_paketdestinasi = proce_id_paketdestinasi AND hari_ke = proce_hari_ke AND destinasi_ke = proce_destinasi_ke + 1);
		UPDATE jadwal_destinasi SET jam_mulai = SEC_TO_TIME(jam_mulai_setelahnya + perubahan_jam_selesai)
		WHERE id_paketdestinasi = proce_id_paketdestinasi AND hari_ke = proce_hari_ke AND destinasi_ke = proce_destinasi_ke + 1;
    END IF;
    UPDATE jadwal_destinasi SET jam_selesai = proce_jam_selesai
	WHERE id_paketdestinasi = proce_id_paketdestinasi AND hari_ke = proce_hari_ke AND destinasi_ke = proce_destinasi_ke;
END
// DELIMITER ;
-- DROP PROCEDURE update_jam_selesai;