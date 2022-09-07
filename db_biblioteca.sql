CREATE DATABASE IF NOT EXISTS db_biblioteca;

USE db_biblioteca;

CREATE TABLE editora (
	id_editora INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR (45) NOT NULL
);

CREATE TABLE categoria (
	id_categoria INT PRIMARY KEY AUTO_INCREMENT,
	desc_categoria VARCHAR (45) NOT NULL
);

CREATE TABLE autor (
	id_autor INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR (45) NOT NULL,
	sobrenome VARCHAR (45) NOT NULL, 
	nacionalidade VARCHAR (25) NOT NULL, 
	qtd_livro_publicado INT NOT NULL
);

CREATE TABLE livro (
	id_livro INT PRIMARY KEY AUTO_INCREMENT,
	isbn VARCHAR (30) NOT NULL UNIQUE,
	titulo_livro VARCHAR (45) NOT NULL, 
	ano_lancamento YEAR NOT NULL, 
	id_editora INT NOT NULL, 
	id_categoria INT NOT NULL, 
CONSTRAINT fk_id_editora FOREIGN KEY (id_editora) REFERENCES editora (id_editora),
CONSTRAINT fk_id_categoria FOREIGN KEY (id_categoria) REFERENCES categoria (id_categoria)
);


CREATE TABLE livro_autor (
	id_autor INT NOT NULL,
	id_livro INT NOT NULL,
PRIMARY KEY (id_autor, id_livro),
CONSTRAINT fk_id_autor FOREIGN KEY (id_autor) REFERENCES autor (id_autor),
CONSTRAINT fk_id_livro FOREIGN KEY (id_livro) REFERENCES livro (id_livro)
);



CREATE VIEW vw_dados_livro AS 
SELECT 	l.id_livro, l.isbn, l.titulo_livro Livro, l.ano_lancamento,
	e.nome Editora,
        CONCAT(a.nome,' ', a.sobrenome) 'Autor',
        c.desc_categoria Categoria
FROM livro l 
JOIN editora e 
	ON l.id_livro = e.id_editora
JOIN autor a 
	ON l.id_livro = a.id_autor
JOIN categoria c 
	ON l.id_livro = c.id_categoria
;


CREATE VIEW vw_dados_autor AS 
SELECT 	a.id_autor, CONCAT(a.nome, ' ', a.sobrenome) 'Autor', a.nacionalidade, a.qtd_livro_publicado,
	l.id_livro
FROM autor a
JOIN livro l 
	ON a.id_autor = l.id_livro
GROUP BY id_autor 
;



CREATE VIEW vw_livro_editora AS 
SELECT 	e.id_editora, e.nome,
	COUNT(l.id_livro) Quantidade
FROM editora e
INNER JOIN livro l  
	ON l.id_editora = e.id_editora
GROUP BY id_editora
;



CREATE VIEW vw_dados_categoria AS 
SELECT 	c.id_categoria, c.desc_categoria,
	COUNT(l.id_livro) Quantidade
FROM categoria c
INNER JOIN livro l  
	ON l.id_categoria = c.id_categoria
GROUP BY id_categoria
;



DELIMITER \\ 
CREATE FUNCTION fn_maiuscula (texto VARCHAR(200))
RETURNS VARCHAR(200)
READS SQL DATA 
BEGIN
	SET 	texto = REPLACE(texto, 'a', 'A'), texto = REPLACE(texto, 'b', 'B'), texto = REPLACE(texto, 'c', 'C'),
		texto = REPLACE(texto, 'd', 'D'), texto = REPLACE(texto, 'e', 'E'), texto = REPLACE(texto, 'f', 'F'),
		texto = REPLACE(texto, 'g', 'G'), texto = REPLACE(texto, 'h', 'H'), texto = REPLACE(texto, 'i', 'I'),
		texto = REPLACE(texto, 'j', 'J'), texto = REPLACE(texto, 'k', 'K'), texto = REPLACE(texto, 'l', 'L'),
		texto = REPLACE(texto, 'm', 'M'), texto = REPLACE(texto, 'n', 'N'), texto = REPLACE(texto, 'o', 'O'),
		texto = REPLACE(texto, 'n', 'N'), texto = REPLACE(texto, 'o', 'O'), texto = REPLACE(texto, 'p', 'P'),
		texto = REPLACE(texto, 'q', 'Q'), texto = REPLACE(texto, 'r', 'R'),texto = REPLACE(texto, 's', 'S'), 
		texto = REPLACE(texto, 't', 'T'),texto = REPLACE(texto, 'u', 'U'), texto = REPLACE(texto, 'v', 'V'),
		texto = REPLACE(texto, 'w', 'W'), texto = REPLACE(texto, 'x', 'X'), texto = REPLACE(texto, 'y', 'Y'),
		texto = REPLACE(texto, 'z', 'Z'), texto = REPLACE(texto, 'ç', 'Ç');
RETURN texto;

END \\ 
DELIMITER ;

DELIMITER \\ 
CREATE PROCEDURE sp_insert_editora (n_editora VARCHAR (45))
BEGIN 	

	INSERT INTO editora (nome) VALUE (fn_maiuscula(n_editora));
    
END \\

DELIMITER ;

CALL sp_insert_editora ('sabadeira');
CALL sp_insert_editora ('globo');
CALL sp_insert_editora ('record');
CALL sp_insert_editora ('band');
CALL sp_insert_editora ('hbo');
CALL sp_insert_editora ('fox');
CALL sp_insert_editora ('dc');
CALL sp_insert_editora ('marvel');
CALL sp_insert_editora ('universal');
CALL sp_insert_editora ('rede');


 
DELIMITER $$
CREATE PROCEDURE sp_insert_categoria (n_categoria VARCHAR (45))
BEGIN 	

	INSERT INTO categoria (desc_categoria) VALUE (fn_maiuscula(n_categoria));
    
END $$
DELIMITER ;

CALL sp_insert_categoria ('fantasia');
CALL sp_insert_categoria ('auto ajuda');
CALL sp_insert_categoria ('romance');
CALL sp_insert_categoria ('comedia');
CALL sp_insert_categoria ('drama');
CALL sp_insert_categoria ('terror');
CALL sp_insert_categoria  ('suspense');
CALL sp_insert_categoria ('biografia');
CALL sp_insert_categoria ('aventura');
CALL sp_insert_categoria ('infantil');


 
DELIMITER //
CREATE PROCEDURE sp_insert_livro (n_livro VARCHAR(45), isbn_livro VARCHAR (30), 
				 a_livro YEAR , cod_editora INT, cod_categoria INT)

BEGIN 

    INSERT INTO livro (titulo_livro,isbn, ano_lancamento, id_editora, id_categoria)
    VALUES (fn_maiuscula(n_livro), isbn_livro, a_livro, cod_editora, cod_categoria) ;

END//
DELIMITER ;

CALL sp_insert_livro ('Joaozinho amiguinho','123434','1930','2','10');
CALL sp_insert_livro ('A arte de viver','873653','2020','4','2');
CALL sp_insert_livro ('SQL assustador','328283','2022','6','8');
CALL sp_insert_livro ('Caminhos da India','373638','1999','1','3');
CALL sp_insert_livro ('pequeno principe','327282','2008','3','1');
CALL sp_insert_livro ('Um tira muito louco','276535','2016','5','5');
CALL sp_insert_livro ('jornada nas estrela','112434','1987','7','5');
CALL sp_insert_livro ('meu querido amigo jhon','812213','1996','9','6');
CALL sp_insert_livro ('Viva a vida','328228','2020','8','7');
CALL sp_insert_livro ('O mundo depois do Corona','154434','2022','10','9');


 
DELIMITER $$ 
CREATE PROCEDURE sp_insert_autor (n_autor VARCHAR (50), s_autor VARCHAR (50), 
			          nac_autor VARCHAR (25), t_livro INT)
BEGIN 
		INSERT INTO autor (nome, sobrenome,nacionalidade, qtd_livro_publicado)
		VALUES (fn_maiuscula(n_autor),fn_maiuscula(s_autor),fn_maiuscula(nac_autor), t_livro);
        
END $$
DELIMITER ;

CALL sp_insert_autor ('Maria','ferreira','brasileira','2');
CALL sp_insert_autor ('jose','marques','brasileiro','6');
CALL sp_insert_autor ('jesus','alberto', 'judeu', '32');
CALL sp_insert_autor ('thiago','marques','americano','22');
CALL sp_insert_autor ('pedro','rodrigues','africano','5');
CALL sp_insert_autor ('madalena','gonzales','mexicana','15');
CALL sp_insert_autor  ('joana','teofilo','argentina','8');
CALL sp_insert_autor ('joaquim','menezes','australiano','3');
CALL sp_insert_autor ('paulo','roberto','italiano','4');
CALL sp_insert_autor ('fernando','noronha','jamaicano','9');
CALL sp_insert_livro ('SQL da morte','383939','2022','2','10');
CALL sp_insert_livro ('A arte de sofrer','834333','2019','4','2');
CALL sp_insert_livro ('Sofrer no SQL','343483','2021','6','8');
CALL sp_insert_livro ('Carma do SQL','398778','2008','1','3');
CALL sp_insert_livro ('pequeno universo','332555','2008','3','1');
CALL sp_insert_livro ('Um pedacinho do ceu','298744','2017','4','5');
CALL sp_insert_livro ('jornada nas galaxias','134334','1977','7','5');
CALL sp_insert_livro ('meu querido amigo','3426213','1998','9','6');
CALL sp_insert_livro ('Viva a vida adoidado','399228','2005','8','7');
CALL sp_insert_livro ('O mundo parou em 2020','166434','2022','10','9');
CALL sp_insert_livro ('Vou morrer com esse SQL','34428','2005','8','7');
CALL sp_insert_livro ('Testando as TRIGGERS','234234','2021','4','3');

 
DELIMITER $$
CREATE PROCEDURE sp_insert_livro_autor ( autor INT, livro INT )
BEGIN 	

	INSERT INTO livro_autor (id_autor, id_livro) VALUE (autor, livro);
    
END $$
DELIMITER ;

CALL sp_insert_livro_autor ('1', '11');
CALL sp_insert_livro_autor ('1', '12');
CALL sp_insert_livro_autor ('1', '13'); 
CALL sp_insert_livro_autor ('1', '14');
CALL sp_insert_livro_autor ('3', '15');
CALL sp_insert_livro_autor ('2', '16');
CALL sp_insert_livro_autor ('2', '17'); 
CALL sp_insert_livro_autor ('2', '18'); 
CALL sp_insert_livro_autor ('4', '19'); 
CALL sp_insert_livro_autor ('4', '20');
CALL sp_insert_livro_autor ('3', '21');
CALL sp_insert_livro_autor ('2', '22');



DELIMITER //
CREATE TRIGGER tr_atualiza_livros
AFTER INSERT 
ON autor
FOR EACh ROW
	BEGIN
		DECLARE total_livro INT;
		SET total_livro = (SELECT COUNT(id_livro) FROM livro_autor WHERE id_autor =  NEW.id_autor);
        UPDATE autor SET qtd_livro_publicado = total_livro WHERE id_autor = NEW.id_autor;
    END //
DELIMITER ;


-- SELECTs para inserir na TRIGGER
select id_autor, COUNT(id_livro) Quantidade  
from livro_autor
WHERE id_autor = '2'
;

-- testando o contador 
select id_autor, COUNT(id_livro) Quantidade
from livro_autor 
WHERE id_autor = id_autor
GROUP BY id_autor
;




