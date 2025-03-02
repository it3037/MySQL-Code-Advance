use partitioning;
create table articles(
	id int auto_increment primary key,
    title varchar(255),
    content text,
    fulltext(title,content));
    
select * from articles;
INSERT INTO articles (title, content) VALUES
('Introduction to AI', 'Artificial Intelligence (AI) is transforming industries by automating processes and improving decision-making.'),
('Machine Learning Basics', 'Machine Learning (ML) is a subset of AI that allows systems to learn from data without being explicitly programmed.'),
('Deep Learning Explained', 'Deep Learning is a neural network-based approach in ML that helps in complex decision-making processes.'),
('History of Artificial Intelligence', 'The journey of AI started in the 1950s and has evolved significantly with the advent of deep learning and big data.'),
('Natural Language Processing (NLP)', 'NLP enables machines to understand, interpret, and generate human language effectively.'),
('AI in Healthcare', 'AI is revolutionizing healthcare by enhancing diagnosis accuracy and automating patient care.'),
('Self-Driving Cars and AI', 'Autonomous vehicles rely on AI algorithms to navigate roads safely and efficiently.'),
('AI in Finance', 'Financial institutions use AI for fraud detection, risk assessment, and automated trading.'),
('The Future of AI', 'AI is expected to impact all major industries, from automation to personalized recommendations.'),
('Challenges in AI', 'Despite its benefits, AI faces challenges like bias, ethical concerns, and data privacy issues.');

select * from articles
where MATCH(title,content) against("Challenges in AI");

SELECT * FROM articles 
WHERE MATCH(title, content) AGAINST('AI');


SELECT * FROM articles 
WHERE MATCH(title, content) AGAINST('+AI -Python' IN BOOLEAN MODE);
SELECT * FROM articles 
WHERE MATCH(title, content) AGAINST('+AI -Finance' IN BOOLEAN MODE);

SELECT * FROM articles 
WHERE MATCH(title, content) AGAINST('Future of AI' IN NATURAL LANGUAGE MODE);
SELECT * FROM articles 
WHERE title LIKE '%AI%';
SELECT * FROM articles 
WHERE MATCH(title, content) AGAINST('AI and Machine Learning') 
ORDER BY MATCH(title, content) AGAINST('AI and Machine Learning') DESC 
LIMIT 5;
SELECT * FROM articles ORDER BY title ASC;
SELECT id, title, MATCH(title, content) AGAINST('Deep Learning') AS relevance 
FROM articles 
ORDER BY relevance DESC;

SELECT id, title, MATCH(title, content) AGAINST('Machine Learning') AS relevance 
FROM articles 
ORDER BY relevance DESC;