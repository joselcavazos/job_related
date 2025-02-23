With OU as (select distinct sfid,name,unnest(string_to_array(operating_units__c, ';')) as unique_ou from eospilot.team_role__c where active__c = TRUE)
select distinct
CASE
  When Role_Org62.sfid is null then 'Create Team Role in Org62'
  When Role_EOS.name != Role_Org62.name then 'Update Team Role Name after Validation Rule is desactivate'
  ELSE 'Update Team Role in Org62 based on EOS'
End as TOPS_Comment,
  Role_EOS.sfid as EOS_Team_Role_ID,
  Role_Org62.sfid as Org62_Team_Role_ID,
  Role_EOS.name as EOS_Team_Role_Name,
  Role_Org62.name as Org62_Team_Role_Name,
  Role_EOS.sellingrolegroup__c as EOS_Selling_Role_Group,
  Role_Org62.sellingrolegroup__c as Org62_Selling_Role_Group,
  Role_EOS.operating_units__c as EOS_Team_Role_Operating_Units,
  Role_Org62.operating_units__c as Org62_Team_Role_Operating_Units,
  Role_EOS.group__c as EOS_Team_Role_Group,
  Role_Org62.group__c as Org62_Team_Role_Group,
  role_eos.exclude_role_reasons__c as EOS_Team_Role_Exclude_Role_Reasons,
  Role_Org62.excluderolereasons__c as Org62_Team_Role_Exclude_Role_Reasons,
  Role_EOS.mastercarveenabled__c as EOS_Master_Carve_Enabled,
  Role_Org62.mastercarveenabled__c as Org62_Master_Carve_Enabled,
  Role_EOS.following__c as EOS_Team_Role_Following,
  Role_Org62.following__c as Org62_Team_Role_Following,
  Role_EOS.prefix__c as EOS_Team_Role_Prefix,
  Role_Org62.prefix__c as Org62_Team_Role_Prefix,
  CASE
    when Role_EOS.territory_usage_type__c = 'a1td00000000WFYAA2' then 'Sales'
    when Role_EOS.territory_usage_type__c = 'a1t0W000003kut2QAA' then 'Non Carved'
  End as EOS_Team_Role_Territory_Usage_Type,
  CASE
    when Role_Org62.Territory_Usage_Type__c = 'aFF300000004C93GAE' then 'Sales'
    when Role_Org62.Territory_Usage_Type__c = 'aFF0M000000CaRHWA0' then 'Non Carved'
  End as Org62_Team_Role_Territory_Usage_Type
from (select * from eospilot.team_role__c where active__c = TRUE) as Role_EOS
LEFT JOIN org62.team_role__c as Role_Org62
  on Role_EOS.planning_org_xref__c = Role_Org62.planning_org_xref__c
Left JOIN OU ou
  on Role_EOS.sfid = ou.sfid
where (Role_Org62.sfid is null and Role_EOS.active__c is TRUE) or
   coalesce(Role_EOS.name,'') != coalesce(Role_Org62.name,'') or
--   (Role_EOS.active__c = true and Role_Org62.active__c = false) or    -- Leave previous year Team Role active
   coalesce(Role_EOS.following__c,'') != coalesce(Role_Org62.following__c,'') or
 --  coalesce(Role_EOS.operating_units__c,'') != coalesce(Role_Org62.operating_units__c,'') or
   coalesce(Role_Org62.operating_units__c,'') not LIKE '%'|| unique_ou ||'%' or
   coalesce(Role_EOS.group__c,'') != coalesce(Role_Org62.group__c,'') or
   coalesce(role_eos.exclude_role_reasons__c,'') != coalesce(Role_Org62.excluderolereasons__c,'') or
   coalesce(Role_EOS.prefix__c,'') != coalesce(Role_Org62.prefix__c,'') or
   coalesce(Role_EOS.sellingrolegroup__c,'') != coalesce(Role_Org62.sellingrolegroup__c,'') or
   Role_EOS.mastercarveenabled__c != Role_Org62.mastercarveenabled__c or
      (Role_EOS.territory_usage_type__c = 'a1td00000000WFYAA2' and Role_Org62.Territory_Usage_Type__c = 'aFF0M000000CaRHWA0') or
      (Role_EOS.territory_usage_type__c = 'a1t0W000003kut2QAA' and Role_Org62.Territory_Usage_Type__c = 'aFF300000004C93GAE')
      