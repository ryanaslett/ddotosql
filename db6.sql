SELECT * FROM project_dependency_dependency pdd
LEFT JOIN project_dependency_component pdc on pdc.component_id = pdd.component_id
WHERE core_api = '8.x' AND dependency LIKE '%8%' AND dependency NOT LIKE '%drupal%' AND dependency NOT LIKE '%system%' and dependency NOT LIKE 'pathauto_i18n%'


SELECT fdfdri.field_distil_reg_iid_value, fdfdrsi.field_distil_reg_sid_ip_value, fdfdrri.field_distil_reg_reported_ip_value, dris.*
FROM field_data_field_distil_reg_sid_ip fdfdrsi
  LEFT JOIN field_data_field_distil_reg_reported_ip fdfdrri on fdfdrsi.entity_id = fdfdrri.entity_id
  LEFT JOIN field_data_field_distil_reg_iid fdfdri ON fdfdri.entity_id = fdfdrsi.entity_id
  LEFT JOIN distil_registration_iid_status dris on dris.distil_iid = fdfdri.field_distil_reg_iid_value
WHERE dris.status = 'blacklist';

SELECT SUM(updated) - SUM(created), updated - created FROM pift_ci_job
WHERE updated-created < 3600;

SELECT updated, created, updated - created FROM pift_ci_job
WHERE updated-created < 3600
ORDER BY created ASC;

SELECT count(*) from pift_ci_job_result;

SELECT FROM_UNIXTIME(pcj.created, '%Y-%m-%d') AS `MonthYear`,pcj.reason, COUNT(*) FROM pift_ci_job pcj
GROUP BY `MonthYear`, pcj.reason ;
SELECT FROM_UNIXTIME(pcj.created, '%Y-%m-%d') AS `MonthYear`, COUNT(*) FROM pift_ci_job pcj
GROUP BY `MonthYear`

SELECT FROM_UNIXTIME(pcj.created, '%Y-%m') AS `MonthYear`, COUNT(*) FROM pift_ci_job pcj
GROUP BY `MonthYear`;


SELECT COUNT(pcj.job_id) AS `Jobs per hour`, FROM_UNIXTIME(pcj.created, '%Y%j%H') as `Hour`, pcj.* FROM pift_ci_job pcj
WHERE (pcj.updated - pcj.created) > 900
GROUP BY `Hour`
ORDER BY `Hour` ASC;

SELECT COUNT(pcj.job_id) AS `Jobs per hour`, FROM_UNIXTIME(pcj.created, '%Y%j%H') as `Hour`, pcj.* FROM pift_ci_job pcj
GROUP BY `Hour`
ORDER BY `Hour` ASC;

-- Drupalci Testing Jobs per day, per reason.
SELECT COUNT(pcj.job_id) AS `Jobs per day`, pcj.reason, FROM_UNIXTIME(pcj.created, '%Y%j') as `Day`, pcj.* FROM pift_ci_job pcj
GROUP BY `Day`, pcj.reason
ORDER BY pcj.reason, `Day` DESC;

-- Drupalci Testing Jobs per week, per reason.
SELECT COUNT(pcj.job_id) AS `Jobs per week`, pcj.reason, FROM_UNIXTIME(pcj.created, '%Y%V') as `Day`, pcj.*
FROM pift_ci_job pcj
GROUP BY `Day`, pcj.reason
ORDER BY pcj.reason, `Day` DESC;

-- Drupalci Testing Jobs per week, per target type.
SELECT COUNT(pcj.job_id) AS `Jobs per week`, pcj.target_type, FROM_UNIXTIME(pcj.created, '%Y%V') as `Day` FROM pift_ci_job pcj
GROUP BY `Day`, pcj.target_type
ORDER BY pcj.target_type, `Day` DESC;

SELECT SUM(foo.`Jobs per hour`) FROM (
                                       SELECT COUNT(pcj.job_id) AS `Jobs per hour`, FROM_UNIXTIME(pcj.created, '%Y%j%H') as `Hour`
                                       FROM pift_ci_job pcj
                                         LEFT JOIN field_data_field_release_project fdfrp on fdfrp.entity_id = pcj.release_nid
                                       WHERE (pcj.updated - pcj.created) > 900
                                             AND pcj.reason != 'Migrated branch testing'
                                             AND pcj.message LIKE '%,%'
                                             AND fdfrp.field_release_project_target_id = 3060
                                       GROUP BY `Hour`
                                       HAVING `Jobs per hour` > 4
                                       ORDER BY `Hour` ASC) as foo;

-- 8884
-- 42539

SELECT *, (pcj.updated - pcj.created) AS `timing`
FROM pift_ci_job pcj
WHERE FROM_UNIXTIME(pcj.created, '%Y%j%H') = '201606623'
      AND pcj.message LIKE '%,%'
      AND
      (pcj.updated - pcj.created) > 900;

SELECT COUNT(*), pcj.reason, pcj.*
FROM pift_ci_job pcj
WHERE pcj.target_type = 'file'
      AND (pcj.updated - pcj.created) > 900
GROUP BY pcj.reason

SELECT COUNT(*) from pift_ci_job;

SELECT GROUP_CONCAT(TABLE_NAME SEPARATOR ' ') FROM TABLES WHERE TABLE_NAME like '%distil%'

SELECT udata.fingerprint AS fingerprint, udata.iid_status AS iid_status, COUNT(udata.Fingerprint) AS fingerprints, GROUP_CONCAT(DISTINCT udata.status) AS status, GROUP_CONCAT(DISTINCT udata.Roles SEPARATOR '|') AS roles, GROUP_CONCAT(udata.uid SEPARATOR ' ') AS uids, GROUP_CONCAT(udata.name SEPARATOR ' ') AS names, GROUP_CONCAT(DISTINCT udata.`WebsiteURLs`) AS website_urls, GROUP_CONCAT(DISTINCT udata.`ForumPostTitles` SEPARATOR ';\r\n') AS forum_post_titles, GROUP_CONCAT(DISTINCT udata.`OrgNames`) AS org_names, FROM_UNIXTIME(MIN(udata.created)) AS first_seen, FROM_UNIXTIME(MAX(udata.created)) AS last_seen, (MAX(udata.created) - MIN(udata.created)) AS fingerprint_age
FROM
  (SELECT fdfdri.field_distil_reg_iid_value AS fingerprint, dris.status AS iid_status, u.uid AS uid, u.name AS name, u.status AS status, u.created AS created, GROUP_CONCAT(DISTINCT r.name) AS Roles, GROUP_CONCAT(DISTINCT fdfw.field_websites_url) AS WebsiteURLs, GROUP_CONCAT(DISTINCT fdfon.field_organization_name_value) AS OrgNames, GROUP_CONCAT(DISTINCT fdfjt.field_job_title_value) AS JobTitles, GROUP_CONCAT(DISTINCT n.title) AS ForumPostTitles, GROUP_CONCAT(DISTINCT fdfb.field_bio_value) AS Bio
   FROM
     field_data_field_distil_reg_iid fdfdri
     LEFT OUTER JOIN distil_registration_iid_status dris ON fdfdri.field_distil_reg_iid_value = dris.distil_iid
     LEFT OUTER JOIN users u ON fdfdri.entity_id = u.uid
     LEFT OUTER JOIN users_roles ur ON ur.uid = u.uid
     LEFT OUTER JOIN role r ON r.rid = ur.rid
     LEFT OUTER JOIN field_data_field_websites fdfw ON fdfw.entity_id = u.uid
     LEFT OUTER JOIN field_data_field_bio fdfb ON fdfb.entity_id = u.uid
     LEFT OUTER JOIN field_data_field_organizations fdfo ON fdfo.entity_id = u.uid
     LEFT OUTER JOIN field_data_field_organization_name fdfon ON fdfon.entity_id = fdfo.field_organizations_value
     LEFT OUTER JOIN field_data_field_job_title fdfjt ON fdfjt.entity_id = fdfon.entity_id
     LEFT OUTER JOIN node n ON n.uid = u.uid AND n.type = 'forum'
   GROUP BY u.uid) udata
WHERE  (udata.status = 'whitelist')
GROUP BY udata.fingerprint
HAVING  (fingerprints > 2)
LIMIT 25 OFFSET 0

SELECT FROM_UNIXTIME(u.created), u.name, u.uid, fdfdri.field_distil_reg_iid_value,dris.status, GROUP_CONCAT(DISTINCT fdfdri2.entity_id)
FROM users u
  JOIN field_data_field_distil_reg_iid fdfdri ON fdfdri.entity_id = u.uid
  LEFT JOIN field_data_field_distil_reg_iid fdfdri2 ON fdfdri2.field_distil_reg_iid_value = fdfdri.field_distil_reg_iid_value
  LEFT JOIN distil_registration_iid_status dris on dris.distil_iid = fdfdri.field_distil_reg_iid_value
WHERE u.status = 0
GROUP BY fdfdri.field_distil_reg_iid_value;

SELECT users u


SELECT COUNT(*), u.uid, u.name, u.mail, fdfdrri.field_distil_reg_reported_ip_value, fdfdrsi.field_distil_reg_sid_ip_value, fdfdri.field_distil_reg_iid_value, dris.status
FROM users u
  JOIN field_data_field_distil_reg_reported_ip fdfdrri ON fdfdrri.entity_id = u.uid
  JOIN field_data_field_distil_reg_sid_ip fdfdrsi ON fdfdrsi.entity_id = u.uid
  LEFT JOIN field_data_field_distil_reg_iid fdfdri ON fdfdri.entity_id = u.uid
  LEFT JOIN distil_registration_iid_status dris ON dris.distil_iid = fdfdri.field_distil_reg_iid_value
WHERE fdfdrsi.field_distil_reg_sid_ip_value <> fdfdrri.field_distil_reg_reported_ip_value
GROUP BY field_distil_reg_iid_value

SELECT COUNT(DISTINCT pdc.release_nid, pdd.dependency, pdc.release_nid,project_node.title, n.title) as `Deps`, pdc.release_nid,fdfpmn.field_project_machine_name_value, n.title
FROM project_dependency_component pdc
  LEFT JOIN project_dependency_dependency pdd ON pdd.component_id = pdc.component_id
  LEFT JOIN node n on n.nid = pdc.release_nid
  LEFT JOIN field_data_field_release_project fdfrp ON fdfrp.entity_id = n.nid
  LEFT JOIN node project_node on project_node.nid = fdfrp.field_release_project_target_id
  LEFT JOIN field_data_field_project_machine_name fdfpmn ON fdfpmn.entity_id = project_node.nid
  LEFT JOIN field_data_taxonomy_vocabulary_6 fdtv6 ON fdtv6.entity_id = n.nid
WHERE project_node.type IN ('project_module','project_theme')
      AND fdfpmn.field_project_machine_name_value NOT IN ('dcco','drustack_core','oa_core','mica','commerce_drupalgap_kickstart','lightning_features','pantarei_siren_core')
      and fdtv6.taxonomy_vocabulary_6_tid > 87
GROUP BY release_nid
ORDER BY Deps DESC;

SELECT pdd.dependency, pdc.release_nid,project_node.title, n.title
FROM project_dependency_component pdc
  LEFT JOIN project_dependency_dependency pdd ON pdd.component_id = pdc.component_id
  LEFT JOIN node n on n.nid = pdc.release_nid
  LEFT JOIN field_data_field_release_project fdfrp ON fdfrp.entity_id = n.nid
  LEFT JOIN node project_node on project_node.nid = fdfrp.field_release_project_target_id
WHERE project_node.type IN ('project_module','project_theme')
      AND pdc.release_nid = 2233715;

WHERE pdc.release_nid = 2715633;
WHERE pdc.release_nid = 2701205;

INSERT INTO distil_registration_iid_status (distil_iid,status,timestamp,admin_uid)
  SELECT bigq.fingerprint as distil_iid, 'blacklist' as status, UNIX_TIMESTAMP() as timestamp, 391689 as admin_uid
  FROM (
         SELECT
           COUNT(udata.Fingerprint) AS `fingerprints`,
           GROUP_CONCAT(DISTINCT udata.status) AS status,
           GROUP_CONCAT(DISTINCT udata.Roles SEPARATOR '|') AS roles,
           GROUP_CONCAT(udata.uid SEPARATOR ' ') AS uids,
           GROUP_CONCAT(udata.name SEPARATOR ' ') AS names,
           GROUP_CONCAT(DISTINCT udata.`WebsiteURLs`) AS website_urls,
           GROUP_CONCAT(DISTINCT udata.`ForumPostTitles` SEPARATOR ';\r\n') AS forum_post_titles,
           GROUP_CONCAT(DISTINCT udata.`OtherNodeTitles` SEPARATOR ';\r\n') AS other_node_titles,
           GROUP_CONCAT(DISTINCT udata.`Comments` SEPARATOR ';\r\n') AS comments,
           GROUP_CONCAT(DISTINCT udata.`OrgNames`) AS org_names,
           FROM_UNIXTIME(MIN(udata.created)) AS first_seen,
           FROM_UNIXTIME(MAX(udata.created)) AS last_seen,
           (MAX(udata.created) - MIN(udata.created)) AS fingerprint_age,
           SUM(udata.longevity) AS total_longevity,
           GROUP_CONCAT(udata.longevity SEPARATOR ':') AS longevity,
           udata.fingerprint,
           udata.iid_status
         FROM
           (SELECT fdfdri.field_distil_reg_iid_value AS fingerprint, dris.status as iid_status,
              u.uid,
              u.name,
              u.status,
              u.created,
                   ((u.access - u.created) DIV 86400) AS longevity,
                   GROUP_CONCAT(DISTINCT r.name) AS Roles,
                   GROUP_CONCAT(DISTINCT fdfw.field_websites_url) AS `WebsiteURLs`,
                   GROUP_CONCAT(DISTINCT fdfon.field_organization_name_value) AS OrgNames,
                   GROUP_CONCAT(DISTINCT fdfjt.field_job_title_value) AS JobTitles,
                   GROUP_CONCAT(DISTINCT forum_nodes.title) AS ForumPostTitles,
                   GROUP_CONCAT(DISTINCT othernodes.title) AS OtherNodeTitles,
                   GROUP_CONCAT(DISTINCT c.subject) AS Comments,
                   GROUP_CONCAT(DISTINCT fdfb.field_bio_value) AS Bio
            FROM field_data_field_distil_reg_iid fdfdri
              LEFT JOIN distil_registration_iid_status dris ON fdfdri.field_distil_reg_iid_value = dris.distil_iid
              LEFT JOIN users u ON fdfdri.entity_id = u.uid
              LEFT JOIN users_roles ur ON ur.uid = u.uid
              LEFT JOIN role r ON r.rid = ur.rid
              LEFT JOIN field_data_field_websites fdfw ON fdfw.entity_id = u.uid
              LEFT JOIN field_data_field_bio fdfb ON fdfb.entity_id = u.uid
              LEFT JOIN field_data_field_organizations fdfo ON fdfo.entity_id = u.uid
              LEFT JOIN field_data_field_organization_name fdfon ON fdfon.entity_id = fdfo.field_organizations_value
              LEFT JOIN field_data_field_job_title fdfjt ON fdfjt.entity_id = fdfon.entity_id
              LEFT JOIN node forum_nodes ON forum_nodes.uid = u.uid AND forum_nodes.type = 'forum'
              LEFT JOIN node othernodes ON othernodes.uid = u.uid AND othernodes.type <> 'forum'
              LEFT JOIN comment c ON c.uid = u.uid
            GROUP BY u.uid) as udata
         WHERE iid_status IS NULL
               AND udata.OtherNodeTitles IS NULL
               AND udata.Comments IS NULL
               AND udata.OrgNames IS NULL
         GROUP BY udata.fingerprint
         HAVING fingerprints > 1 AND total_longevity < 4 ) as bigq;



select fdfdip.field_distil_ip_prob_value,
  fdfdipc.field_distil_ip_prob_country_value,
  fdfdri.field_distil_reg_iid_value,
  fdfdru.field_distil_reg_uid_value,
  u.*
FROM users u
  JOIN field_data_field_distil_ip_prob fdfdip ON fdfdip.entity_id = u.uid
  LEFT JOIN field_data_field_distil_ip_prob_country fdfdipc ON fdfdipc.entity_id = u.uid
  LEFT JOIN field_data_field_distil_reg_iid fdfdri ON fdfdri.entity_id = u.uid
  LEFT JOIN field_data_field_distil_reg_uid fdfdru ON fdfdru.entity_id = u.uid

SELECT COUNT(*) from users;

use drupal;
SELECT DISTINCT fdfpmn.field_project_machine_name_value as `project_name`, project_node.nid, pdc.name as `component_name`,fdtv6.taxonomy_vocabulary_6_tid, puwp.count
FROM node project_node
  LEFT JOIN field_data_field_project_machine_name fdfpmn on fdfpmn.entity_id = project_node.nid
  LEFT JOIN field_data_field_release_project fdfrp on fdfrp.field_release_project_target_id = project_node.nid
  LEFT JOIN node release_node on release_node.nid = fdfrp.entity_id
  LEFT JOIN project_dependency_component pdc on pdc.release_nid = release_node.nid
  LEFT JOIN field_data_taxonomy_vocabulary_6 fdtv6 ON fdtv6.entity_id = release_node.nid
  LEFT JOIN project_usage_week_project puwp ON puwp.nid = project_node.nid AND puwp.timestamp =
                                                                               (SELECT MAX(puwp2.timestamp) FROM project_usage_week_project puwp2)

WHERE pdc.component_id IS NOT NULL
      AND project_node.type IN ('project_module','project_theme')
      AND project_node.status = 1
ORDER BY puwp.count DESC, fdtv6.taxonomy_vocabulary_6_tid;


SELECT  insidejob.`Machine Name` FROM
  (SELECT fdfpmn.field_project_machine_name_value as `Machine Name`,
          puwp.nid as `Project nid`,
     puwp.count,
     fdtv6.taxonomy_vocabulary_6_tid,
          SUM(puwp.count) as `usage`
   FROM node release_node

     LEFT JOIN taxonomy_index ti on ti.nid = release_node.nid
     LEFT JOIN taxonomy_term_data ttd on ttd.tid = ti.tid
     LEFT JOIN field_data_field_release_version fdfrv on fdfrv.entity_id = release_node.nid
     LEFT JOIN field_data_field_release_project fdfrp on fdfrp.entity_id = release_node.nid
     LEFT JOIN field_data_taxonomy_vocabulary_6 fdtv6 ON fdtv6.entity_id = release_node.nid
     LEFT JOIN project_usage_week_project puwp on project_node.nid = puwp.nid AND puwp.tid = fdtv6.taxonomy_vocabulary_6_tid AND puwp.timestamp = (SELECT MAX(puwp2.timestamp) FROM project_usage_week_project puwp2)

   WHERE release_node.type = 'project_release'
         AND ttd.name in ('7.x','8.x')
         AND fdfrv.field_release_version_value != 'master'
         AND fdfpmn.bundle in ('project_module','project_theme')
         AND ttd.vid = 6
         AND fdtv6.taxonomy_vocabulary_6_tid > 87
   GROUP BY puwp.nid
   ORDER BY fdtv6.taxonomy_vocabulary_6_tid DESC, puwp.count DESC) insidejob;

SELECT COUNT(*) as `Rows`, GROUP_CONCAT(pcnm.project_nid), pcnm.component_name, pcnm.package_namespace, pcnm.api_tid
FROM project_composer_namespace_map pcnm
GROUP BY pcnm.package_namespace, pcnm.api_tid
HAVING `Rows` > 1;


SELECT DISTINCT ra.action FROM
  role_activity ra;

SELECT COUNT(*), ra.action FROM role_activity ra
GROUP BY ra.action;

SELECT COUNT(*), ra.action, FROM_UNIXTIME(ra.timestamp, '%Y%m') as `ym`
FROM role_activity ra
WHERE ra.action = 'Comment Deleted'
GROUP BY `ym`;

SELECT COUNT(*), ra.action, FROM_UNIXTIME(ra.timestamp, '%Y%m') as `ym`
FROM role_activity ra
WHERE ra.action = 'Content Deleted'
GROUP BY `ym`;

SELECT ra.*, FROM_UNIXTIME(ra.timestamp, '%Y%m') as `ym`
FROM role_activity ra
WHERE ra.action = 'Content Deleted'
GROUP BY `ym`;

SELECT ra.raid, ra.uid,ra.message, FROM_UNIXTIME(ra.timestamp, '%Y%m%d') FROM role_activity ra where ra.action = 'Comment Deleted' ORDER BY ra.raid DESC;

SELECT ra.raid, ra.uid,ra.message, FROM_UNIXTIME(ra.timestamp) FROM role_activity ra where ra.action = 'User login' ORDER BY ra.raid DESC;

SELECT DISTINCT pdc.name AS name
FROM
  project_dependency_component pdc
  INNER JOIN field_data_field_release_project fdfrp ON fdfrp.entity_id = pdc.release_nid
  INNER JOIN field_data_taxonomy_vocabulary_6 fdtv6 ON fdtv6.entity_id = fdfrp.entity_id
WHERE  (fdfrp.field_release_project_target_id = 3060) AND ((fdtv6.taxonomy_vocabulary_6_tid = :api_tid)) AND (pdc.release_nid = SELECT MAX(fdfrpinner.entity_id) AS expression
                                                                                                                                                                 FROM
                                                                                                                                                                 field_data_field_release_project fdfrpinner
                                                                                                                                                                 INNER JOIN field_data_taxonomy_vocabulary_6 fdtv6inner ON fdtv6inner.entity_id = fdfrpinner.entity_id
                                                                                                                                                                                                                           WHERE  (fdfrp.field_release_project_target_id = 3060) AND ((fdtv6.taxonomy_vocabulary_6_tid = :api_tid)) )

SELECT DISTINCT pdc.name AS name
FROM
  project_dependency_component pdc
  INNER JOIN field_data_field_release_project fdfrp ON fdfrp.entity_id = pdc.release_nid
  INNER JOIN field_data_taxonomy_vocabulary_6 fdtv6 ON fdtv6.entity_id = fdfrp.entity_id
WHERE (fdfrp.field_release_project_target_id = 3060) AND ((fdtv6.taxonomy_vocabulary_6_tid = :api_tid)) AND
      (pdc.release_nid IN (SELECT MAX(fdfrpinner.entity_id) AS expression
                           FROM
                             field_data_field_release_project fdfrpinner
                             INNER JOIN field_data_taxonomy_vocabulary_6 fdtv6inner
                               ON fdtv6inner.entity_id = fdfrpinner.entity_id
                           WHERE (fdfrp.field_release_project_target_id = 3060) AND
                                 ((fdtv6.taxonomy_vocabulary_6_tid = :api_tid)))
      )

SELECT DISTINCT pdc.name AS name
FROM
  project_dependency_component pdc
  INNER JOIN field_data_field_release_project fdfrp ON fdfrp.entity_id = pdc.release_nid
  INNER JOIN field_data_taxonomy_vocabulary_6 fdtv6 ON fdtv6.entity_id = fdfrp.entity_id
WHERE  (fdfrp.field_release_project_target_id = 3060) AND ((fdtv6.taxonomy_vocabulary_6_tid = :api_tid)) AND (pdc.release_nid IN  (SELECT MAX(fdfrpinner.entity_id) AS expression
                                                                                                                                   FROM
                                                                                                                                     field_data_field_release_project fdfrpinner
                                                                                                                                     INNER JOIN field_data_taxonomy_vocabulary_6 fdtv6inner ON fdtv6inner.entity_id = fdfrpinner.entity_id
                                                                                                                                   WHERE  (fdfrpinner.field_release_project_target_id = 3060) AND ((fdtv6inner.taxonomy_vocabulary_6_tid = :api_tid)) )
)



SELECT fdfpmn.field_project_machine_name_value

FROM field_data_field_project_machine_name fdfpmn
  LEFT JOIN field_data_field_project_type fdfpt on fdfpmn.entity_id = fdfpt.entity_id
  LEFT JOIN field_data_field_release_project fdfrp ON fdfrp.field_release_project_target_id = fdfpmn.entity_id
  LEFT JOIN field_data_taxonomy_vocabulary_6 fdtv6 ON fdtv6.entity_id = fdfrp.entity_id
  LEFT JOIN node n on n.nid = fdfpmn.entity_id
  LEFT JOIN project_usage_week_project puwp ON puwp.nid = n.nid AND puwp.timestamp =
                                                                    (SELECT MAX(puwp2.timestamp) FROM project_usage_week_project puwp2)
WHERE fdfpt.field_project_type_value != 'sandbox'
      AND n.status = 1
      AND fdfpmn.bundle IN ('project_module','project_theme')
      AND fdtv6.taxonomy_vocabulary_6_tid > 87
GROUP BY fdfpmn.field_project_machine_name_value
ORDER BY max(puwp.count) DESC;

--
SELECT pcp3.* FROM project_composer_providers pcp3 WHERE pcp3.project_nid IN
                                                         (
                                                           SELECT DISTINCT pcp2.project_nid
                                                           from project_composer_providers pcp2  JOIN (
                                                                                                        SELECT COUNT(*) as `Rows`, pcp.provider_name, pcp.api_tid FROM project_composer_providers pcp
                                                                                                        GROUP BY pcp.provider_name, pcp.api_tid
                                                                                                        HAVING `Rows` > 1) as foo ON foo.provider_name = pcp2.provider_name and foo.api_tid = pcp2.api_tid
                                                             LEFT JOIN field_data_field_project_machine_name fdfpmn ON fdfpmn.entity_id = pcp2.project_nid) ;

USE drupal;

DELETE FROM pcp8 USING project_composer_providers AS pcp8
WHERE pcp8.provider_id IN (SELECT * FROM (
                                           SELECT DISTINCT pcp2.provider_id
                                           from project_composer_providers pcp2 JOIN (
                                                                                       SELECT COUNT(*) as `Rows`, pcp.provider_name, pcp.api_tid FROM project_composer_providers pcp
                                                                                       GROUP BY pcp.provider_name, pcp.api_tid
                                                                                       HAVING `Rows` > 1) as foo ON foo.provider_name = pcp2.provider_name and foo.api_tid = pcp2.api_tid
                                             LEFT JOIN field_data_field_project_machine_name fdfpmn ON fdfpmn.entity_id = pcp2.project_nid) AS X);


-- filenames to rm
SELECT DISTINCT pcp2.filename
from project_composer_providers pcp2  JOIN (
                                             SELECT COUNT(*) as `Rows`, pcp.provider_name, pcp.api_tid FROM project_composer_providers pcp
                                             GROUP BY pcp.provider_name, pcp.api_tid
                                             HAVING `Rows` > 1) as foo ON foo.provider_name = pcp2.provider_name and foo.api_tid = pcp2.api_tid
  LEFT JOIN field_data_field_project_machine_name fdfpmn ON fdfpmn.entity_id = pcp2.project_nid
WHERE pcp2.api_tid = 7234;


--- projects to re-run
SELECT DISTINCT fdfpmn.field_project_machine_name_value
from project_composer_providers pcp2  JOIN (
                                             SELECT COUNT(*) as `Rows`, pcp.provider_name, pcp.api_tid FROM project_composer_providers pcp
                                             GROUP BY pcp.provider_name, pcp.api_tid
                                             HAVING `Rows` > 1) as foo ON foo.provider_name = pcp2.provider_name and foo.api_tid = pcp2.api_tid
  LEFT JOIN field_data_field_project_machine_name fdfpmn ON fdfpmn.entity_id = pcp2.project_nid

SELECT DISTINCT fdtv6.taxonomy_vocabulary_6_tid, pdc.name, fdfpmn.field_project_machine_name_value
FROM project_dependency_component pdc
  LEFT JOIN field_data_field_release_project fdfrp ON fdfrp.entity_id = pdc.release_nid
  LEFT JOIN field_data_taxonomy_vocabulary_6 fdtv6 ON fdtv6.entity_id = pdc.release_nid
  LEFT JOIN field_data_field_project_machine_name fdfpmn ON fdfpmn.entity_id = fdfrp.field_release_project_target_id
WHERE LENGTH(pdc.composer) > 1
      AND taxonomy_vocabulary_6_tid > 87
      AND pdc.composer LIKE '%require"%'
      AND pdc.composer NOT LIKE '%"require": { }%'
      AND pdc.composer NOT LIKE '%"require": {}%';

SELECT * from users u where u.mail = 'marymakagr@sbcglobal.net';

SELECT n.nid, n.title, c.subject, fdcb.comment_body_value FROM field_data_comment_body fdcb
  LEFT JOIN comment c on c.cid = fdcb.entity_id
  LEFT JOIN node n on n.nid = c.nid
WHERE fdcb.comment_body_value LIKE '%2718229%'

SELECT DISTINCT fdfic.field_issue_changes_field_name FROM field_data_field_issue_changes fdfic;

SELECT * FROM field_data_field_issue_changes fdfic
WHERE fdfic.field_issue_changes_field_name = 'field_issue_files';

SELECT pcj.ci_url,pcj.*,
  FROM_UNIXTIME(pcj.created, '%Y%m') AS `YM`
FROM pift_ci_job pcj
WHERE ci_url IS NOT NULL
HAVING `YM` = 201604;

select COUNT(fdfdrz.field_distil_reg_zid_value) as `Rows`, fdfdrz.field_distil_reg_zid_value, GROUP_CONCAT(DISTINCT fdfdri.field_distil_reg_iid_value), GROUP_CONCAT(fdfdrz.entity_id), GROUP_CONCAT(DISTINCT fdfdrri.field_distil_reg_reported_ip_value)
FROM field_data_field_distil_reg_zid fdfdrz
  LEFT JOIN field_data_field_distil_reg_iid fdfdri ON fdfdri.entity_id = fdfdrz.entity_id
  LEFT JOIN field_data_field_distil_reg_reported_ip fdfdrri ON fdfdrri.entity_id = fdfdrz.entity_id
WHERE fdfdrz.field_distil_reg_zid_value <> ''
GROUP BY fdfdrz.field_distil_reg_zid_value
HAVING `Rows` > 1
;

SELECT Count(*) AS `IP Count`, fdfdrsi.field_distil_reg_sid_ip_value, GROUP_CONCAT(DISTINCT CONCAT(fdfdri.field_distil_reg_iid_value," ", dris.status))
-- GROUP_CONCAT(DISTINCT CONCAT(fdfdri.field_distil_reg_iid_value,dris.s)
FROM field_data_field_distil_reg_sid_ip fdfdrsi
  LEFT JOIN field_data_field_distil_reg_iid fdfdri ON fdfdri.entity_id = fdfdrsi.entity_id
  LEFT JOIN distil_registration_iid_status dris ON dris.distil_iid = fdfdri.field_distil_reg_iid_value
GROUP BY fdfdrsi.field_distil_reg_sid_ip_value;

SELECT Count(*) AS `IP Count`, fdfdrsi.field_distil_reg_reported_ip_value, GROUP_CONCAT(DISTINCT CONCAT(fdfdri.field_distil_reg_iid_value," ", COALESCE(dris.status, '')))
FROM field_data_field_distil_reg_reported_ip fdfdrsi
  LEFT JOIN field_data_field_distil_reg_iid fdfdri ON fdfdri.entity_id = fdfdrsi.entity_id
  LEFT JOIN distil_registration_iid_status dris ON dris.distil_iid = fdfdri.field_distil_reg_iid_value
GROUP BY fdfdrsi.field_distil_reg_reported_ip_value;


-- Users who's SIP does not match their reported IP
SELECT u.uid, u.name, u.mail, u.status, fdfdrri.field_distil_reg_reported_ip_value, fdfdrsi.field_distil_reg_sid_ip_value FROM users u
  LEFT JOIN field_data_field_distil_reg_sid_ip fdfdrsi ON fdfdrsi.entity_id = u.uid
  LEFT JOIN field_data_field_distil_reg_reported_ip fdfdrri ON fdfdrri.entity_id = u.uid
WHERE fdfdrri.field_distil_reg_reported_ip_value != fdfdrsi.field_distil_reg_sid_ip_value

-- Number of blocked users per email domain
SELECT COUNT(*) as `Number of Blocked Users`, SUBSTRING_INDEX(u.mail,'@',-1) as `Email Host`
FROM users u
WHERE u.status = 0
GROUP BY `Email Host`
ORDER BY `Number of Blocked Users` DESC;

SELECT SUM(insider.`Number of Blocked Users`) FROM (
                                                     SELECT COUNT(*) as `Number of Blocked Users`, SUBSTRING_INDEX(u.mail,'@',-1) as `Email Host`
                                                     FROM users u
                                                     WHERE u.status = 0
                                                     GROUP BY `Email Host`
                                                     ORDER BY `Number of Blocked Users` DESC) AS insider;


SELECT COUNT(*) from users u where u.status = 0



SELECT *
FROM field_data_field_distil_reg_sid_ip fdfdrsi
  LEFT JOIN field_data_field_distil_reg_iid fdfdri ON fdfdri.entity_id = fdfdrsi.entity_id
  LEFT JOIN distil_registration_iid_status dris ON dris.distil_iid = fdfdri.field_distil_reg_iid_value

SELECT Count(*) AS `IP Count`, fdfdrsi.field_distil_reg_sid_ip_value, GROUP_CONCAT(DISTINCT CONCAT(fdfdri.field_distil_reg_iid_value,' ', dris.status)), GROUP_CONCAT(DISTINCT SUBSTRING_INDEX(u.mail,'@',-1)) as `Email Host`
FROM field_data_field_distil_reg_sid_ip fdfdrsi
  LEFT JOIN field_data_field_distil_reg_iid fdfdri ON fdfdri.entity_id = fdfdrsi.entity_id
  LEFT JOIN distil_registration_iid_status dris ON dris.distil_iid = fdfdri.field_distil_reg_iid_value
  LEFT JOIN users u ON u.uid = fdfdrsi.entity_id
GROUP BY fdfdrsi.field_distil_reg_sid_ip_value;

SELECT * from node n where n.nid = 2386441;

SELECT n.type from project_dependency_component pdc
  LEFT JOIN field_data_field_release_project fdfrp ON fdfrp.entity_id = pdc.release_nid
  LEFT JOIN node n on n.nid = fdfrp.field_release_project_target_id
WHERE LENGTH(pdc.composer) > 0;
AND n.type = 'project_theme';


SELECT project_node.title, CONCAT("https://www.drupal.org/node/",issue_node.nid), issue_node.title, fdfis.field_issue_status_value, fdb.body_value, GROUP_CONCAT(ttd.name)
FROM node issue_node
  LEFT JOIN field_data_field_project fdfp ON fdfp.entity_id = issue_node.nid
  LEFT JOIN field_data_field_issue_status fdfis ON fdfis.entity_id = issue_node.nid
  LEFT JOIN node project_node on fdfp.field_project_target_id = project_node.nid
  LEFT JOIN field_data_body fdb on fdb.entity_id = issue_node.nid
  LEFT JOIN field_data_taxonomy_vocabulary_9 fdtv9 ON fdtv9.entity_id = issue_node.nid
  LEFT JOIN taxonomy_term_data ttd ON ttd.tid = fdtv9.taxonomy_vocabulary_9_tid
WHERE issue_node.type = 'project_issue'
      and fdfp.field_project_target_id IN (2251767,2251761,2251765)
      AND fdfis.field_issue_status_value IN ('1','13','8','14','15','4','16')
GROUP BY issue_node.nid;

SELECT pcp.*,fdfpmn.field_project_machine_name_value, project_node.title, GROUP_CONCAT(pcj.message), COUNT(pcj.job_id)
FROM pift_ci_project pcp
  LEFT JOIN field_data_taxonomy_vocabulary_6 fdtv6 ON fdtv6.entity_id = pcp.release_nid
  LEFT JOIN field_data_field_release_project fdfrp on fdfrp.entity_id = pcp.release_nid
  LEFT JOIN node project_node on project_node.nid = fdfrp.field_release_project_target_id
  LEFT JOIN field_data_field_project_machine_name fdfpmn ON fdfpmn.entity_id = project_node.nid
  LEFT JOIN pift_ci_job pcj ON pcj.release_nid = pcp.release_nid
WHERE fdtv6.taxonomy_vocabulary_6_tid = 87
GROUP BY pcp.release_nid;


SELECT DISTINCT release_nid FROM project_dependency_component pdc
  LEFT JOIN field_data_field_release_project AS pr
    ON pdc.release_nid=pr.entity_id
  LEFT JOIN field_data_field_project_machine_name AS project
    ON pr.field_release_project_target_id=project.entity_id
  LEFT JOIN field_data_field_project_has_releases AS phr ON phr.entity_id = project.entity_id
WHERE pdc.name = 'file'
      AND project.field_project_machine_name_value = 'file'
      AND phr.field_project_has_releases_value =1


SELECT DISTINCT release_nid FROM project_dependency_component
WHERE name = 'file'

SELECT * FROM project_dependency_component
WHERE name = 'file'

SELECT pdc.*, pdd.dependency FROM project_dependency_component pdc
  LEFT JOIN field_data_field_release_project AS pr
    ON pdc.release_nid=pr.entity_id
  LEFT JOIN field_data_field_project_machine_name AS project
    ON pr.field_release_project_target_id=project.entity_id
  LEFT JOIN field_data_field_project_has_releases AS phr ON phr.entity_id = project.entity_id
  LEFT JOIN project_dependency_dependency pdd on pdd.component_id = pdc.component_id
WHERE phr.field_project_has_releases_value = 0

SELECT COUNT(*) as `Rows`, GROUP_CONCAT(pdc.name) as `Names`, fdfpmn.field_project_machine_name_value
FROM project_dependency_component pdc
  LEFT JOIN field_data_field_release_project fdfrp on fdfrp.entity_id = pdc.release_nid
  LEFT JOIN field_data_field_project_machine_name fdfpmn ON fdfrp.field_release_project_target_id = fdfpmn.entity_id
WHERE LENGTH(pdc.composer) > 1
GROUP BY pdc.release_nid
HAVING `Names` !=  fdfpmn.field_project_machine_name_value;
HAVING `Rows` > 1;


SELECT FROM_UNIXTIME(timestamp), wd.* from watchdog wd where uid = 2504832;



SELECT DISTINCT fdfpmn.field_project_machine_name_value
FROM project_dependency_dependency pdd
  LEFT JOIN project_dependency_component pdc ON pdc.component_id = pdd.component_id
  LEFT JOIN field_data_field_release_project fdfrp ON fdfrp.entity_id = pdc.release_nid
  LEFT JOIN field_data_field_project_machine_name fdfpmn on fdfpmn.entity_id = fdfrp.field_release_project_target_id
WHERE pdd.dependency IN (SELECT DISTINCT pdc.name FROM project_dependency_dependency pdd
  LEFT JOIN  project_dependency_component pdc ON pdc.component_id = pdd.component_id
  LEFT JOIN field_data_field_release_project fdfrp ON fdfrp.entity_id = pdc.release_nid
  LEFT JOIN field_data_field_project_machine_name fdfpmn on fdfpmn.entity_id = fdfrp.field_release_project_target_id
WHERE fdfpmn.field_project_machine_name_value = 'context')
      AND pdd.core_api REGEXP '7.x|8.x';

SELECT DISTINCT pdc.name FROM project_dependency_dependency pdd
  LEFT JOIN  project_dependency_component pdc ON pdc.component_id = pdd.component_id
  LEFT JOIN field_data_field_release_project fdfrp ON fdfrp.entity_id = pdc.release_nid
  LEFT JOIN field_data_field_project_machine_name fdfpmn on fdfpmn.entity_id = fdfrp.field_release_project_target_id
WHERE fdfpmn.field_project_machine_name_value = 'context';

SELECT DISTINCT fdfpmn.field_project_machine_name_value
FROM project_dependency_component pdc
  LEFT JOIN field_data_field_release_project fdfrp ON fdfrp.entity_id = pdc.release_nid
  LEFT JOIN field_data_field_project_machine_name fdfpmn on fdfpmn.entity_id = fdfrp.field_release_project_target_id
WHERE pdc.package = 'context';

SELECT * FROM field_data_taxonomy_vocabulary_6 tdtv6
  LEFT JOIN node n on n.nid = tdtv6.entity_id
  LEFT JOIN field_data_field_release_build_type fdfrbt ON fdfrbt.entity_id = n.nid
WHERE field_release_build_type_value = 'dynamic'
LIMIT 10;

SELECT * FROM pift_ci_project pcp
  LEFT JOIN field_data_taxonomy_vocabulary_6 tdtv6 ON tdtv6.entity_id = pcp.release_nid
WHERE tdtv6.taxonomy_vocabulary_6_tid < 103;

SELECT DISTINCT fdfpmn.field_project_machine_name_value
FROM node n
  LEFT JOIN field_data_taxonomy_vocabulary_7 fdtv7 ON fdtv7.entity_id = n.nid
  LEFT JOIN field_data_field_release_project fdfrp ON fdfrp.entity_id = n.nid
  LEFT JOIN field_data_field_project_machine_name fdfpmn ON fdfpmn.entity_id = fdfrp.field_release_project_target_id
WHERE n.type = 'project_release'
      AND fdtv7.taxonomy_vocabulary_7_tid = '100'
      AND n.status = 1
      AND n.created > 1466621215
ORDER BY n.created DESC;

SELECT
  c.nid,
  c.uid,
  group_concat(DISTINCT c.cid)
FROM (SELECT
        c.nid,
        c.uid,
        group_concat(DISTINCT fac.field_attribute_contribution_to_target_id) AS organizations,
        group_concat(DISTINCT ffc.field_for_customer_target_id)              AS customers
      FROM field_data_field_issue_credit fic INNER JOIN comment c
          ON c.cid = fic.field_issue_credit_target_id AND c.status = 1
        INNER JOIN field_data_field_issue_status fis ON fis.entity_id = c.nid AND fis.field_issue_status_value IN (2, 7)
        LEFT JOIN field_data_field_attribute_contribution_to fac ON fac.entity_id = c.cid
        LEFT JOIN field_data_field_for_customer ffc ON ffc.entity_id = c.cid
      GROUP BY c.nid, c.uid
      ORDER BY NULL) q
  INNER JOIN comment c ON c.nid = q.nid AND c.uid = q.uid
  LEFT JOIN field_data_field_issue_credit fic ON fic.field_issue_credit_target_id = c.cid
  INNER JOIN field_data_field_attribute_as_volunteer fav
    ON fav.entity_id = c.cid AND fav.field_attribute_as_volunteer_value = '0'
  LEFT JOIN field_data_field_attribute_contribution_to fac ON fac.entity_id = c.cid
  LEFT JOIN field_data_field_for_customer ffc ON ffc.entity_id = c.cid
WHERE fic.field_issue_credit_target_id IS NULL AND (fac.entity_id IS NOT NULL OR ffc.entity_id IS NOT NULL) AND
      (q.organizations NOT LIKE concat('%', fac.field_attribute_contribution_to_target_id, '%') OR
       q.customers NOT LIKE concat('%', ffc.field_for_customer_target_id, '%'))
GROUP BY c.nid, c.uid
ORDER BY NULL;


SELECT DISTINCT project.field_project_machine_name_value, project2.field_project_machine_name_value
FROM project_dependency_component pdc
  LEFT JOIN field_data_field_release_project AS pr
    ON pdc.release_nid=pr.entity_id
  LEFT JOIN field_data_field_project_machine_name AS project
    ON pr.field_release_project_target_id=project.entity_id
  LEFT JOIN node release_node
    ON release_node.nid = pdc.release_nid
  LEFT JOIN project_dependency_dependency pdd ON pdd.dependency LIKE concat(project.field_project_machine_name_value, ':%')
  LEFT JOIN project_dependency_component pdc2 ON pdc2.component_id = pdd.component_id
  LEFT JOIN field_data_field_release_project AS pr2
    ON pdc2.release_nid=pr2.entity_id
  LEFT JOIN field_data_field_project_machine_name AS project2
    ON pr2.field_release_project_target_id=project2.entity_id
WHERE release_node.status != 1;

SELECT pdc.component_id, pdc.release_nid, pdd.*
FROM project_dependency_component pdc
  LEFT JOIN project_dependency_dependency pdd ON pdd.component_id = pdc.component_id
WHERE pdc.release_nid IN (2035733,2035737,2317349,2595367,2735367)

-- SELECT release_node.title, fdfpmn.field_project_machine_name_value, pdd.dependency, pdc.* FROM project_dependency_dependency pdd
SELECT DISTINCT fdfpmn.field_project_machine_name_value
FROM project_dependency_dependency pdd
  LEFT JOIN project_dependency_component pdc on pdc.component_id = pdd.component_id
  LEFT JOIN field_data_field_release_project fdfrp ON fdfrp.entity_id = pdc.release_nid
  LEFT JOIN node release_node on release_node.nid = pdc.release_nid
  LEFT JOIN field_data_field_project_machine_name fdfpmn ON fdfpmn.entity_id = fdfrp.field_release_project_target_id
WHERE dependency LIKE 'dcco%';


SELECT * FROM
  project_dependency_component pdc
  LEFT JOIN node release_node on pdc.release_nid = release_node.nid
  LEFT JOIN field_data_field_release_project fdfrp on fdfrp.entity_id = release_node.nid
  INNER JOIN node project_node on fdfrp.field_release_project_target_id = project_node.nid
                                  AND project_node.type NOT REGEXP 'project_module|project_core';

SELECT DISTINCT pdc.release_nid FROM
  project_dependency_component pdc
  LEFT JOIN node release_node on pdc.release_nid = release_node.nid
  LEFT JOIN field_data_field_release_project fdfrp on fdfrp.entity_id = release_node.nid
  INNER JOIN node project_node on fdfrp.field_release_project_target_id = project_node.nid
                                  AND project_node.type NOT REGEXP 'project_module|project_core';

SELECT fdfpmn.field_project_machine_name_value, pdc.release_nid,pdc.name, release_node.title, project_node.type FROM
  project_dependency_component pdc
  LEFT JOIN node release_node on pdc.release_nid = release_node.nid
  LEFT JOIN field_data_field_release_project fdfrp on fdfrp.entity_id = release_node.nid
  INNER JOIN node project_node on fdfrp.field_release_project_target_id = project_node.nid
  LEFT JOIN field_data_field_project_machine_name fdfpmn ON fdfpmn.entity_id = project_node.nid
WHERE pdc.name IN (
  SELECT distinct pdc.name FROM
    project_dependency_component pdc
    LEFT JOIN node release_node on pdc.release_nid = release_node.nid
    LEFT JOIN field_data_field_release_project fdfrp on fdfrp.entity_id = release_node.nid
    INNER JOIN node project_node on fdfrp.field_release_project_target_id = project_node.nid
                                    AND project_node.type = 'project_core')
      AND project_node.type NOT REGEXP 'project_core|project_distribution';

-- Deletes all components that are not components from modules or core.
-- This removes legacy themes and distributions
DELETE pdc FROM project_dependency_component pdc
  LEFT JOIN node release_node on pdc.release_nid = release_node.nid
  LEFT JOIN field_data_field_release_project fdfrp on fdfrp.entity_id = release_node.nid
  INNER JOIN node project_node on fdfrp.field_release_project_target_id = project_node.nid
                                  AND project_node.type NOT REGEXP 'project_module|project_core';

-- Deletes all trace of dcco components + commerce_drupalgap_kickstart
DELETE pdc FROM project_dependency_component pdc
WHERE pdc.release_nid IN (2035733,2035737,2317349,2595367,2735367,2279159);

-- Shows all of the projects that ended up with a dependency on a distributions' component
SELECT fdfpmn.field_project_machine_name_value, pdd.*, pdc.release_nid, fdfpmn2.field_project_machine_name_value
-- SELECT DISTINCT fdfpmn2.field_project_machine_name_value
FROM node project_node
  LEFT JOIN field_data_field_project_machine_name fdfpmn ON fdfpmn.entity_id = project_node.nid
  LEFT JOIN field_data_field_project_type fdfpt ON fdfpt.entity_id = project_node.nid
  INNER JOIN project_dependency_dependency pdd ON pdd.dependency LIKE CONCAT(fdfpmn.field_project_machine_name_value , ':%')
  LEFT JOIN project_dependency_component pdc ON pdc.component_id = pdd.component_id
  LEFT JOIN field_data_field_release_project fdfrp ON fdfrp.entity_id = pdc.release_nid
  LEFT JOIN field_data_field_project_machine_name fdfpmn2 ON fdfpmn2.entity_id = fdfrp.field_release_project_target_id
WHERE project_node.type = 'project_theme' and fdfpt.field_project_type_value = 'full';

SELECT pdd.*
FROM project_dependency_dependency pdd
  LEFT JOIN project_dependency_component pdc ON pdc.component_id = pdd.component_id
WHERE pdc.component_id IS NULL;

-- eliminates dependencies that no longer exist in the component table
DELETE pdd FROM project_dependency_dependency pdd
  LEFT JOIN project_dependency_component pdc ON pdc.component_id = pdd.component_id
WHERE pdc.component_id IS NULL;


SELECT COUNT(*) from project_dependency_dependency;
SELECT COUNT(*) from project_dependency_component;

SELECT * FROM node n where n.type = 'project_release' and n.status = 0;


-- SELECT release_node.title, pdc.name AS `Component Name`, pdd.dependency, fdfpmn.field_project_machine_name_value, pdc2.name as `Local Component Name`
SELECT DISTINCT fdfpmn.field_project_machine_name_value
FROM project_dependency_component pdc
  LEFT JOIN project_dependency_dependency pdd ON pdc.component_id = pdd.component_id
  LEFT JOIN field_data_field_release_project fdfrp ON fdfrp.entity_id = pdc.release_nid
  LEFT JOIN field_data_field_project_machine_name fdfpmn ON fdfpmn.entity_id = fdfrp.field_release_project_target_id
  JOIN project_dependency_component pdc2 ON pdc2.release_nid = pdc.release_nid AND pdd.dependency LIKE CONCAT('%:', pdc2.name) AND pdd.dependency != CONCAT(fdfpmn.field_project_machine_name_value, ':', pdc2.name)
WHERE pdd.core_api != '6.x';


SELECT release_node.created, fdfpmn.field_project_machine_name_value, release_node.title, CONCAT('http://cgit.drupalcode.org/', fdfpmn.field_project_machine_name_value, '/tree')
FROM node project_node
  LEFT JOIN field_data_field_release_project fdfrp ON fdfrp.field_release_project_target_id = project_node.nid
  LEFT JOIN node release_node ON release_node.nid = fdfrp.entity_id
  LEFT JOIN field_data_field_project_machine_name fdfpmn ON fdfpmn.entity_id = project_node.nid
WHERE project_node.type = 'project_distribution'
      AND release_node.title REGEXP '8.x'
      AND project_node.status = 1
ORDER BY release_node.created DESC;

SELECT * FROM pift_ci_project pcp
  LEFT JOIN node release_node on release_node.nid = pcp.release_nid
WHERE release_node.status = 0;

-- Projects configured to run on commit to a branch, as well as on issue patch uploads.
SELECT pcp.*, release_node.title, fdfpmn.field_project_machine_name_value, fdfpmn.entity_id
FROM pift_ci_project pcp
  LEFT JOIN field_data_field_release_project fdfrp ON fdfrp.entity_id = pcp.release_nid
  LEFT JOIN field_data_field_project_machine_name fdfpmn ON fdfpmn.entity_id = fdfrp.field_release_project_target_id
  LEFT JOIN node release_node ON release_node.nid = pcp.release_nid
WHERE pcp.testing = 'branch_commit' AND fdfpmn.entity_id != 3060;

SELECT DISTINCT target_type from pift_ci_job;

SELECT * from pift_ci_job pcj
WHERE pcj.target_type = 'file';
SELECT SUM(things.`extra tests`) FROM
  (SELECT COUNT(*) as `Rows`, (COUNT(*) DIV (misconfigs.Rows)) * (misconfigs.Rows-1) as `extra tests`,
     FROM_UNIXTIME(pcj.updated),pcj.release_nid, misconfigs.*, pcj.*
   FROM pift_ci_job pcj
     JOIN (
            SELECT COUNT(*) as `Rows`,pcp.*, release_node.title, fdfpmn.field_project_machine_name_value, fdfpmn.entity_id
            FROM pift_ci_project pcp
              LEFT JOIN field_data_field_release_project fdfrp ON fdfrp.entity_id = pcp.release_nid
              LEFT JOIN field_data_field_project_machine_name fdfpmn ON fdfpmn.entity_id = fdfrp.field_release_project_target_id
              LEFT JOIN node release_node ON release_node.nid = pcp.release_nid
            WHERE pcp.testing = 'issue' AND fdfpmn.entity_id != 3060
            GROUP BY release_node.title
            HAVING Rows > 1) as misconfigs ON misconfigs.release_nid = pcj.release_nid
   WHERE pcj.target_type = 'file'
         AND pcj.updated BETWEEN 1470982746 AND 1473689766
   GROUP BY pcj.release_nid) as things;


SELECT DISTINCT testing
FROM pift_ci_project pcp;

SELECT DISTINCT CONCAT("http://drupal.org/project/",fdfpmn.field_project_machine_name_value) as `Project Page`, CONCAT("http://cgit.drupalcode.org/",vcr.name, "/tree") as `Tree`, vir.path, project_node.type
FROM versioncontrol_item_revisions vir
  LEFT JOIN versioncontrol_project_projects vpp ON vpp.repo_id = vir.repo_id
  LEFT JOIN versioncontrol_repositories vcr ON vcr.repo_id = vir.repo_id
  LEFT JOIN node project_node ON project_node.nid = vpp.nid
  LEFT JOIN field_data_field_project_machine_name fdfpmn ON fdfpmn.entity_id = project_node.nid
  LEFT JOIN field_data_field_project_type fdfpt ON fdfpt.entity_id = project_node.nid
  LEFT JOIN field_data_field_release_project fdfrp ON fdfrp.field_release_project_target_id = project_node.nid
  LEFT JOIN field_data_field_release_version fdfrv ON fdfrv.entity_id = fdfrp.entity_id
  LEFT JOIN versioncontrol_item_revisions vir2 ON vir2.repo_id = vir.repo_id AND vir2.path REGEXP '^/[-_a-z]+[.]make'
WHERE vir.path LIKE '%.profile'
      AND project_node.status = 1 AND fdfpt.field_project_type_value = 'full'
      AND vir.path LIKE '^/[-_a-z]+[.]profile'
      AND vir2.path IS NULL
      AND fdfrv.field_release_version_value REGEXP '7.x|8.x';

-- Projects that have phpcs.xml
SELECT DISTINCT CONCAT("http://drupal.org/project/",fdfpmn.field_project_machine_name_value) as `Project Page`, CONCAT("http://cgit.drupalcode.org/",vcr.name, "/tree") as `Tree`, vir.path, fdfrv.field_release_version_value
FROM versioncontrol_item_revisions vir
  LEFT JOIN versioncontrol_project_projects vpp ON vpp.repo_id = vir.repo_id
  LEFT JOIN versioncontrol_repositories vcr ON vcr.repo_id = vir.repo_id
  LEFT JOIN node project_node ON project_node.nid = vpp.nid
  LEFT JOIN field_data_field_project_machine_name fdfpmn ON fdfpmn.entity_id = project_node.nid
  LEFT JOIN field_data_field_project_type fdfpt ON fdfpt.entity_id = project_node.nid
  LEFT JOIN field_data_field_release_project fdfrp ON fdfrp.field_release_project_target_id = project_node.nid
  LEFT JOIN field_data_field_release_version fdfrv ON fdfrv.entity_id = fdfrp.entity_id
WHERE vir.path LIKE '%phpcs.xml%'
      AND project_node.status = 1 AND fdfpt.field_project_type_value = 'full'
      AND project_node.type = 'project_module'
      AND fdfrv.field_release_version_value REGEXP '7.x|8.x';

-- Projects that have phpcs.xml
SELECT DISTINCT CONCAT("http://drupal.org/project/",fdfpmn.field_project_machine_name_value) as `Project Page`, CONCAT("http://cgit.drupalcode.org/",vcr.name, "/tree") as `Tree`
FROM versioncontrol_item_revisions vir
  LEFT JOIN versioncontrol_project_projects vpp ON vpp.repo_id = vir.repo_id
  LEFT JOIN versioncontrol_repositories vcr ON vcr.repo_id = vir.repo_id
  LEFT JOIN node project_node ON project_node.nid = vpp.nid
  LEFT JOIN field_data_field_project_machine_name fdfpmn ON fdfpmn.entity_id = project_node.nid
  LEFT JOIN field_data_field_project_type fdfpt ON fdfpt.entity_id = project_node.nid
  LEFT JOIN field_data_field_release_project fdfrp ON fdfrp.field_release_project_target_id = project_node.nid
  LEFT JOIN field_data_field_release_version fdfrv ON fdfrv.entity_id = fdfrp.entity_id
WHERE vir.path LIKE '%phpcs.xml%'
      AND project_node.status = 1 AND fdfpt.field_project_type_value = 'full'
      AND project_node.type = 'project_module'
      AND fdfrv.field_release_version_value REGEXP '7.x|8.x';

SELECT * from project_dependency_component pdc where length(pdc.composer) > 0

SELECT DISTINCT n.type
FROM project_composer_namespace_map pcnm
  JOIN node n on n.nid = pcnm.project_nid;

SELECT * FROM field_data_field_release_project WHERE field_data_field_release_project.field_release_project_target_id = 3060;

SELECT releasenode.title, pdd.dependency FROM project_dependency_component pdc
  LEFT JOIN project_dependency_dependency pdd ON pdd.component_id = pdc.component_id
  LEFT JOIN node releasenode ON releasenode.nid = pdc.release_nid
WHERE pdc.name = 'media'

SELECT release_node.title, pdc.name AS `Component Name`, pdd.dependency, fdfpmn.field_project_machine_name_value, pdc2.name as `Local Component Name`
FROM project_dependency_component pdc
  LEFT JOIN project_dependency_dependency pdd ON pdc.component_id = pdd.component_id
  LEFT JOIN field_data_field_release_project fdfrp ON fdfrp.entity_id = pdc.release_nid
  LEFT JOIN field_data_field_project_machine_name fdfpmn ON fdfpmn.entity_id = fdfrp.field_release_project_target_id

  JOIN project_dependency_component pdc2 ON pdc2.release_nid = pdc.release_nid
                                            AND pdd.dependency LIKE CONCAT('%:', pdc2.name)
                                            AND pdd.dependency != CONCAT(fdfpmn.field_project_machine_name_value, ':', pdc2.name)
WHERE pdd.core_api != '6.x';

-- Inter project dependencies
SELECT release_node.title, pdc.name AS `Component Name`, pdd.dependency, fdfpmn.field_project_machine_name_value
FROM project_dependency_component pdc
  LEFT JOIN project_dependency_dependency pdd ON pdc.component_id = pdd.component_id
  LEFT JOIN field_data_field_release_project fdfrp ON fdfrp.entity_id = pdc.release_nid
  LEFT JOIN field_data_field_project_machine_name fdfpmn ON fdfpmn.entity_id = fdfrp.field_release_project_target_id
  LEFT JOIN node release_node ON release_node.nid = pdc.release_nid
WHERE pdd.dependency LIKE CONCAT(fdfpmn.field_project_machine_name_value, ':%')
      AND pdd.dependency != CONCAT(fdfpmn.field_project_machine_name_value, ':', fdfpmn.field_project_machine_name_value)


SELECT * FROM node n
  LEFT JOIN field_data_field_project_machine_name fdfpmn on fdfpmn.entity_id = n.nid
WHERE n.type LIKE 'project_%'
      AND fdfpmn.field_project_machine_name_value LIKE 'drupalorg%'
      AND n.type <> 'project_issue';


SELECT fdfpmn.field_project_machine_name_value, project_node.type, FROM_UNIXTIME(pcj.updated),  pcj.* from pift_ci_job pcj
  LEFT JOIN field_data_field_release_project fdfrp ON fdfrp.entity_id = pcj.release_nid
  LEFT JOIN node project_node ON project_node.nid = fdfrp.field_release_project_target_id
  LEFT JOIN field_data_field_project_machine_name fdfpmn ON fdfpmn.entity_id = fdfrp.field_release_project_target_id
WHERE project_node.type NOT REGEXP 'project_module|project_core';

SELECT fdfpmn.field_project_machine_name_value, pdd.dependency, pdc.name, pdd.core_api, release_node.title, pdc.composer
FROM project_dependency_dependency pdd
  LEFT JOIN project_dependency_component pdc ON pdc.component_id = pdd.component_id
  LEFT JOIN field_data_field_release_project fdfrp ON fdfrp.entity_id = pdc.release_nid
  LEFT JOIN field_data_field_project_machine_name fdfpmn ON fdfpmn.entity_id = fdfrp.field_release_project_target_id
  LEFT JOIN node release_node ON release_node.nid = pdc.release_nid
WHERE pdd.dependency_type = 1
      AND pdd.core_api != '6.x'
      AND pdc.composer LIKE '%require%';

SELECT DISTINCT fdfpmn.field_project_machine_name_value
FROM node project_node
  LEFT JOIN field_data_field_project_machine_name fdfpmn ON fdfpmn.entity_id = project_node.nid
  LEFT JOIN field_data_field_project_type fdfpt ON fdfpt.entity_id = project_node.nid
  LEFT JOIN field_data_field_release_project fdfrp ON fdfrp.field_release_project_target_id = project_node.nid
  LEFT JOIN node release_node ON release_node.nid = fdfrp.entity_id
  LEFT JOIN field_data_taxonomy_vocabulary_6 fdtv6 ON fdtv6.entity_id = release_node.nid
WHERE fdtv6.taxonomy_vocabulary_6_tid > 87 AND release_node.status = 1 AND project_node.status = 1;

SELECT n.title,pcdc.* FROM project_composer_download_counts pcdc
  LEFT JOIN node n on n.nid = pcdc.release_nid;

SELECT fdfpmn.field_project_machine_name_value as MachineName﻿⁠⁠⁠⁠
FROM node release_node
LEFT JOIN taxonomy_index ti on ti.nid = release_node.nid
LEFT JOIN taxonomy_term_data ttd on ttd.tid = ti.tid
LEFT JOIN field_data_field_release_version fdfrv on fdfrv.entity_id = release_node.nid
LEFT JOIN field_data_field_release_project fdfrp on fdfrp.entity_id = release_node.nid
LEFT JOIN node project_node on project_node.nid = fdfrp.field_release_project_target_id
LEFT JOIN field_data_field_project_machine_name fdfpmn on fdfpmn.entity_id = project_node.nid
LEFT JOIN field_data_taxonomy_vocabulary_6 fdtv6 ON fdtv6.entity_id = release_node.nid
LEFT JOIN project_usage_week_project puwp on project_node.nid = puwp.nid AND puwp.tid = fdtv6.taxonomy_vocabulary_6_tid AND (puwp.timestamp = (SELECT MAX(puwp2.timestamp) FROM project_usage_week_project puwp2) OR puwp.timestamp IS NULL)

WHERE release_node.type = 'project_release'
AND ttd.name in ('7.x','8.x')
AND fdfrv.field_release_version_value != 'master'
AND fdfpmn.bundle in ('project_module','project_theme')
AND ttd.vid = 6
AND fdtv6.taxonomy_vocabulary_6_tid > 87
GROUP BY puwp.nid
ORDER BY fdtv6.taxonomy_vocabulary_6_tid, puwp.count DESC;

-- puwp.count DESC


SELECT * from project_dependency_dependency pdd
  LEFT JOIN project_dependency_component pdc on pdc.component_id = pdd.component_id
WHERE dependency like '%(1.x-dev%')


SELECT CONCAT('https://www.drupal.org/pift-ci-job/', pcj.job_id), pcj.*
FROM pift_ci_job pcj
WHERE pcj.job_id > 556005 AND pcj.status = 'error';

SELECT CONCAT( 'STRING{''}', lang, '{''}', ' INTO OUTFILE {''}', CAST(id AS CHAR), '_', lang, '.html{''};')

SELECT release_node.title, pdc.composer, pdc.name
FROM project_dependency_component pdc
  LEFT JOIN node release_node on release_node.nid = pdc.release_nid
WHERE LENGTH(pdc.composer) > 1


      and release_node.title = 'smart_ip 8.x-3.0';

SELECT pdc.composer FROM project_dependency_component pdc where pdc.component_id = pdc.component_id INTO OUTFILE '/tmp/composerfiles/'

SELECT pdc.composer FROM project_dependency_component pdc
  LEFT JOIN node release_node on release_node.nid = pdc.release_nid
WHERE release_node.title = 'acquiasdk 7.x-1.0'
INTO OUTFILE '/tmp/acquiadk/composer.json'
FIELDS TERMINATED BY '' OPTIONALLY ENCLOSED BY '' ESCAPED BY ''
LINES TERMINATED BY '';
SELECT CONCAT('SELECT composer FROM project_dependency_component WHERE component_id = ', pdc.component_id, ' INTO OUTFILE ''/tmp/composerfiles/',REPLACE(release_node.title,' ','_'),'_',pdc.name,'_', pdc.component_id,''' FIELDS TERMINATED BY '''' OPTIONALLY ENCLOSED BY '''' ESCAPED BY '''' LINES TERMINATED BY '''';')
FROM project_dependency_component pdc
  LEFT JOIN node release_node on release_node.nid = pdc.release_nid
WHERE LENGTH(pdc.composer) > 1
INTO OUTFILE '/tmp/composerquery';

SELECT LENGTH(composer) FROM project_dependency_component WHERE component_id = 289950

SELECT CONCAT('https://www.drupal.org/pift-ci-job/', pcj.job_id) From pift_ci_job pcj
WHERE pcj.job_id > 556005 AND pcj.status = 'error';

SELECT DISTINCT pcj.*,pcj.ci_url From pift_ci_job pcj
WHERE pcj.job_id > 559345 and pcj.result != 'pass'
      and pcj.status = 'error'
ORDER BY pcj.job_id DESC

-- Count of users sharing a zid + iid
SELECT COUNT(*) as `Users`, fdfdri.field_distil_reg_iid_value, fdfdrz.field_distil_reg_zid_value, GROUP_CONCAT(u.name),  GROUP_CONCAT(u.mail), GROUP_CONCAT(DISTINCT u.status)
FROM users u
  LEFT JOIN field_data_field_distil_reg_iid fdfdri ON fdfdri.entity_id = u.uid
  JOIN field_data_field_distil_reg_zid fdfdrz ON fdfdrz.entity_id = u.uid
GROUP BY fdfdri.field_distil_reg_iid_value, fdfdrz.field_distil_reg_zid_value
HAVING `Users` > 1;

-- Count of users sharing a zid
SELECT COUNT(*) as `Users`, fdfdrz.field_distil_reg_zid_value, GROUP_CONCAT(u.name),  GROUP_CONCAT(u.mail), GROUP_CONCAT(DISTINCT u.status)
FROM users u
  JOIN field_data_field_distil_reg_zid fdfdrz ON fdfdrz.entity_id = u.uid
GROUP BY fdfdrz.field_distil_reg_zid_value
HAVING `Users` > 1;

-- Count of users sharing an iid
SELECT COUNT(*) as `Users`, fdfdri.field_distil_reg_iid_value,  GROUP_CONCAT(u.name),  GROUP_CONCAT(u.mail), GROUP_CONCAT(DISTINCT u.status)
FROM users u
  JOIN field_data_field_distil_reg_iid fdfdri ON fdfdri.entity_id = u.uid
GROUP BY fdfdri.field_distil_reg_iid_value
HAVING `Users` > 1;


-- TOTAL Count of users sharing a zid + iid
SELECT SUM(zidiid.`Users`) FROM (
                                  SELECT COUNT(*) as `Users`, fdfdri.field_distil_reg_iid_value, fdfdrz.field_distil_reg_zid_value, GROUP_CONCAT(u.name),  GROUP_CONCAT(u.mail), GROUP_CONCAT(DISTINCT u.status)
                                  FROM users u
                                    LEFT JOIN field_data_field_distil_reg_iid fdfdri ON fdfdri.entity_id = u.uid
                                    JOIN field_data_field_distil_reg_zid fdfdrz ON fdfdrz.entity_id = u.uid
                                  GROUP BY fdfdri.field_distil_reg_iid_value, fdfdrz.field_distil_reg_zid_value
                                  HAVING `Users` > 1) as zidiid;

-- Count of users sharing a zid
SELECT SUM(zids.`Users`) FROM (
                                SELECT COUNT(*) as `Users`, fdfdrz.field_distil_reg_zid_value, GROUP_CONCAT(u.name),  GROUP_CONCAT(u.mail), GROUP_CONCAT(DISTINCT u.status)
                                FROM users u
                                  JOIN field_data_field_distil_reg_zid fdfdrz ON fdfdrz.entity_id = u.uid
                                GROUP BY fdfdrz.field_distil_reg_zid_value
                                HAVING `Users` > 1) as zids;

-- Count of users sharing a iid
SELECT SUM(iids.`Users`) FROM (
                                SELECT COUNT(*) as `Users`, fdfdri.field_distil_reg_iid_value,  GROUP_CONCAT(u.name),  GROUP_CONCAT(u.mail), GROUP_CONCAT(DISTINCT u.status)
                                FROM users u
                                  JOIN field_data_field_distil_reg_iid fdfdri ON fdfdri.entity_id = u.uid
                                  JOIN field_data_field_distil_reg_zid fdfdrz ON fdfdrz.entity_id = u.uid

                                GROUP BY fdfdri.field_distil_reg_iid_value
                                HAVING `Users` > 1) as iids;

SELECT * FROM comment c
  LEFT JOIN field_data_comment_body fdcb ON fdcb.entity_id = c.cid
WHERE c.uid = 391689
      AND comment_body_value LIKE '%gpl%'

SELECT fdfpmn.field_project_machine_name_value, MAX(FROM_UNIXTIME(n.created, '%Y-%m')) as `yearday`, n.* FROM node n
  LEFT JOIN field_data_field_release_project fdfrp ON fdfrp.entity_id = n.nid
  LEFT JOIN node project_node ON project_node.nid = fdfrp.field_release_project_target_id
  LEFT JOIN field_data_field_project_machine_name fdfpmn ON project_node.nid = fdfpmn.entity_id
WHERE n.type = 'project_release'
GROUP BY project_node.nid
HAVING `yearday` = '2016-12';


-- http://cgit.drupalcode.org/chosen/tree/composer.json?h=8.x-2.x
SELECT DISTINCT CONCAT('http://cgit.drupalcode.org/', pdc.name, '/tree/composer.json?h=', SUBSTRING_INDEX(fdfrv.field_release_version_value,'-dev',1))
FROM project_dependency_component pdc
  LEFT JOIN node release_node on release_node.nid = pdc.release_nid
  LEFT JOIN field_data_field_release_version fdfrv ON fdfrv.entity_id = pdc.release_nid
WHERE LENGTH(pdc.composer) > 1
      AND pdc.composer LIKE '%repositories%' and pdc.composer NOT LIKE '%"type": "composer",%' AND pdc.composer NOT LIKE '%git.drupal.org%'
      AND release_node.title LIKE '%7.x%'
      AND fdfrv.field_release_version_value LIKE '%-dev';


SELECT DISTINCT pdc.name
FROM project_dependency_component pdc
  LEFT JOIN node release_node on release_node.nid = pdc.release_nid
WHERE LENGTH(pdc.composer) > 1
      AND pdc.composer LIKE '%repositories%' and pdc.composer NOT LIKE '%"type": "composer",%' AND pdc.composer NOT LIKE '%git.drupal.org%'
      AND release_node.title LIKE '%7.x%';

select * from field_data_field_distil_reg_reported_ip fdfdrri
WHERE fdfdrri.field_distil_reg_reported_ip_value = '212.51.156.243'

SELECT * FROM versioncontrol_git_event_data vged
  LEFT JOIN versioncontrol_labels vl ON vl.label_id = vged.label_id
  LEFT JOIN versioncontrol_repositories vr ON vr.repo_id = vl.repo_id
  LEFT JOIN versioncontrol_release_labels vrl ON vrl.label_id = vl.label_id

-- LEFT JOIN versioncontrol_operation_labels vol ON vol.label_id = vl.label_id
WHERE vged.reftype =2 AND vr.name = 'webform'
      and vged.old_sha1 = '0000000000000000000000000000000000000000';

SELECT * FROM versioncontrol_git_event_data vged
  LEFT JOIN versioncontrol_labels vl ON vl.label_id = vged.label_id
  LEFT JOIN versioncontrol_repositories vr ON vr.repo_id = vl.repo_id
  LEFT JOIN versioncontrol_release_labels vrl ON vrl.label_id = vl.label_id
  LEFT JOIN versioncontrol_git_event_data vged2 ON vged2.new_sha1 = vged.new_sha1
-- LEFT JOIN versioncontrol_operation_labels vol ON vol.label_id = vl.label_id
WHERE vged.reftype =2 AND vr.name = 'webform'
      and vged.old_sha1 = '0000000000000000000000000000000000000000' and vged2.old_sha1 != '0000000000000000000000000000000000000000';

SELECT * FROM node issue_node
  LEFT JOIN field_data_field_project fdfp ON fdfp.entity_id = issue_node.nid
  LEFT JOIN field_data_field_issue_version fdfiv ON fdfiv.entity_id = issue_node.nid
WHERE fdfp.field_project_target_id = 3060
      and fdfiv.field_issue_version_value = '8.2.x'

SELECT COUNT(*) AS `Jobs`, pcj.status FROM pift_ci_job pcj GROUP BY pcj.status;


SELECT FROM_UNIXTIME(pcj.updated), FROM_UNIXTIME(pcj.created), release_node.title, pcj.*
FROM pift_ci_job pcj
  LEFT JOIN node release_node on release_node.nid = pcj.release_nid
WHERE pcj.status REGEXP 'sent|running|complete'
      AND pcj.updated > 1484513701
      and issue_nid IS NOT NULL;


SELECT FROM_UNIXTIME(n.created), n.* from node n where n.type = 'project_release' and n.title LIKE '%8.4%'
ORDER by n.nid DESC;


UPDATE field_data_comment_body fdcb SET fdcb.comment_body_value = '<a href="https://groups.drupal.org/node/515932">Drupal 8.3.0-alpha1</a> will be released the week of January 30, 2017, which means new developments and disruptive changes should now be targeted against the 8.4.x-dev branch. For more information see the <a href="/core/release-cycle-overview#minor">Drupal 8 minor version schedule</a> and the <a href="/core/d8-allowed-changes">Allowed changes during the Drupal 8 release cycle</a>.'
WHERE fdcb.comment_body_value = '<a href="https://groups.drupal.org/node/515932">Drupal 8.3.0-alpha1</a> will be released the week of January 30, 2016, which means new developments and disruptive changes should now be targeted against the 8.4.x-dev branch. For more information see the <a href="/core/release-cycle-overview#minor">Drupal 8 minor version schedule</a> and the <a href="/core/d8-allowed-changes">Allowed changes during the Drupal 8 release cycle</a>.';

UPDATE field_revision_comment_body frcb SET frcb.comment_body_value = '<a href="https://groups.drupal.org/node/515932">Drupal 8.3.0-alpha1</a> will be released the week of January 30, 2017, which means new developments and disruptive changes should now be targeted against the 8.4.x-dev branch. For more information see the <a href="/core/release-cycle-overview#minor">Drupal 8 minor version schedule</a> and the <a href="/core/d8-allowed-changes">Allowed changes during the Drupal 8 release cycle</a>.'
WHERE frcb.comment_body_value = '<a href="https://groups.drupal.org/node/515932">Drupal 8.3.0-alpha1</a> will be released the week of January 30, 2016, which means new developments and disruptive changes should now be targeted against the 8.4.x-dev branch. For more information see the <a href="/core/release-cycle-overview#minor">Drupal 8 minor version schedule</a> and the <a href="/core/d8-allowed-changes">Allowed changes during the Drupal 8 release cycle</a>.'

SELECT count(*) from cache_field;

SELECT project_release.title, MAX(release_nid), pdc.*, pdd.core_api
FROM project_dependency_dependency pdd
  LEFT JOIN project_dependency_component pdc on pdc.component_id = pdd.component_id
  LEFT JOIN node project_release ON project_release.nid = pdc.release_nid
WHERE pdd.dependency LIKE '%aes'
      AND pdd.core_api IN ('7.x','8.x')
GROUP BY pdc.name, pdd.core_api;

SELECT * from pift_ci_job pcj
WHERE pcj.build_details IS NOT NULL and pcj.build_details != '';

SELECT * from versioncontrol_item_revisions vir WHERE vir.path LIKE '.eslint%';
