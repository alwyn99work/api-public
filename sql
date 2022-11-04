CREATE TABLE tb_employees
(
    employee_id int(6) PRIMARY KEY,
    employee_name VARCHAR(255),
    employee_manager_id int(6) NULL
)

Delimiter //
CREATE PROCEDURE InsertEmployee(
	employee_id int(6),
    employee_name VARCHAR(255),
    employee_manager_id int(6)
)
BEGIN
INSERT INTO tb_employees values(employee_id, employee_name, employee_manager_id);
END;
//	
Delimiter ;

TRUNCATE TABLE tb_employees;

CALL InsertEmployee(1,'Mary',null);
CALL InsertEmployee(2,'Fred',1);
CALL InsertEmployee(3,'Mary',2);
CALL InsertEmployee(4,'Vilo',3);
CALL InsertEmployee(5,'Mora',2);
CALL InsertEmployee(6,'Bill',5);
CALL InsertEmployee(7,'John',6);
CALL InsertEmployee(8,'George',1);
CALL InsertEmployee(9,'Chilla',8);
CALL InsertEmployee(10,'Moya',8);
CALL InsertEmployee(11,'Silvy',1);
CALL InsertEmployee(12,'Hans',11);
CALL InsertEmployee(13,'Michael',11);
CALL InsertEmployee(14,'Richard',11);

select employee_id, employee_name, employee_manager_id 
FROM tb_employees;

-- manager name
SELECT DISTINCT 
	child.employee_id AS employee_id, 
	child.employee_name AS employee_name, 
	parent.employee_name AS manager_name
FROM tb_employees child
LEFT JOIN tb_employees parent
ON child.employee_manager_id = parent.employee_id; 

-- path level
WITH RECURSIVE cte_path AS (
	SELECT employee_id,
	    employee_name,
	    employee_manager_id,
	    0 AS path_level
	FROM tb_employees
	WHERE employee_manager_id IS NULL
	UNION ALL
	SELECT child.employee_id,
	    child.employee_name,
	    child.employee_manager_id,
	    (path_level+1) AS path_level
	FROM tb_employees child
	JOIN cte_path
    ON cte_path.employee_id = child.employee_manager_id
)
SELECT 
	cte_path.employee_id as employee_id, 
	cte_path.employee_name as employee_name, 
	cte_path.path_level as path_level
FROM cte_path;

-- level + manajer
WITH RECURSIVE cte_path AS (
	SELECT employee_id,
	    employee_name,
	    employee_manager_id,
	    0 AS path_level
	FROM tb_employees
	WHERE employee_manager_id IS NULL
	UNION ALL
	SELECT child.employee_id,
	    child.employee_name,
	    child.employee_manager_id,
	    (path_level+1) AS path_level
	FROM tb_employees child
	JOIN cte_path
    ON cte_path.employee_id = child.employee_manager_id
)
SELECT 
	cte_path.employee_id as employee_id, 
	cte_path.employee_name as employee_name, 
	parent.employee_name AS manager_name,	
	cte_path.path_level as path_level	
FROM cte_path
LEFT JOIN tb_employees parent
ON cte_path.employee_manager_id = parent.employee_id 
ORDER BY path_level;

-- with format
WITH RECURSIVE cte_path AS (
	SELECT
		employee_id,
	    employee_name,
	    employee_manager_id,
	    0 AS path_level,
	    CAST(employee_id as CHAR(20)) AS order_sequence,
	    employee_name AS path_hierarchy
	FROM tb_employees
	WHERE employee_manager_id IS NULL
	UNION ALL
	SELECT
		child.employee_id,
	    child.employee_name,
	    child.employee_manager_id,
	    (path_level+1) AS path_level,
	    CONCAT(
			CAST(
		    	order_sequence as CHAR(20)
		    ),
		    '_',
		    CAST(child.employee_id as CHAR(20))
	    ) AS order_sequence,
		CONCAT(
		    path_hierarchy,
		    '->',
		    child.employee_name
	    ) AS path_hierarchy
	FROM tb_employees child
	JOIN cte_path
    ON cte_path.employee_id = child.employee_manager_id
)
SELECT
	*,
-- 	employee_id,
	CONCAT(
		RIGHT('|___',path_level), employee_name
	) AS employee_format
FROM cte_path
ORDER BY employee_id asc;


