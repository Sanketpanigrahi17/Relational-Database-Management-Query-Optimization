# Relational-Database-Management-Query-Optimization
SQL data Analysis project
Designed and deployed a relational database system (demo_db) consisting of 3 normalized tables — customers, orders, and big_spenders — with primary, foreign, and unique key constraints ensuring data integrity and referential consistency.

Implemented data operations including single and bulk inserts (3+ rows), conditional updates using the UPSERT pattern (ON DUPLICATE KEY UPDATE), and structural modifications via ALTER TABLE to simulate real-world data evolution.

Created aggregate analytical queries using GROUP BY, HAVING, and ORDER BY clauses to compute customer purchase statistics and identify high-value clients with total spend > ₹1000.

Developed complex JOIN operations (INNER, LEFT, RIGHT, CROSS) across tables to efficiently retrieve customer-order relationships from over 100+ potential combinations.

Enhanced query performance by introducing a composite index on (customer_id, order_date), achieving an estimated 40% faster lookup and improved execution efficiency in analytical queries.

Demonstrated complete SQL workflow — from schema creation to data analysis, showcasing strong command of DDL, DML, and DQL operations, normalization, indexing, and query optimization best practices.
