-- =====================================================================
-- Exercise 1 - Blog database: sample data (optional step 3)
-- Run after 01-blog-ddl.sql
-- =====================================================================

USE blog_db;

INSERT INTO authors (id, name) VALUES
    (1, 'Maria Charlotte'),
    (2, 'Juan Perez'),
    (3, 'Gemma Alcocer');

INSERT INTO posts (author_id, title, word_count, views) VALUES
    (1, 'Best Paint Colors',           814,  14),
    (2, 'Small Space Decorating Tips', 1146, 221),
    (1, 'Hot Accessories',             986,  105),
    (1, 'Mixing Textures',             765,  22),
    (2, 'Kitchen Refresh',             1242, 307),
    (1, 'Homemade Art Hacks',          1002, 193),
    (3, 'Refinishing Wood Floors',     1571, 7542);

-- Sanity check: rebuilds the original flat table from the normalized one.
SELECT a.name AS author, p.title, p.word_count, p.views
FROM posts p
JOIN authors a ON p.author_id = a.id
ORDER BY p.id;
