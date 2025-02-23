WITH OU AS
  (SELECT DISTINCT ID,
                   name,
                   IFF(_u.pos = _u_2.pos_2, _u_2.unique_ou, NULL) AS unique_ou
   FROM EDH_PRD.SHARED.EOS_TEAM_ROLE__C
   CROSS JOIN TABLE(FLATTEN(INPUT => ARRAY_GENERATE_RANGE(0, (GREATEST(ARRAY_SIZE(STRING_TO_ARRAY(operating_units__c, ';'))) - 1) + 1))) AS _u(seq, KEY, PATH, INDEX, pos, this)
   CROSS JOIN TABLE(FLATTEN(INPUT => STRING_TO_ARRAY(operating_units__c, ';'))) AS _u_2(seq, KEY, PATH, pos_2, unique_ou, this)
   WHERE active__c = TRUE
     AND (_u.pos = _u_2.pos_2
          OR (_u.pos > (ARRAY_SIZE(STRING_TO_ARRAY(operating_units__c, ';')) - 1)
              AND _u_2.pos_2 = (ARRAY_SIZE(STRING_TO_ARRAY(operating_units__c, ';')) - 1))))
SELECT DISTINCT CASE
                    WHEN Role_Org62.ID IS NULL THEN 'Create Team Role in Org62'
                    WHEN Role_EOS.name <> Role_Org62.name THEN 'Update Team Role Name after Validation Rule is desactivate'
                    ELSE 'Update Team Role in Org62 based on EOS'
                END AS TOPS_Comment,
                Role_EOS.ID AS EOS_Team_Role_ID,
                Role_Org62.ID AS Org62_Team_Role_ID,
                Role_EOS.name AS EOS_Team_Role_Name,
                Role_Org62.name AS Org62_Team_Role_Name,
                Role_EOS.sellingrolegroup__c AS EOS_Selling_Role_Group,
                Role_Org62.sellingrolegroup__c AS Org62_Selling_Role_Group,
                Role_EOS.operating_units__c AS EOS_Team_Role_Operating_Units,
                Role_Org62.operating_units__c AS Org62_Team_Role_Operating_Units,
                Role_EOS.group__c AS EOS_Team_Role_Group,
                Role_Org62.group__c AS Org62_Team_Role_Group,
                role_eos.exclude_role_reasons__c AS EOS_Team_Role_Exclude_Role_Reasons,
                Role_Org62.excluderolereasons__c AS Org62_Team_Role_Exclude_Role_Reasons,
                Role_EOS.mastercarveenabled__c AS EOS_Master_Carve_Enabled,
                Role_Org62.mastercarveenabled__c AS Org62_Master_Carve_Enabled,
                Role_EOS.following__c AS EOS_Team_Role_Following,
                Role_Org62.following__c AS Org62_Team_Role_Following,
                Role_EOS.prefix__c AS EOS_Team_Role_Prefix,
                Role_Org62.prefix__c AS Org62_Team_Role_Prefix,
                CASE
                    WHEN Role_EOS.territory_usage_type__c = 'a1td00000000WFYAA2' THEN 'Sales'
                    WHEN Role_EOS.territory_usage_type__c = 'a1t0W000003kut2QAA' THEN 'Non Carved'
                END AS EOS_Team_Role_Territory_Usage_Type,
                CASE
                    WHEN Role_Org62.Territory_Usage_Type__c = 'aFF300000004C93GAE' THEN 'Sales'
                    WHEN Role_Org62.Territory_Usage_Type__c = 'aFF0M000000CaRHWA0' THEN 'Non Carved'
                END AS Org62_Team_Role_Territory_Usage_Type
FROM
  (SELECT *
   FROM EDH_PRD.SHARED.EOS_TEAM_ROLE__C
   WHERE active__c = TRUE) AS Role_EOS
LEFT JOIN SSE_PRD.ODS.ORG62_TEAM_ROLE__C AS Role_Org62 ON Role_EOS.planning_org_xref__c = Role_Org62.planning_org_xref__c
LEFT JOIN OU AS ou ON Role_EOS.ID = ou.ID
WHERE (Role_Org62.ID IS NULL
       AND Role_EOS.active__c IS TRUE)
  OR COALESCE(Role_EOS.name, '') <> COALESCE(Role_Org62.name, '')
  OR COALESCE(Role_EOS.following__c, '') /*   (Role_EOS.active__c = true and Role_Org62.active__c = false) or    -- Leave previous year Team Role active */ <> COALESCE(Role_Org62.following__c, '')
  OR NOT COALESCE(Role_Org62.operating_units__c, '') /*  coalesce(Role_EOS.operating_units__c,'') != coalesce(Role_Org62.operating_units__c,'') or */ LIKE '%' || unique_ou || '%'
  OR COALESCE(Role_EOS.group__c, '') <> COALESCE(Role_Org62.group__c, '')
  OR COALESCE(role_eos.exclude_role_reasons__c, '') <> COALESCE(Role_Org62.excluderolereasons__c, '')
  OR COALESCE(Role_EOS.prefix__c, '') <> COALESCE(Role_Org62.prefix__c, '')
  OR COALESCE(Role_EOS.sellingrolegroup__c, '') <> COALESCE(Role_Org62.sellingrolegroup__c, '')
  OR Role_EOS.mastercarveenabled__c <> Role_Org62.mastercarveenabled__c
  OR (Role_EOS.territory_usage_type__c = 'a1td00000000WFYAA2'
      AND Role_Org62.Territory_Usage_Type__c = 'aFF0M000000CaRHWA0')
  OR (Role_EOS.territory_usage_type__c = 'a1t0W000003kut2QAA'
      AND Role_Org62.Territory_Usage_Type__c = 'aFF300000004C93GAE')