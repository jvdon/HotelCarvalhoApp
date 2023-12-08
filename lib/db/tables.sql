CREATE TABLE reservas(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    quarto STRING,
    checkin DATETIME NOT NULL,
    checkout DATETIME NOT NULL,
    hospedes STRING DEFAULT \ "[]\",preco INTEGER DEFAULT 50,valor INTEGER NOT NULL);

CREATE TABLE quarto(
    id INTEGER PRIMARY KEY,
    number INTEGER,
    status STRING NOT NULL DEFAULT \"pronto\"
);