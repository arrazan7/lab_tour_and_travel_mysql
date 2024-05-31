use lab_tour_and_travel;

CREATE TABLE users (
	id BIGINT AUTO_INCREMENT,
    name VARCHAR(255) UNIQUE NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    email_verified_at TIMESTAMP,
    password VARCHAR(255) NOT NULL,
    user_type VARCHAR(10) DEFAULT('public') CHECK(user_type IN ('public', 'admin')) ,
    foto VARCHAR(255),
    deskripsi TEXT,
    remember_token VARCHAR(100) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

DROP TABLE users;

INSERT INTO users
VALUES
(0, 'kinan', 'Kinanthy Cahyaningrum', 'kinanthycahyaningrum@mail.ugm.ac.id', '', 'rahasia', 'admin', '', '', '', '', ''),
(0, 'risma', 'Risma Saputri', 'rismasaputri@mail.ugm.ac.id', '', 'rahasia', 'admin', '', '', '', '', ''),
(0, 'naufal', 'Naufal Manaf', 'naufalmanaf2004@mail.ugm.ac.id', '', 'rahasia', 'admin', '', '', '', '', ''),
(0, 'fayy', 'Fayyadh Arrazan Miftakhul', 'fayyadharrazanmiftakhul@mail.ugm.ac.id', '', 'rahasia', 'admin', '', '', '', '', ''),
(0, 'ani', 'Bu Ani', 'buani@gmail.com', '', 'rahasia', 'public', '', '', '', '', ''),
(0, 'bambang', 'Pak Bambang', 'pakbambang@gmail.com', '', 'rahasia', 'public', '', '', '', '', ''),
(0, 'cinta', 'Bu Cinta', 'bucinta@gmail.com', '', 'rahasia', 'public', '', '', '', '', '');

INSERT INTO users
VALUES
(0, 'ina', 'Bu Ina', 'ina@gmail.com', '', 'rahasia', 'admin', '', '', '', '', '');
