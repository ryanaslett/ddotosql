SELECT * FROM project_dependency_component pdc
LEFT JOIN project_dependency_dependency pdd on pdd.component_id = pdc.component_id
WHERE pdc.name LIKE 'viewsref%';

SELECT * FROM field_data_comment_body


SELECT FROM_UNIXTIME(pt.last_tested), pt.last_tested
FROM pift_test pt
ORDER BY pt.last_tested DESC;

SELECT FROM_UNIXTIME(pd.last_tested, '%Y-%m') as yearmonth, pd.*
FROM pift_data pd

HAVING `yearmonth` = '2014-12'
ORDER BY pd.last_tested DESC


SELECT COUNT(*) AS `Jobs`, pcj.status FROM pift_ci_job pcj GROUP BY pcj.status;


SELECT * FROM field_data_comment_body fdcb
WHERE fdcb.comment_body_value LIKE '%<a href="https://groups.drupal.org/node/515932">Drupal 8.3.0-alpha1</a> will be released the week of January 30, 2017, which means new developments and disruptive changes should now be targeted against the 8.4.x-dev branch. For more information see the <a href="/core/release-cycle-overview#minor">Drupal 8 minor version schedule</a> and the <a href="/core/d8-allowed-changes">Allowed changes during the Drupal 8 release cycle</a>.%';

UPDATE field_data_comment_body fdcb SET fdcb.comment_body_value = '<a href="https://groups.drupal.org/node/515932">Drupal 8.3.0-alpha1</a> will be released the week of January 30, 2017, which means new developments and disruptive changes should now be targeted against the 8.4.x-dev branch. For more information see the <a href="/core/release-cycle-overview#minor">Drupal 8 minor version schedule</a> and the <a href="/core/d8-allowed-changes">Allowed changes during the Drupal 8 release cycle</a>.'
WHERE fdcb.comment_body_value = '<a href="https://groups.drupal.org/node/515932">Drupal 8.3.0-alpha1</a> will be released the week of January 30, 2016, which means new developments and disruptive changes should now be targeted against the 8.4.x-dev branch. For more information see the <a href="/core/release-cycle-overview#minor">Drupal 8 minor version schedule</a> and the <a href="/core/d8-allowed-changes">Allowed changes during the Drupal 8 release cycle</a>.';

UPDATE field_revision_comment_body frcb SET frcb.comment_body_value = '<a href="https://groups.drupal.org/node/515932">Drupal 8.3.0-alpha1</a> will be released the week of January 30, 2017, which means new developments and disruptive changes should now be targeted against the 8.4.x-dev branch. For more information see the <a href="/core/release-cycle-overview#minor">Drupal 8 minor version schedule</a> and the <a href="/core/d8-allowed-changes">Allowed changes during the Drupal 8 release cycle</a>.'
WHERE frcb.comment_body_value = '<a href="https://groups.drupal.org/node/515932">Drupal 8.3.0-alpha1</a> will be released the week of January 30, 2016, which means new developments and disruptive changes should now be targeted against the 8.4.x-dev branch. For more information see the <a href="/core/release-cycle-overview#minor">Drupal 8 minor version schedule</a> and the <a href="/core/d8-allowed-changes">Allowed changes during the Drupal 8 release cycle</a>.'

EXPLAIN
SELECT COUNT(*) FROM cache_field;

SELECT * FROM cache_field cf where cf.cid LIKE 'field:comment%' and cf.data LIKE '%will be released the week of January 30, 2016, which means new developments and%';
SELECT * FROM cache_field cf where cid = 'field:comment:11891961';

DELETE cf FROM cache_field cf where cf.cid LIKE 'field:comment%' and cf.data LIKE '%will be released the week of January 30, 2016, which means new developments and%';


DELETE cf FROM cache_field cf WHERE cid LIKE 'field:comment%';

SELECT pcj.message, pcj.build_details, pcj.*
FROM pift_ci_job pcj
WHERE pcj.build_details IS NOT NULL AND pcj.build_details != '';

SELECT * FROM file_managed
WHERE filename LIKE '%2752511%';

SELECT FROM_UNIXTIME(release_node.created), release_node.title, release_node.created, release_node.changed, fdfrv.field_release_version_value, vo.*

SELECT DISTINCT(fdfpmn.field_project_machine_name_value)
FROM node release_node
  LEFT JOIN field_data_field_release_project fdfrp ON fdfrp.entity_id = release_node.nid
  LEFT JOIN field_data_field_project_machine_name fdfpmn on fdfpmn.entity_id = fdfrp.field_release_project_target_id
  LEFT JOIN field_data_field_release_build_type fdfrbt ON fdfrbt.entity_id = release_node.nid
  LEFT JOIN field_data_field_packaged_git_sha1 fdfpgs1 ON fdfpgs1.entity_id = release_node.nid
  LEFT JOIN versioncontrol_operations vo ON vo.revision = fdfpgs1.field_packaged_git_sha1_value
  LEFT JOIN field_data_field_release_version fdfrv ON fdfrv.entity_id = release_node.nid
WHERE release_node.type = 'project_release'
  -- AND release_node.title LIKE 'shell%'
  AND fdfrv.field_release_version_value REGEXP '^8.x|^7.x'

AND  fdfrbt.field_release_build_type_value = 'dynamic'
  AND release_node.created > 1484549307
AND vo.author_date < release_node.created;

SELECT * from package;

SELECT * from users where mail = 'israel.morales@rocket.com.mx';

UPDATE project_issue_notification_global ping SET ping.level = 1 WHERE ping.level = 2;

SELECT * FROM project_issue_notification_global ping where ping.level = 2;

SELECT * from versioncontrol_item_revisions vir
  LEFT JOIN versioncontrol_project_projects vpp on vpp.repo_id = vir.repo_id
  LEFT JOIN field_data_field_project_machine_name fdfpmn ON fdfpmn.entity_id = vpp.nid
WHERE vir.path LIKE '/.eslint%';

SELECT * FROM project_usage_week_project puwp
LEFT JOIN node n on n.nid = puwp.nid
WHERE n.type = 'project_theme'

UPDATE pift_ci_job pcj SET pcj.message= 'Queued', pcj.status = 'sent'
WHERE pcj.message LIKE 'CI job missing' and pcj.job_id > 613000;

select *
show tables;

use information_schema;
SELECT
  table_schema as `Database`,
  table_name AS `Table`,
  round(((data_length + index_length) / 1024 / 1024), 2) `Size in MB`
FROM information_schema.TABLES
ORDER BY (data_length + index_length) DESC;

use drupal;
SELECT COUNT(*) as `Rows`, pcjc.* from pift_ci_job_checkstyle pcjc GROUP BY job_id
ORDER BY `Rows` DESC;

SELECT COUNT(*) as `Rows` from pift_ci_job_checkstyle;

SELECT FROM_UNIXTIME(MAX(pd.last_tested)) FROM pift_data pd

SELECT FROM_UNIXTIME(MAX(ua.access)) FROM users_access ua;
SELECT FROM_UNIXTIME(MAX(voc.updated)) FROM views_object_cache voc;
SELECT FROM_UNIXTIME(MAX(vcc.timestamp)) FROM views_content_cache vcc;


SELECT * from drupalorg_comment_deleted;

SELECT FROM_UNIXTIME(dcd.created) from drupalorg_comment_deleted dcd;

#number of nodes unpublished per dat
SELECT COUNT(*), FROM_UNIXTIME(tn.changed, '%Y-%m-%d') as day
FROM tracker_node tn
where published = 0
GROUP BY day;

SELECT COUNT(*), FROM_UNIXTIME(tu.changed, '%Y-%m-%d') as day
FROM tracker_user tu
where published = 0
GROUP BY day;

SELECT * , FROM_UNIXTIME(tu.changed, '%Y-%m-%d') as day
FROM tracker_user tu
where published = 0
HAVING day = '2017-02-26';

SELECT COUNT(*) as `Counts`, c.status from comment c GROUP BY c.status;

SELECT FROM_UNIXTIME(c.created, '%Y-%m-%d') as `Day`, c.*
from comment c where c.status = 0;

SELECT count(*) from sessions;

SELECT a.module, count(*) as `rows` FROM authmap a GROUP BY a.module


SELECT FROM_UNIXTIME(pcj.created), pcj.environment, pcj.target_type, pcj.*
FROM pift_ci_job pcj
  LEFT JOIN versioncontrol_release_labels vrl ON vrl.release_nid = pcj.release_nid
  LEFT JOIN versioncontrol_labels vl on vl.label_id = vrl.label_id
WHERE vrl.project_nid = 3060
      AND vrl.label_id != 60
      AND pcj.created > 1488672239
  -- AND pcj.reason ='@commit_id pushed to Git.'
     AND pcj.target_type = 'file'
ORDER BY pcj.job_id DESC;

SELECT COUNT(*) as types , FROM_UNIXTIME(pcj.created, '%Y%m%d') as `datelabel`,  pcj.reason, vl.name, vrl.*, pcj.*
FROM pift_ci_job pcj
  LEFT JOIN versioncontrol_release_labels vrl ON vrl.release_nid = pcj.release_nid
  LEFT JOIN versioncontrol_labels vl on vl.label_id = vrl.label_id
WHERE vrl.project_nid = 3060
  AND vrl.label_id != 60
  AND pcj.created > 1488672239
GROUP BY pcj.reason, `datelabel`, vrl.project_nid, vrl.label_id
ORDER BY pcj.job_id DESC;

SELECT COUNT(*) as `environments`, fdfpmn.field_project_machine_name_value, vl.name, vl.type, pcp.testing, jobcount.Jobs
FROM pift_ci_project pcp
  LEFT JOIN versioncontrol_release_labels vrl on vrl.release_nid = pcp.release_nid
  LEFT JOIN versioncontrol_labels vl ON vl.label_id = vrl.label_id
  LEFT JOIN field_data_field_project_machine_name fdfpmn on fdfpmn.entity_id = vrl.project_nid
  LEFT JOIN ( SELECT COUNT(*) as `Jobs`, pcj.release_nid
    FROM pift_ci_job pcj
      WHERE pcj.target_type = 'file'
    GROUP BY pcj.release_nid

    ) AS jobcount ON jobcount.release_nid = pcp.release_nid
  WHERE testing = 'issue'
GROUP BY pcp.release_nid, pcp.nid, pcp.testing;

SELECT * from pift_ci_project pcp WHERE pcp.nid = 11627;

SELECT * from pift_ci_project pcp WHERE core_branch = '8.1.x'

SELECT pcp.environment, fdfpmn.field_project_machine_name_value, vl.name, vl.type, pcp.testing
FROM pift_ci_project pcp
  LEFT JOIN versioncontrol_release_labels vrl on vrl.release_nid = pcp.release_nid
  LEFT JOIN versioncontrol_labels vl ON vl.label_id = vrl.label_id
  LEFT JOIN field_data_field_project_machine_name fdfpmn on fdfpmn.entity_id = vrl.project_nid
-- GROUP BY pcp.release_nid, pcp.nid, pcp.testing

SELECT COUNT(*) as `duples`
FROM pift_ci_project pcp;

SELECT FROM_UNIXTIME(MAX(dgpl.timestamp)) FROM drupalorg_git_push_log dgpl
SELECT FROM_UNIXTIME(MAX(dic.updated)) FROM drupalorg_ind_civimembership dic
SELECT FROM_UNIXTIME(MAX(dig.updated)) FROM drupalorg_org_civimembership dig

SELECT FROM_UNIXTIME(n.created), n.*, GROUP_CONCAT(r.name), GROUP_CONCAT(r.rid)
  FROM node n
  LEFT JOIN field_data_field_project_type fdfpt ON fdfpt.entity_id = n.nid
  LEFT JOIN users u ON n.uid = u.uid
    LEFT JOIN users_roles ur on ur.uid = u.uid
    LEFT JOIN role r on r.rid = ur.rid
where (n.type = 'project_module' OR n.type = 'project_theme') AND fdfpt.field_project_type_value = 'full'

  GROUP BY n.nid
ORDER BY nid DESC;

SELECT FROM_UNIXTIME(n.created), n.*
FROM node n
  LEFT JOIN field_data_field_project_type fdfpt ON fdfpt.entity_id = n.nid
  LEFT JOIN users u ON n.uid = u.uid
where (n.type = 'project_module' OR n.type = 'project_theme') AND fdfpt.field_project_type_value = 'full'
      AND u.uid NOT IN (SELECT ur.uid FROM users_roles ur WHERE ur.rid = 24)
GROUP BY n.nid
ORDER BY nid DESC;

SELECT FROM_UNIXTIME(n.created), FROM_UNIXTIME(n.changed), n.*, GROUP_CONCAT(r.name), GROUP_CONCAT(r.rid), GROUP_CONCAT(pm.uid)
FROM node n
  LEFT JOIN field_data_field_project_type fdfpt ON fdfpt.entity_id = n.nid
  LEFT JOIN project_maintainer pm on pm.nid = n.nid
  LEFT JOIN users u ON n.uid = u.uid
  LEFT JOIN users_roles ur on ur.uid = u.uid
  LEFT JOIN role r on r.rid = ur.rid
where (n.type = 'project_module' OR n.type = 'project_theme') AND fdfpt.field_project_type_value = 'full'
      AND u.uid NOT IN (SELECT ur.uid FROM users_roles ur WHERE ur.rid = 24)
GROUP BY n.nid
ORDER BY nid DESC;


SELECT CONCAT('https://www.drupal.org/node/', n.nid), FROM_UNIXTIME(n.created), FROM_UNIXTIME(n.changed), ttd.name AS `Maintenance Status`, n.type, n.nid, n.title, GROUP_CONCAT(pm.uid) AS `Maintainer UIDs`, GROUP_CONCAT(ur.rid) as `Roles`
FROM node n
  LEFT JOIN field_data_field_project_type fdfpt ON fdfpt.entity_id = n.nid
  LEFT JOIN project_maintainer pm ON pm.nid = n.nid
  LEFT JOIN users_roles ur ON ur.uid = pm.uid AND ur.rid = 24
  LEFT JOIN field_data_taxonomy_vocabulary_44 fdtv44 ON fdtv44.entity_id = n.nid
  LEFT JOIN taxonomy_term_data ttd ON ttd.tid = fdtv44.taxonomy_vocabulary_44_tid

where (n.type = 'project_module' OR n.type = 'project_theme') AND fdfpt.field_project_type_value = 'full'
  AND n.status = 1
  AND ttd.tid IN (13028,19370,9990,9992)
GROUP BY n.nid
HAVING `Roles` IS NULL
ORDER BY nid DESC;

SELECT DISTINCT pm.uid
FROM project_maintainer pm
  LEFT JOIN users_roles ur ON ur.uid = pm.uid
WHERE ur.rid = 24;


-- ur.rid = 24;

SHOW FULL FIELDS FROM flag

SELECT c.table_name, c.COLUMN_NAME, c.data_type, c.CHARACTER_MAXIMUM_LENGTH, c.CHARACTER_SET_NAME, c.COLLATION_NAME, t.TABLE_COLLATION, c.COLUMN_TYPE, c.COLUMN_KEY
FROM COLUMNS c
LEFT JOIN TABLES t on t.TABLE_NAME = c.TABLE_NAME
WHERE t.TABLE_SCHEMA = 'drupal'
AND t.TABLE_COLLATION != c.COLLATION_NAME;

use drupal;
SELECT CONCAT('https://www.drupal.org/node/', n.nid), FROM_UNIXTIME(n.created), FROM_UNIXTIME(n.changed), ttd.name AS `Maintenance Status`, n.type, n.nid, n.title, GROUP_CONCAT(pm.uid) AS `Maintainer UIDs`, GROUP_CONCAT(ur.rid) as `Roles`
FROM node n
LEFT JOIN field_data_field_project_type fdfpt ON fdfpt.entity_id = n.nid
LEFT JOIN project_maintainer pm ON pm.nid = n.nid
LEFT JOIN users_roles ur ON ur.uid = pm.uid AND ur.rid = 24
LEFT JOIN field_data_taxonomy_vocabulary_44 fdtv44 ON fdtv44.entity_id = n.nid
LEFT JOIN taxonomy_term_data ttd ON ttd.tid = fdtv44.taxonomy_vocabulary_44_tid

where (n.type = 'project_module' OR n.type = 'project_theme') AND fdfpt.field_project_type_value = 'full'
AND n.status = 1
AND ttd.tid IN (13028,19370,9990,9992)
GROUP BY n.nid
HAVING `Roles` IS NULL
ORDER BY nid DESC;

SELECT DISTINCT fdtv6.taxonomy_vocabulary_6_tid, fdfpmn.field_project_machine_name_value, puwp.count, pdc.composer
FROM project_dependency_component pdc
  LEFT JOIN field_data_field_release_project fdfrp ON fdfrp.entity_id = pdc.release_nid
  LEFT JOIN field_data_taxonomy_vocabulary_6 fdtv6 ON fdtv6.entity_id = pdc.release_nid
  LEFT JOIN field_data_field_project_machine_name fdfpmn ON fdfpmn.entity_id = fdfrp.field_release_project_target_id
  LEFT JOIN project_usage_week_project puwp on puwp.nid = fdfrp.field_release_project_target_id
WHERE LENGTH(pdc.composer) > 1
      AND taxonomy_vocabulary_6_tid > 103
      AND pdc.composer LIKE '%require"%'
      AND pdc.composer NOT LIKE '%"require": { }%'
      AND pdc.composer NOT LIKE '%"require": {}%'
      AND puwp.timestamp = 1488672000;

SELECT MAX(timestamp) FROM project_usage_week_project;

SELECT DISTINCT fdtv6.taxonomy_vocabulary_6_tid, fdfpmn.field_project_machine_name_value
FROM project_dependency_component pdc
  LEFT JOIN field_data_field_release_project fdfrp ON fdfrp.entity_id = pdc.release_nid
  LEFT JOIN field_data_taxonomy_vocabulary_6 fdtv6 ON fdtv6.entity_id = pdc.release_nid
  LEFT JOIN field_data_field_project_machine_name fdfpmn ON fdfpmn.entity_id = fdfrp.field_release_project_target_id
  L
WHERE taxonomy_vocabulary_6_tid > 103

SELECT * FROM pift_ci_job pcj
WHERE pcj.job_id = 621874;

SELECT MAX(LENGTH(pcjr.error)), pcjr.job_result_id FROM pift_ci_job_result pcjr WHERE pcjr.job_id = 621874;

SELECT * from pift_ci_job_result pcjr where pcjr.job_id = 621874 AND LENGTH(pcjr.error) > 6258223 ;

SELECT COUNT(*) from sessions;

SELECT FROM_UNIXTIME(u.login, '%Y-%m-%d'), FROM_UNIXTIME(u.access, '%Y-%m-%d') from users u
ORDER BY u.login DESC

SELECT * from field_data_field_release_vcs_label fdfrvl
LEFT JOIN field_data_field_release_project fdfrp ON fdfrp.entity_id = fdfrvl.entity_id
WHERE fdfrp.field_release_project_target_id = 3060;


SELECT FROM_UNIXTIME(u.created, '%Y%m%d') as `DayofYear`, COUNT(*) as `Unconfirmed Users Per Week`
FROM users u
  LEFT JOIN users_roles ur ON ur.uid = u.uid AND ur.rid = 36
WHERE ur.rid IS NULL
  AND u.status = 0
  AND FROM_UNIXTIME(u.created, '%Y') > 2011
  GROUP BY `DayofYear`;

SELECT u.*, FROM_UNIXTIME(u.created, '%Y') as `Year`
FROM users u
  LEFT JOIN users_roles ur ON ur.uid = u.uid AND ur.rid = 36
WHERE ur.rid IS NULL
  HAVING `Year` = 2017


SELECT FROM_UNIXTIME(u.created, '%Y%m%d') as `DayofYear`, COUNT(*) as `Confirmed Users Per Day`
FROM users u
  LEFT JOIN users_roles ur ON ur.uid = u.uid AND ur.rid = 36
GROUP BY `DayofYear`;


SELECT COUNT(*), pcj.target_type from pift_ci_job pcj
GROUP BY pcj.target_type;

-- Counts of tests by status
SELECT COUNT(*), pcj.status from pift_ci_job pcj
GROUP BY pcj.status;

SELECT COUNT(*), pcj.reason from pift_ci_job pcj
GROUP BY pcj.reason;

SELECT COUNT(*), pcj.release_nid, release_node.title from pift_ci_job pcj
  LEFT JOIN node release_node ON release_node.nid = pcj.release_nid
WHERE pcj.target_type = 'branch'
GROUP BY pcj.release_nid;

-- Number of branch tests older than 30 days
SELECT COUNT(*),FROM_UNIXTIME(pcj.updated, '%Y%m%d'), pcj.* from pift_ci_job pcj where pcj.target_type = 'branch'
and pcj.updated < UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL 30 DAY));

-- Number of file tests older than 30 days
SELECT COUNT(*),FROM_UNIXTIME(pcj.updated, '%Y%m%d'), pcj.* from pift_ci_job pcj where pcj.target_type = 'file'
and pcj.updated < UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL 30 DAY));

SELECT COUNT(*), FROM_UNIXTIME(pcj.updated, '%Y%m%d'), pcj.* from pift_ci_job pcj where pcj.target_type = 'file'
GROUP BY pcj.issue_nid, pcj.file_id,pcj.environment;

SELECT FROM_UNIXTIME(pcj.updated, '%Y%m%d'), pcj.* from pift_ci_job pcj where pcj.target_type = 'branch'
and pcj.updated < UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL 30 DAY));

SELECT FROM_UNIXTIME(pcj.updated, '%Y%m%d'), pcj.* from pift_ci_job pcj where pcj.target_type = 'file'
                                                                             and pcj.updated < UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL 30 DAY));

select * from pift_ci_job pcj
WHERE pcj.status = 'sent';

select * from pift_ci_job pcj
WHERE pcj.status = 'queued';

select * from pift_ci_job pcj
WHERE pcj.status = 'error';

select * from pift_ci_job pcj
WHERE pcj.status = 'running';

UPDATE pift_ci_job pcj SET pcj.message= 'Queueing', pcj.status = 'queued'
WHERE pcj.status = 'error' and pcj.message LIKE 'CI job missing';

UPDATE pift_ci_job pcj SET pcj.message= 'Queueing', pcj.status = 'queued', pcj.ci_url = ''
WHERE pcj.message LIKE 'CI aborted' and pcj.job_id > 640000;

UPDATE pift_ci_job pcj SET pcj.message= 'Queueing', pcj.status = 'queued'
WHERE pcj.status = 'sent';

UPDATE pift_ci_job pcj SET pcj.message= 'Queueing', pcj.status = 'queued'
WHERE pcj.status = 'error' and pcj.message = 'CI aborted';

UPDATE pift_ci_job pcj SET pcj.message= 'Queueing', pcj.status = 'queued'
WHERE pcj.status = 'error' and pcj.message = 'CI job missing' and pcj.job_id = 641537;

UPDATE pift_ci_job pcj SET pcj.message= 'CI job missing', pcj.status = 'error'
WHERE pcj.status = 'queued' and pcj.job_id < 640052;;
select * from pift_ci_job pcj;

SELECT COUNT(*), pcj.status  from pift_ci_job pcj
WHERE pcj.status IN ('queued','running','sent')
GROUP BY pcj.status;

SELECT COUNT(*), pcj.status, pcj.issue_nid from pift_ci_job pcj
WHERE pcj.status IN ('queued','running','sent')
GROUP BY pcj.status, pcj.issue_nid;

SELECT * FROM pift_ci_job pcj
WHERE pcj.issue_nid = 1356276;

SELECT FROM_UNIXTIME(pcj.created),pcj.* FROM pift_ci_job pcj
WHERE pcj.status='sent';

DELETE pcj FROM pift_ci_job pcj
WHERE pcj.status='queued' and pcj.job_id < 640000;

SELECT COUNT(*), pcj.status  from pift_ci_job pcj
GROUP BY pcj.status;

SELECT * FROM pift_ci_job pcj
WHERE pcj.status = 'error';
