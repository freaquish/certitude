##Competition

Competition is hosted by user/club. Competitions are strict in their horizontal and have certain limitations.

####Model:
  * Competition Id `(22 Char, primary_key)`
  * Name
  * Tag `(unique)`
  * host_account `Fkey(Account)` Team Head if hosted by club
  * host_club `FKey[Club]`
  * participants `M2M(Account)`
  * posts `M2M(Post)`
  * start_date_time
  * end_date_time
  * results_date_time
  * hobbies `M2M[Hobby]`
  * scope 
       * 0 Global
       * 0.5 
       * 1 Community or Users follower / following
  * Max post per user
  * Rules
  * About
  * Image
  * Ranks `M2m(Competition Rank)`
  * Banned Post `M2M (Banned Post)`
  * Banned Users `M2m (Account)`
  * Unique Post only :
      * Allow only if post is submitted in this competition and check post before submitting


####Banned Post:
  * Post
  * reason
  * banned_on

####Competition Rank: 
  * Account `Fkey(Account)`
  * Rank
  * Score
  * declared `DateTime`
  


  
  