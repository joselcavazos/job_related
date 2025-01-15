With IC as (Select
t.sfid,
t.name,
t.mastercarves__c,
concat(m.name,'(',m.sfid,');') as key,
m.name as MC,
m.sfid as MC_ID,
unnest(string_to_array(t.mastercarves__c, ';')) as unique_MC,
t.parent_territory__c
from EOSPILOT.territory__c t
left join EOSPILOT.master_carve__c m
on t.master_carve__c = m.sfid
where t.territory_classification__c = 'Core AE')
Select
case
when t1.mastercarves__c not LIKE '%'||t1.key||'%' and t1.MC is not null then 'Child issue'
when t2.mastercarves__c not LIKE '%'|| t1.unique_MC ||'%' then Concat('Value Missing on the Parent : ',t1.unique_MC)
end as Tops_Comment,
t1.sfid as "Child Territory ID",
t1.name as "Child Territory Name",
t1.mastercarves__c as "Child Territory Master Carve Field",
t1.MC as "Child Master Carve Name",
t1.MC_ID as "Child Master Carve ID",
t2.name as "Parent Territory Name",
t2.mastercarves__c as "Parent Territory Master Carve Field",
t1.unique_MC,
t1.key
from IC t1
join EOSPILOT.territory__c t2
on t1.parent_territory__c = t2.sfid
where ((t1.mastercarves__c not LIKE '%'||t1.key||'%' and t1.MC is not null) or t2.mastercarves__c not LIKE '%'||t1.unique_MC||'%')