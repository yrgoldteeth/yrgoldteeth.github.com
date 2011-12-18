---
layout: post
title: Will Paginate link renderer for Twitter Bootstrap
---

#### {{ page.title }}

The [will_paginate][wp] library makes adding pagination functionality to 
Rails apps (and other Ruby frameworks) a breeze.  Recently I have been working
on an app using Twitter's [Bootstrap][bs] styling framework, and had a need
for some pagination.  I dropped the method for the page links into a 
<code>.pagination</code> div and saw this:  

<img src='/images/bootstrap-will-paginate-before.jpg' alt='twitter-bootstrap-before' />

That was decidedly not what I was looking for, so I reached out to Google and found
Isaac Bowen's [solution][is], which worked exactly as advertised:  

<img src='/images/bootstrap-will-paginate-after.jpg' alt='twitter-bootstrap-after' />

As I've already found this solution useful in at least two different projects,
I decided to wire it all up into a Rails engine and release it as a [gem][gem]. 
Just add <code>bootstrap-will_paginate</code> to your Rails project's Gemfile
and you're ready to go.

[gem]: http://github.com/yrgoldteeth/bootstrap-will_paginate
[wp]: http://github.com/mislav/will_paginate
[bs]: http://twitter.github.com/bootstrap
[is]: http://isaacbowen.com/blog/using-will_paginate-action_view-and-bootstrap
