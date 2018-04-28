CREATE TABLE task (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    title       TEXT,
    description TEXT,
    progress    INTEGER
);

INSERT INTO task (title, description, progress) VALUES ('capstone', 'Capstone project for Inter. Studies', 10);
INSERT INTO task (title, description, progress) VALUES ('IDST 5900', 'Research paper on fascism and women', 0);
INSERT INTO task (title, description, progress) VALUES ('IDST 5002', 'Poster on personality and jobs and stuff', 0);
