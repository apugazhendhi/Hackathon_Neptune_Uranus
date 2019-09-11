
WITH setup AS (
	SELECT 	mu.id 																						AS id
			, CONCAT(UPPER(SUBSTR(mu.firstname, 0, 1)), '.', UPPER(SUBSTR(mu.firstname, -1)), '.') 		AS initials
			, REGEXP_REPLACE(mu.myworkforcefocus, ',', '') 												AS title
			, dept.portaldisplayname 																	AS department
	FROM 	c3_repinfo.manager_users_snap mu
	JOIN   	c3_repinfo.emdepartment_snap dept
	ON 		mu.emdepartmentid = dept.emdepartmentid
	WHERE 	mu.isactive = TRUE
	AND 	mu.isservice = FALSE
)
SELECT 		CONCAT_WS(',', CAST(ss.id AS STRING), ss.initials, ss.title, ss.department, 'Employee')
FROM 		setup ss
;




WITH setup AS (
	SELECT 	mu.id 					AS from_node
			, CONCAT(CAST(mu.id AS STRING), '_', CAST(mu.supervisorid AS STRING)) 	AS edge_id
			, mu.supervisorid		AS to_node
	FROM 	c3_repinfo.manager_users_snap mu
	WHERE 	mu.isactive = TRUE
	AND 	mu.isservice = FALSE
)
SELECT 		CONCAT_WS(',', ss.edge_id, CAST(ss.from_node AS STRING), CAST(ss.to_node AS STRING), 'SUPERVISOR')
FROM 		setup ss
;

