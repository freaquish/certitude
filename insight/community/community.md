###Community

**Authors :** Piyush Jaiswal and Suyash Maddhessiya

Community Managers handles all the operations plausible in community except\
community leaderboard. The scope of operation depends upon user running the\
respective command.

```python
from insight.models import Account 
from insight.community.main import CommunityManager
user = Account()  # The commanding user
community = CommunityManager(user)
```

Operations supported by **Community Manager** are 
- Checking Existance of tag
- Creation of Community
- Edit Community details
- Join Community
- Include Community Member in Community Team 
- Edit Team members data 
- Remove team member from Community team
- Leave community

#####Creation of Community
Create Community API will create community with given data. Creation of community will
be followed with creation of teams and assigning the user instance in community manager
as default head and first team member.

Required parameters for this api are:
- Name
- Tag, must be unique and will be noticed using '@'
- Description 
- Image, profile image of Community
- Hobbies, list of code_names of Hobby

```python
new_community = community.create({
  'name': '__name__', 
  'tag': '__tag__',
  'image': '__image__',
  'description': '__description__',
  'hobbies': []
})
```

#####Edit Community details

Edit API allows team members of community to edit tag, image, description,
name or hobbies. If the changed data contains tag, then program will check
the uniqueness of tag using `community.tag_exit(tag:str)` method. Program first
confirms the user must be a team member

```python
change = community.edit(**change)
```

#####Join Community

API allows user in the instance to join any community by providing `community_id`

```python
community.join('__community_id__')
```

#####Include Community Member in Community Team 

Inclusion of Community Member in Team will only be done by Community Head. Program will check 
the user instance is community head and member_id is not present in community team, then only
program will include member in team by creating `TeamMember`

```python
community.include_member_in_team('__community_id__','__member_id__')
```

#####Edit Team members data 

Edit Team members data will be performed by the respective team member allowing only to change
his data. Member could change position and description, provided position shouldn't be `Head`.

```python
community.edit_team_data('__community_id__',{})
```

#####Remove team member from Community team 

Removing team member is crucial operation to be performed only by community head. Likewise inclusion
this operation will only be performed by Head.

```python
community.remove_team_member('__community_id__', '__member_id__')
```

#####Leave community

Leaving community is more important than joining thus respecting the will of user.
Check user is comunity member and later if team member than delete both data.

```python
community.leave_community('__community_id__')
```

####Future

Most important feature is the ability to monitor actions performed in community, which later will be used
to judge the quality of community within each hobbies.