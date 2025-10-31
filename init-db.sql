-- Create databases
CREATE DATABASE IF NOT EXISTS questiondb;
CREATE DATABASE IF NOT EXISTS quizdb;

-- Connect to questiondb and create schema
\c questiondb;

CREATE TABLE IF NOT EXISTS question (
    id SERIAL PRIMARY KEY,
    question_title VARCHAR(500),
    option1 VARCHAR(255),
    option2 VARCHAR(255),
    option3 VARCHAR(255),
    option4 VARCHAR(255),
    right_answer VARCHAR(255),
    category VARCHAR(100),
    difficultylevel VARCHAR(50)
);

-- Connect to quizdb and create schema
\c quizdb;

CREATE TABLE IF NOT EXISTS quiz (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS quiz_questions (
    quiz_id INTEGER REFERENCES quiz(id),
    questions INTEGER
);
