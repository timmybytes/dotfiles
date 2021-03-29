#!/usr/bin/python3
# Job search sites and queries

import webbrowser
import subprocess
import time

# https://www.indeed.com/advanced_search
indeed = "https://www.indeed.com/jobs?as_and=remote&as_phr=&as_any=developer+frontend+front-end+web+engineer+javascript+html+css+scss+react+unix+bash+npm&as_not=senior+swift+c%2B%2B+java+.net&as_ttl=&as_cmp=&jt=all&st=&salary=&radius=25&l=&fromage=any&limit=50&sort=date&psf=advsrch&from=advancedsearch"
linkedin = "https://www.linkedin.com/jobs/search/?f_CF=f_WRA&geoId=103644278&keywords=developer&location=United%20States"
stackoverflow = "https://stackoverflow.com/jobs?r=true&td=c+c%23+c%2B%2B+asp.net+asp.net-mvc+.net+vb.net+java+angularjs+swift+objective-c&sort=p"
# https://weworkremotely.com/remote-jobs/search
wwr = "https://weworkremotely.com/remote-jobs/search?term=&button=&categories%5B%5D=2&region%5B%5D=Anywhere+%28100%25+Remote%29+Only&job_listing_type%5B%5D=Full-Time"

subprocess.run(
    ["open", "/Applications/Firefox.app"]
)

# Delay; ensures all tabs load in same window
time.sleep(.7)

webbrowser.open_new_tab(indeed)
webbrowser.open_new_tab(linkedin)
webbrowser.open_new_tab(stackoverflow)
webbrowser.open_new_tab(wwr)
