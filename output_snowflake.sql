/* VAL 28 */ WITH Setting_Auto_Act_EOS AS
  (SELECT name,
          IFF(_u.pos = _u_2.pos_2, _u_2.value, NULL) AS value
   FROM EDH_PRD.SHARED.EOS_TEAM_SETTINGS__C
   CROSS JOIN TABLE(FLATTEN(INPUT => ARRAY_GENERATE_RANGE(0, (GREATEST(ARRAY_SIZE(STRING_TO_ARRAY(active_team_roles__c, ';'))) - 1) + 1))) AS _u(seq, KEY, PATH, INDEX, pos, this)
   CROSS JOIN TABLE(FLATTEN(INPUT => STRING_TO_ARRAY(active_team_roles__c, ';'))) AS _u_2(seq, KEY, PATH, pos_2, value, this)
   WHERE name IN ('AutomatedAccountModelTeamSettings')
     AND (_u.pos = _u_2.pos_2
          OR (_u.pos > (ARRAY_SIZE(STRING_TO_ARRAY(active_team_roles__c, ';')) - 1)
              AND _u_2.pos_2 = (ARRAY_SIZE(STRING_TO_ARRAY(active_team_roles__c, ';')) - 1)))),
                  Setting_Auto_Co_EOS AS
  (SELECT name,
          IFF(_u.pos = _u_2.pos_2, _u_2.value, NULL) AS value
   FROM EDH_PRD.SHARED.EOS_TEAM_SETTINGS__C
   CROSS JOIN TABLE(FLATTEN(INPUT => ARRAY_GENERATE_RANGE(0, (GREATEST(ARRAY_SIZE(STRING_TO_ARRAY(co_prime_territories__c, ';'))) - 1) + 1))) AS _u(seq, KEY, PATH, INDEX, pos, this)
   CROSS JOIN TABLE(FLATTEN(INPUT => STRING_TO_ARRAY(co_prime_territories__c, ';'))) AS _u_2(seq, KEY, PATH, pos_2, value, this)
   WHERE name IN ('AutomatedAccountModelTeamSettings')
     AND (_u.pos = _u_2.pos_2
          OR (_u.pos > (ARRAY_SIZE(STRING_TO_ARRAY(co_prime_territories__c, ';')) - 1)
              AND _u_2.pos_2 = (ARRAY_SIZE(STRING_TO_ARRAY(co_prime_territories__c, ';')) - 1)))),
                  Setting_Team_Act_EOS AS
  (SELECT name,
          IFF(_u.pos = _u_2.pos_2, _u_2.value, NULL) AS value
   FROM EDH_PRD.SHARED.EOS_TEAM_SETTINGS__C
   CROSS JOIN TABLE(FLATTEN(INPUT => ARRAY_GENERATE_RANGE(0, (GREATEST(ARRAY_SIZE(STRING_TO_ARRAY(active_team_roles__c, ';'))) - 1) + 1))) AS _u(seq, KEY, PATH, INDEX, pos, this)
   CROSS JOIN TABLE(FLATTEN(INPUT => STRING_TO_ARRAY(active_team_roles__c, ';'))) AS _u_2(seq, KEY, PATH, pos_2, value, this)
   WHERE name IN ('Team Account Model Settings')
     AND (_u.pos = _u_2.pos_2
          OR (_u.pos > (ARRAY_SIZE(STRING_TO_ARRAY(active_team_roles__c, ';')) - 1)
              AND _u_2.pos_2 = (ARRAY_SIZE(STRING_TO_ARRAY(active_team_roles__c, ';')) - 1)))),
                  Setting_Team_Co_EOS AS
  (SELECT name,
          IFF(_u.pos = _u_2.pos_2, _u_2.value, NULL) AS value
   FROM EDH_PRD.SHARED.EOS_TEAM_SETTINGS__C
   CROSS JOIN TABLE(FLATTEN(INPUT => ARRAY_GENERATE_RANGE(0, (GREATEST(ARRAY_SIZE(STRING_TO_ARRAY(co_prime_territories__c, ';'))) - 1) + 1))) AS _u(seq, KEY, PATH, INDEX, pos, this)
   CROSS JOIN TABLE(FLATTEN(INPUT => STRING_TO_ARRAY(co_prime_territories__c, ';'))) AS _u_2(seq, KEY, PATH, pos_2, value, this)
   WHERE name IN ('Team Account Model Settings')
     AND (_u.pos = _u_2.pos_2
          OR (_u.pos > (ARRAY_SIZE(STRING_TO_ARRAY(co_prime_territories__c, ';')) - 1)
              AND _u_2.pos_2 = (ARRAY_SIZE(STRING_TO_ARRAY(co_prime_territories__c, ';')) - 1)))),
                  team_eos AS
  (SELECT name
   FROM EDH_PRD.SHARED.EOS_TEAM_ROLE__C
   WHERE LEFT(territory_usage_type__c, 15) = 'a1td00000000WFY'
     AND active__c = TRUE)
SELECT 'To be Removed from Team Setting' AS "Comment",
       eos.name AS "Records",
       'Active Team Role' AS "Field",
       eos.value
FROM Setting_Auto_Act_EOS AS eos
LEFT JOIN team_eos AS team ON eos.value = team.name
WHERE team.name IS NULL
UNION
SELECT 'To be Added in Team Setting',
       'AutomatedAccountModelTeamSettings',
       'Active Team Role',
       team.name
FROM team_eos AS team
LEFT JOIN Setting_Auto_Act_EOS AS eos ON eos.value = team.name
WHERE eos.name IS NULL
UNION
SELECT 'To be Removed from Team Setting' AS "Comment",
       eos.name,
       'Co-Prime Territories',
       eos.value
FROM Setting_Auto_Co_EOS AS eos
LEFT JOIN team_eos AS team ON eos.value = team.name
WHERE team.name IS NULL
UNION
SELECT 'To be Added in Team Setting',
       'AutomatedAccountModelTeamSettings',
       'Co-Prime Territories',
       team.name
FROM team_eos AS team
LEFT JOIN Setting_Auto_Co_EOS AS eos ON eos.value = team.name
WHERE eos.name IS NULL
UNION
SELECT 'To be Removed from Team Setting' AS "Comment",
       eos.name AS "Records",
       'Active Team Role',
       eos.value
FROM Setting_Team_Act_EOS AS eos
LEFT JOIN team_eos AS team ON eos.value = team.name
WHERE team.name IS NULL
UNION
SELECT 'To be Added in Team Setting',
       'Team Account Model Settings',
       'Active Team Role',
       team.name
FROM team_eos AS team
LEFT JOIN Setting_Team_Act_EOS AS eos ON eos.value = team.name
WHERE eos.name IS NULL
UNION
SELECT 'To be Removed from Team Setting' AS "Comment",
       eos.name,
       'Co-Prime Territories',
       eos.value
FROM Setting_Team_Co_EOS AS eos
LEFT JOIN team_eos AS team ON eos.value = team.name
WHERE team.name IS NULL
UNION
SELECT 'To be Added in Team Setting',
       'Team Account Model Settings',
       'Co-Prime Territories',
       team.name
FROM team_eos AS team
LEFT JOIN Setting_Team_Co_EOS AS eos ON eos.value = team.name
WHERE eos.name IS NULL