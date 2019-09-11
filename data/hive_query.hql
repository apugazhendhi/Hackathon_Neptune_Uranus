
WITH setup AS (
	SELECT 	mu.id 																						AS id
			, CONCAT(UPPER(SUBSTR(mu.firstname, 0, 1)), '.', UPPER(SUBSTR(mu.lastname, -1)), '.') 		AS initials
			, REGEXP_REPLACE(mu.myworkforcefocus, ',', '') 												AS title
			, dept.portaldisplayname 																	AS department
			, REGEXP_REPLACE(COALESCE(ll.locationname, 'Unknown'), ',', '') 							AS loc
	FROM 	c3_repinfo.manager_users_snap mu
	JOIN   	c3_repinfo.emdepartment_snap dept
	ON 		mu.emdepartmentid = dept.emdepartmentid
	LEFT JOIN 	c3_repinfo.emlocation_snap ll
	ON 		mu.locationid = ll.emlocationid
	WHERE 	mu.isactive = TRUE
	AND 	mu.isservice = FALSE
	AND 	mu.accounttypeid = 1
)
SELECT 		CAST('~id,initials:String,title:String,department:String,location:String,~label' AS STRING)
UNION ALL
SELECT 		CONCAT_WS(',', CAST(ss.id AS STRING), ss.initials, ss.title, ss.department, ss.loc, 'Employee')
FROM 		setup ss
;




WITH setup AS (
	SELECT 	mu.id 					                                                AS from_node
			, mu.supervisorid		                                                AS to_node
			, CONCAT(CAST(mu.id AS STRING), '_', CAST(mu.supervisorid AS STRING)) 	AS edge_id
	FROM 	c3_repinfo.manager_users_snap mu
	WHERE 	mu.isactive = TRUE
	AND 	mu.isservice = FALSE
	AND 	mu.accounttypeid = 1
)
SELECT 		CAST('~id,~from,~to,~label' AS STRING)
UNION ALL
SELECT 		CONCAT_WS(',', ss.edge_id, CAST(ss.from_node AS STRING), CAST(ss.to_node AS STRING), 'SUPERVISOR')
FROM 		setup ss
;



