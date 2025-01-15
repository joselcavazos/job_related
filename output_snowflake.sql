WITH IC AS
  (SELECT t.sfid,
          t.name,
          t.mastercarves__c,
          CONCAT(COALESCE(m.name, ''), COALESCE('(', ''), COALESCE(m.sfid, ''), COALESCE(');', '')) AS KEY,
          m.name AS MC,
          m.sfid AS MC_ID,
          IFF(_u.pos = _u_2.pos_2, _u_2.unique_MC, NULL) AS unique_MC,
          t.parent_territory__c
   FROM EDH_PRD.SHARED.EOS_TERRITORY__C AS t
   LEFT JOIN EDH_PRD.SHARED.EOS_MASTER_CARVE__C AS m ON t.master_carve__c = m.sfid
   CROSS JOIN TABLE(FLATTEN(INPUT => ARRAY_GENERATE_RANGE(0, (GREATEST(ARRAY_SIZE(STRING_TO_ARRAY(t.mastercarves__c, ';'))) - 1) + 1))) AS _u(seq, KEY, PATH, INDEX, pos, this)
   CROSS JOIN TABLE(FLATTEN(INPUT => STRING_TO_ARRAY(t.mastercarves__c, ';'))) AS _u_2(seq, KEY, PATH, pos_2, unique_MC, this)
   WHERE t.territory_classification__c = 'Core AE'
     AND (_u.pos = _u_2.pos_2
          OR (_u.pos > (ARRAY_SIZE(STRING_TO_ARRAY(t.mastercarves__c, ';')) - 1)
              AND _u_2.pos_2 = (ARRAY_SIZE(STRING_TO_ARRAY(t.mastercarves__c, ';')) - 1))))
SELECT CASE
           WHEN NOT t1.mastercarves__c LIKE '%' || t1.key || '%'
                AND NOT t1.MC IS NULL THEN 'Child issue'
           WHEN NOT t2.mastercarves__c LIKE '%' || t1.unique_MC || '%' THEN CONCAT(COALESCE('Value Missing on the Parent : ', ''), COALESCE(t1.unique_MC, ''))
       END AS Tops_Comment,
       t1.sfid AS "Child Territory ID",
       t1.name AS "Child Territory Name",
       t1.mastercarves__c AS "Child Territory Master Carve Field",
       t1.MC AS "Child Master Carve Name",
       t1.MC_ID AS "Child Master Carve ID",
       t2.name AS "Parent Territory Name",
       t2.mastercarves__c AS "Parent Territory Master Carve Field",
       t1.unique_MC,
       t1.key
FROM IC AS t1
JOIN EDH_PRD.SHARED.EOS_TERRITORY__C AS t2 ON t1.parent_territory__c = t2.sfid
WHERE ((NOT t1.mastercarves__c LIKE '%' || t1.key || '%'
        AND NOT t1.MC IS NULL)
       OR NOT t2.mastercarves__c LIKE '%' || t1.unique_MC || '%')