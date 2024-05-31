use lab_tour_and_travel;

CREATE TABLE tema_destinasi (
	id_temadestinasi INT AUTO_INCREMENT,
    id_destinasi INT NOT NULL,
    id_tema INT NOT NULL,
    PRIMARY KEY (id_temadestinasi),
    FOREIGN KEY (id_destinasi) REFERENCES destinasi(id_destinasi),
    FOREIGN KEY (id_tema) REFERENCES tema(id_tema)
);

-- DROP TABLE tema_destinasi;

INSERT INTO tema_destinasi
VALUES
(0, 1, 2),
(0, 1, 7),
(0, 1, 10),
(0, 2, 2),
(0, 2, 6),
(0, 2, 7),
(0, 2, 11),
(0, 3, 2),
(0, 3, 7),
(0, 3, 10),
(0, 4, 4),
(0, 4, 5),
(0, 4, 6),
(0, 4, 12),
(0, 5, 4),
(0, 5, 5),
(0, 5, 6),
(0, 5, 12),
(0, 6, 4),
(0, 6, 5),
(0, 6, 6),
(0, 6, 12),
(0, 7, 4),
(0, 7, 5),
(0, 7, 6),
(0, 7, 12),
(0, 8, 4),
(0, 8, 6),
(0, 8, 11),
(0, 9, 3),
(0, 9, 6),
(0, 9, 12),
(0, 10, 3),
(0, 10, 6),
(0, 10, 12),
(0, 11, 3),
(0, 11, 6),
(0, 11, 11),
(0, 11, 14);


SELECT * FROM lab_tour_and_travel.tema;