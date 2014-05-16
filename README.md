# paly.io
#### Paly's URL shortener
By [Maxwell Bernstein](http://bernsteinbear.com) and [Christopher Hinstorff](http://chinstorff.com) for [The Paly Voice](http://palyvoice.com)

version 0.0.1

## About
*paly.io* is a URL shortener written in Ruby intended to be used by the Palo Alto High School (Paly) community.

## Deployment
`bundle install`

[Set up Unicorn with Nginx](http://recipes.sinatrarb.com/p/deployment/nginx_proxied_to_unicorn)

### Environment variables
`PALYIO_USERNAME` SQL username  
`PALYIO_PASSWORD` SQL password  
`PALYIO_HOST` SQL host  
`PALYIO_DATABASE` SQL database name  

`PALYIO_HOSTNAME` site hostname (e.g. http://paly.io)  
`PALYIO_HOME_DIR` home directory (e.g. /home/chris/)  
`PALYIO_WORKING_DIR` working directory (e.g. path/to/paly.io)  
`PALYIO_PROCESSES` number of worker processes alotted to Unicorn (e.g. 1)  
