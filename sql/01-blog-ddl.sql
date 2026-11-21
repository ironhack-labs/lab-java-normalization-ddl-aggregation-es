-- =====================================================================
-- Exercise 1 - Blog database: normalized schema (3NF)
-- Target: MySQL 8.0.16+ (CHECK constraints are enforced from that version)
--
-- Functional dependencies in the raw table:
--   title  -> author, word_count, views   (each row is one post)
--   author is repeated on every post it wrote -> move it to its own table
--
-- Result:
--   authors (id PK, name)
--   posts   (id PK, author_id FK -> authors.id, title, word_count, views)
-- =====================================================================

DROP DATABASE IF EXISTS blog_db;
CREATE DATABASE blog_db;
USE blog_db;

CREATE TABLE authors (
    id   INT          NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT uq_authors_name UNIQUE (name)
);

CREATE TABLE posts (
    id         INT          NOT NULL AUTO_INCREMENT,
    author_id  INT          NOT NULL,
    title      VARCHAR(200) NOT NULL,
    word_count INT          NOT NULL,
    views      INT          NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    CONSTRAINT fk_posts_author FOREIGN KEY (author_id) REFERENCES authors (id),
    CONSTRAINT uq_posts_title UNIQUE (title),
    CONSTRAINT chk_posts_word_count CHECK (word_count > 0),
    CONSTRAINT chk_posts_views CHECK (views >= 0),
    -- Supports the FK and "all posts by author" lookups.
    INDEX idx_posts_author_id (author_id)
);
