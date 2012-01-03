---
layout: post
title: CSS3 Progress Bars for Rails
---

<link href='/stylesheets/css3-progress-bar.css' rel='stylesheet' type='text/css' />

#### {{ page.title }}

When one of us at [Isotope11][iso] runs across something interesting or useful on the internet,
we'll send the link to all the other devs.  Over the recent holiday, [Josh][josh] sent a link to
another [Josh][ds] and his new fancy [CSS3 Progress Bars][dsblog].  I had an immediate need for 
something like this in a Rails project, so I wrote some helper methods to generate the HTML with 
some simple options.  

I created a gem, [css3-progress-bar-rails][gh] that can be dropped into a Rails 3.1+ project to
utilize these status bars.  To install, add 'css3-progress-bar-rails' to your Gemfile, and add
require 'css3-progress-bar' into your application.css, so that the CSS is picked up by the Rails
asset pipeline.  

**Examples**  

    <%= progress_bar(55) %>  

<div class='bar_container'>
  <div class='bar_mortice'>
    <div class='progress' style='width: 55%;'></div>
  </div>
</div>  
<br />
    
    <%= progress_bar(33, :color => 'blue', :rounded => true) %>  

<div class='bar_container rounded_bar_container blue_container'>
  <div class='bar_mortice rounded blue_mortice'>
    <div class='progress rounded blue' style='width: 33%;'></div>
  </div>
</div>
<br />

    <%= progress_bar(83, :color => 'orange', :rounded => true, :tiny => true) %>   

<div class='bar_container rounded_bar_container orange_container container_tiny'>
  <div class='bar_mortice rounded orange_mortice mortice_tiny'>
    <div class='progress rounded orange progress_tiny' style='width: 83%;'></div>
  </div>
</div>
<br />
    
    <%= combo_progress_bar([19, 9, 20, 10]) %>   

<div class='bar_container'>
  <div class='bar_mortice'>
    <div class='progress green' style='width: 19%;'></div>
    <div class='progress orange' style='width: 9%;'></div>
    <div class='progress pink' style='width: 20%;'></div>
    <div class='progress blue' style='width: 10%;'></div>
  </div>
</div>
<br />
    
    <%= combo_progress_bar([12, 15, 18, 22, 10], :tiny => true) %>   

<div class='bar_container container_tiny'>
  <div class='bar_mortice mortice_tiny'>
    <div class='progress green progress_tiny' style='width: 12%;'></div>
    <div class='progress orange progress_tiny' style='width: 15%;'></div>
    <div class='progress pink progress_tiny' style='width: 18%;'></div>
    <div class='progress blue progress_tiny' style='width: 22%;'></div>
    <div class='progress purple progress_tiny' style='width: 10%;'></div>
  </div>
</div>
<br />


[josh]: https://twitter.com/#!/knewter
[iso]: http://isotope11.com
[ds]: http://dipperstove.com
[dsblog]: http://dipperstove.com/design/css3-progress-bars.html
[gh]: https://github.com/yrgoldteeth/css3-progress-bar-rails
