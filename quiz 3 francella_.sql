
CREATE DATABASE Biblioteca;
USE Biblioteca;

-- 1. ESTRUCTURA 
CREATE TABLE autores (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    nacionalidad VARCHAR(50)
);

CREATE TABLE editoriales (
    id_editorial INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(30),
    pais VARCHAR(50)
);

CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(30)
);

CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(30),
    correo VARCHAR(100),
    fecha_registro DATE
);

CREATE TABLE Libro (
    id_libro INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150),
    id_autor INT,
    id_editorial INT,
    anio_publicacion DATE,
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor),
    FOREIGN KEY (id_editorial) REFERENCES editoriales(id_editorial)
);

CREATE TABLE Libro_categoria (
    id_libro_categoria INT AUTO_INCREMENT PRIMARY KEY,
    id_categoria INT,
    id_libro INT,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria),
    FOREIGN KEY (id_libro) REFERENCES Libro(id_libro)
);

CREATE TABLE Prestamo (
    id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    fecha_prestamo DATE,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

CREATE TABLE Detalle_prestamo (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_prestamo INT,
    id_libro INT,
    fecha_devolucion DATETIME,
    FOREIGN KEY (id_prestamo) REFERENCES Prestamo(id_prestamo),
    FOREIGN KEY (id_libro) REFERENCES Libro(id_libro)
);



INSERT INTO autores (nombre, nacionalidad) VALUES 
('Gabriel García Márquez', 'Colombiano'), ('J.K. Rowling', 'Británica'), 
('George Orwell', 'Británico'), ('Isabel Allende', 'Chilena');

INSERT INTO editoriales (nombre, pais) VALUES 
('Editorial Sudamericana', 'Argentina'), ('Salamandra', 'España'), 
('Penguin Books', 'Reino Unido'), ('Debolsillo', 'México');

INSERT INTO categorias (nombre) VALUES 
('Novela'), ('Fantasía'), ('Distopía'), ('Realismo Mágico');

INSERT INTO usuarios (nombre, correo, fecha_registro) VALUES 
('Juan Pérez', 'juan.perez@email.com', '2024-01-15'),
('María García', 'm.garcia@email.com', '2024-02-10'),
('Carlos López', 'carlos.l@email.com', '2024-03-05');

INSERT INTO Libro (titulo, id_autor, id_editorial, anio_publicacion) VALUES 
('Cien Años de Soledad', 1, 1, '1967-05-30'),
('Harry Potter y la Piedra Filosofal', 2, 2, '1997-06-26'),
('1984', 3, 3, '1949-06-08'),
('La Casa de los Espíritus', 4, 4, '1982-01-01');

INSERT INTO Libro_categoria (id_categoria, id_libro) VALUES 
(1, 1), (4, 1), (2, 2), (1, 3), (3, 3), (1, 4);

INSERT INTO Prestamo (id_usuario, fecha_prestamo) VALUES 
(1, '2024-04-01'), (2, '2024-04-02'), (1, '2024-04-05');

INSERT INTO Detalle_prestamo (id_prestamo, id_libro, fecha_devolucion) VALUES 
(1, 1, '2024-04-10'), (1, 2, NULL), (2, 3, '2024-04-12'), (3, 1, NULL);



-- NIVEL 1 
-- 1. Mostrar todos los libros
SELECT * FROM Libro;

-- 2. Mostrar títulos y años de publicación
SELECT titulo, anio_publicacion FROM Libro;

-- 3. Mostrar usuarios registrados recientemente
SELECT * FROM usuarios ORDER BY fecha_registro DESC;


-- NIVEL 2
-- 4. Mostrar libros con su autor
SELECT Libro.titulo, autores.nombre FROM Libro
INNER JOIN autores ON Libro.id_autor = autores.id_autor;

-- 5. Mostrar libros con su editorial
SELECT Libro.titulo, editoriales.nombre FROM Libro
INNER JOIN editoriales ON Libro.id_editorial = editoriales.id_editorial;

-- 6. Mostrar categorías de cada libro
SELECT Libro.titulo, categorias.nombre FROM Libro
INNER JOIN Libro_categoria ON Libro.id_libro = Libro_categoria.id_libro
INNER JOIN categorias ON Libro_categoria.id_categoria = categorias.id_categoria;


-- NIVEL 3
-- 7. Mostrar todos los préstamos con nombre de usuario y libro
SELECT usuarios.nombre, Libro.titulo, Prestamo.fecha_prestamo
FROM Prestamo
INNER JOIN usuarios ON Prestamo.id_usuario = usuarios.id_usuario
INNER JOIN Detalle_prestamo ON Prestamo.id_prestamo = Detalle_prestamo.id_prestamo
INNER JOIN Libro ON Detalle_prestamo.id_libro = Libro.id_libro;

-- 8. Mostrar libros no devueltos
SELECT Libro.titulo, Detalle_prestamo.fecha_devolucion
FROM Detalle_prestamo
INNER JOIN Libro ON Detalle_prestamo.id_libro = Libro.id_libro
WHERE Detalle_prestamo.fecha_devolucion IS NULL;

-- 9. Mostrar historial completo de préstamos
SELECT usuarios.nombre, Libro.titulo, Prestamo.fecha_prestamo, Detalle_prestamo.fecha_devolucion
FROM Prestamo
INNER JOIN usuarios ON Prestamo.id_usuario = usuarios.id_usuario
INNER JOIN Detalle_prestamo ON Prestamo.id_prestamo = Detalle_prestamo.id_prestamo
INNER JOIN Libro ON Detalle_prestamo.id_libro = Libro.id_libro;


-- NIVEL 4
-- 10. Cantidad de libros por categoría
SELECT categorias.nombre, COUNT(Libro_categoria.id_libro) AS total
FROM categorias
INNER JOIN Libro_categoria ON categorias.id_categoria = Libro_categoria.id_categoria
GROUP BY categorias.nombre;

-- 11. Cantidad de préstamos por usuario
SELECT usuarios.nombre, COUNT(Prestamo.id_prestamo) AS total
FROM usuarios
INNER JOIN Prestamo ON usuarios.id_usuario = Prestamo.id_usuario
GROUP BY usuarios.nombre;

-- 12. Cantidad de libros por editorial
SELECT editoriales.nombre, COUNT(Libro.id_libro) AS total
FROM editoriales
INNER JOIN Libro ON editoriales.id_editorial = Libro.id_editorial
GROUP BY editoriales.nombre;


-- NIVEL 5
-- 13. Usuario con más préstamos
SELECT usuarios.nombre, COUNT(Prestamo.id_prestamo) AS total
FROM usuarios
INNER JOIN Prestamo ON usuarios.id_usuario = Prestamo.id_usuario
GROUP BY usuarios.id_usuario ORDER BY total DESC LIMIT 1;

-- 14. Libro más prestado
SELECT Libro.titulo, COUNT(Detalle_prestamo.id_libro) AS total
FROM Libro
INNER JOIN Detalle_prestamo ON Libro.id_libro = Detalle_prestamo.id_libro
GROUP BY Libro.id_libro ORDER BY total DESC LIMIT 1;

-- 15. Categoría más popular
SELECT categorias.nombre, COUNT(Detalle_prestamo.id_libro) AS total
FROM categorias
INNER JOIN Libro_categoria ON categorias.id_categoria = Libro_categoria.id_categoria
INNER JOIN Detalle_prestamo ON Libro_categoria.id_libro = Detalle_prestamo.id_libro
GROUP BY categorias.id_categoria ORDER BY total DESC LIMIT 1;
