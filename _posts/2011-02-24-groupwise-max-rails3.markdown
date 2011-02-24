---
layout: post
title: Finding The Group-wise Maximum in Rails3 / Arel
---

## {{ page.title }}

[cross posted at Isotope11's blog](http://www.isotope11.com/blog/group-wise-max-rails3)

Recently at work we ran across a situation where we needed an efficient way
to find the [Group-wise maximum of a certain column](http://dev.mysql.com/doc/refman/5.0/en/example-maximum-column-group-row.html)
in an efficient manner.  After fighting with and realizing that there is apparently no way to make MySQL
combine a ORDER BY statement play nicely with GROUP BY statements, we were able to get the results with two queries,
but due to the volume of data, this would eventually have too much overhead to be sustainable.  
Once I determined that using a left join on itself would be the way to go at the problem, I set 
out to figure out the solution using the new [Arel syntax](https://github.com/rails/arel).

### Example

This example uses two models, ParentThing and ChildThing, with ChildThing being a basic key-value store.
ChildThings can have duplicate rows with the same key, and we were looking to return only the newest
results for each distinct key found in the ParentThing's ChildThings.

    class ParentThing < ActiveRecord::Base
      has_many :child_things
    end

    class ChildThing < ActiveRecord::Base
      belongs_to :parent_thing
    end

The solution was to add a single named scope to the ChildThing class:
    
    class ChildThing < ActiveRecord::Base
      belongs_to :parent_thing

      scope :newest_results, 
        joins('LEFT JOIN child_things c2 ON child_things.key = c2.key AND child_things.created_at > c2.created_at'),
        where('c2.key is NULL')
    
    end

So, now if p is an instance of ParentThing: 

    p.child_things.newest_results 

will return a collection that contains the newest created ChildThing for each disparate key in the ParentThing's ChildThing
full collection.

