---
layout: post
title: One line of sed for Rails 3.1 asset path helpers
---

#### {{ page.title }}

With the advent of the new asset pipeline in Rails 3.1.x, I have had to 
convert many stylesheets into erb templates to make use of the asset_path('/path/to/img')
helpers.  This seemed like an obvious job for a little [sed](http://www.gnu.org/software/sed/manual/sed.html), 
so I pulled this together.

Say you have a stylesheet from the [jQuery UI](http://jqueryui.com) project that looks like
[this](/stylesheets/jquery-ui-1.8.14.custom.css).  Type the following on a command line on
a system with sed installed:


    sed 's/url(\([^(]*\))/url(<%= asset_path("\1") %>)/g' jquery-ui-1.8.14.custom.css > jquery-ui-1.8.14.custom.css.erb

You should get results like this partial diff of the two files:

<pre class='prettyprint'>    
  62c62
  < .ui-widget-content { border: 1px solid #dddddd; background: #eeeeee url(images/ui-bg_highlight-soft_100_eeeeee_1x100.png) 50% top repeat-x; color: #333333; }
  ---
  > .ui-widget-content { border: 1px solid #dddddd; background: #eeeeee url(<%= asset_path("images/ui-bg_highlight-soft_100_eeeeee_1x100.png") %>) 50% top repeat-x; color: #333333; }
  64c64
  < .ui-widget-header { border: 1px solid #e78f08; background: #f6a828 url(images/ui-bg_gloss-wave_35_f6a828_500x100.png) 50% 50% repeat-x; color: #ffffff; font-weight: bold; }
  ---
  > .ui-widget-header { border: 1px solid #e78f08; background: #f6a828 url(<%= asset_path("images/ui-bg_gloss-wave_35_f6a828_500x100.png") %>) 50% 50% repeat-x; color: #ffffff; font-weight: bold; }
  69c69
  < .ui-state-default, .ui-widget-content .ui-state-default, .ui-widget-header .ui-state-default { border: 1px solid #cccccc; background: #f6f6f6 url(images/ui-bg_glass_100_f6f6f6_1x400.png) 50% 50% repeat-x; font-weight: bold; color: #1c94c4; }
  ---
  > .ui-state-default, .ui-widget-content .ui-state-default, .ui-widget-header .ui-state-default { border: 1px solid #cccccc; background: #f6f6f6 url(<%= asset_path("images/ui-bg_glass_100_f6f6f6_1x400.png") %>) 50% 50% repeat-x; font-weight: bold; color: #1c94c4; }
  71c71
  < .ui-state-hover, .ui-widget-content .ui-state-hover, .ui-widget-header .ui-state-hover, .ui-state-focus, .ui-widget-content .ui-state-focus, .ui-widget-header .ui-state-focus { border: 1px solid #fbcb09; background: #fdf5ce url(images/ui-bg_glass_100_fdf5ce_1x400.png) 50% 50% repeat-x; font-weight: bold; color: #c77405; }
  ---
  > .ui-state-hover, .ui-widget-content .ui-state-hover, .ui-widget-header .ui-state-hover, .ui-state-focus, .ui-widget-content .ui-state-focus, .ui-widget-header .ui-state-focus { border: 1px solid #fbcb09; background: #fdf5ce url(<%= asset_path("images/ui-bg_glass_100_fdf5ce_1x400.png") %>) 50% 50% repeat-x; font-weight: bold; color: #c77405; }
</pre>
