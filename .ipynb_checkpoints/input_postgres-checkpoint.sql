-- VAL 28

with Setting_Auto_Act_EOS as (Select name,unnest(string_to_array(active_team_roles__c, ';')) as value
from eospilot.team_settings__c
where name in ('AutomatedAccountModelTeamSettings')),
Setting_Auto_Co_EOS as (Select name,unnest(string_to_array(co_prime_territories__c, ';')) as value
from eospilot.team_settings__c
where name in ('AutomatedAccountModelTeamSettings')),
Setting_Team_Act_EOS as (Select name,unnest(string_to_array(active_team_roles__c, ';')) as value
from eospilot.team_settings__c
where name in ('Team Account Model Settings')),
Setting_Team_Co_EOS as (Select name,unnest(string_to_array(co_prime_territories__c, ';')) as value
from eospilot.team_settings__c
where name in ('Team Account Model Settings')),
team_eos as (Select name
from eospilot.team_role__c
where left(territory_usage_type__c,15) = 'a1td00000000WFY' and active__c = TRUE )
Select 'To be Removed from Team Setting' as "Comment",eos.name as "Records",'Active Team Role' as "Field",eos.value
from Setting_Auto_Act_EOS eos
left join team_eos team
on eos.value = team.name
where team.name is null
UNION
Select 'To be Added in Team Setting','AutomatedAccountModelTeamSettings','Active Team Role',team.name
from team_eos team
left join Setting_Auto_Act_EOS eos
on eos.value = team.name
where eos.name is null
UNION
Select 'To be Removed from Team Setting' as "Comment",eos.name,'Co-Prime Territories',eos.value
from Setting_Auto_Co_EOS eos
left join team_eos team
on eos.value = team.name
where team.name is null
UNION
Select 'To be Added in Team Setting','AutomatedAccountModelTeamSettings','Co-Prime Territories',team.name
from team_eos team
left join Setting_Auto_Co_EOS  eos
on eos.value = team.name
where eos.name is null
UNION
Select 'To be Removed from Team Setting' as "Comment",eos.name as "Records",'Active Team Role',eos.value
from Setting_Team_Act_EOS eos
left join team_eos team
on eos.value = team.name
where team.name is null
UNION
Select 'To be Added in Team Setting','Team Account Model Settings','Active Team Role',team.name
from team_eos team
left join Setting_Team_Act_EOS eos
on eos.value = team.name
where eos.name is null
UNION
Select 'To be Removed from Team Setting' as "Comment",eos.name,'Co-Prime Territories',eos.value
from Setting_Team_Co_EOS eos
left join team_eos team
on eos.value = team.name
where team.name is null
UNION
Select 'To be Added in Team Setting','Team Account Model Settings','Co-Prime Territories',team.name
from  team_eos team
left join Setting_Team_Co_EOS eos
on eos.value = team.name
where eos.name is null

