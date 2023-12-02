CREATE TABLE hospede(id INT PRIMARY KEY,  nome TEXT NOT NULL,  cpf TEXT NOT NULL,  quarto INT NOT NULL,  hospedes INT NOT NULL DEFAULT 1,  entrada DATE NOT NULL,  saida DATE NOT NULL,  valor INT NOT NULL);

CREATE TABLE hospede(
    id INT PRIMARY KEY,
    nome TEXT NOT NULL,
    cpf TEXT NOT NULL,
    quarto INT NOT NULL,
    hospedes INT NOT NULL DEFAULT 1,
    entrada DATE NOT NULL,
    saida DATE NOT NULL,
    valor INT NOT NULL
);