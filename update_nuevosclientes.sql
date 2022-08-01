UPDATE cliente 
SET branch_id = 10 WHERE id IN (SELECT TOP (5) id FROM cliente ORDER BY id DESC)