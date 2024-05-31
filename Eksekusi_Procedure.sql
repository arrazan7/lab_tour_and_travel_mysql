use lab_tour_and_travel;

CALL delete_jadwal_destinasi (OLD.id_paketdestinasi, OLD.hari_ke, OLD.destinasi_ke);
    
CALL delete_jadwal_destinasi (1, 1, 4);
SELECT DISTINCT id_paketdestinasi FROM jadwal_destinasi WHERE id_paketdestinasi = 1;