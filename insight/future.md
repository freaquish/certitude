### Code Improvements for efficiency Proposal

#####1. Use of `select_related`
`selecte_related` is django model lookup function in QuerySet to increase the efficiency
every time we enquire any **ForeignKey** Database is queried. 

For e.g
```python 
from insight.models import ScorePost
from django.db.models import QuerySet
score_posts: QuerySet = ScorePost.objects.all()
posts = []
for score_post in score_posts:
     posts.append(score_post.post)  # This line will enquire Database
```
For ideal case,
if cost of enquiring **FKey** is *C* , then it will add the cost for `len(score_posts)`

`total_cost = O(cost_of_score_posts_enquiry) + len(score_posts)*O(c)`
 
 We can reduce the total cost by using `select_related` as
 
 The `O_new(cost_if_score_post_enquiry) = O(cost_of_score_posts_enquiry) + O(k)` but `O(k) << O(c)`
 
 ```python
from insight.models import ScorePost
from django.db.models import QuerySet
score_posts: QuerySet = ScorePost.objects.all().select_related('post')
posts = []
for score_post in score_posts:
     posts.append(score_post.post)  # This line won't call Database

```


