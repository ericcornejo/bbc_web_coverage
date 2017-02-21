# bbc_web_coverage
bbc solution
Installation Instructions:
1) Install Ruby
	a) gem install selenium-webdriver
	b) gem install test-unit
2) Optional download eclipse Luna and
	a) add the ruby plugin
	b) add the path for ruby folder on the configuration
3) Download geckodriver and place the location in your PATH or include the path on eclipse

How to run:
Either from eclipse (but will run firefox)
or from command line you have the option to:
	a) C:>ruby bbcTC_module.rb				(runs on firefox)
	b) C:>ruby bbcTC_module.rb chrome		(runs on chrome)

Tests:
1) Validate the tittle on the BBC.com page
2) Enter the "World Market" string on the search field   ('All' filter)
   a)Validate the search page title page
   b)Validate results 10 results are returned on World Market search
   c) Validate the results have the World Market strings in the content of the results
3) Check and click on the "Show more results" button
   a) Verify 20 results are displayed
4) Click on a filter 'Programmes'
	a) Verify 10 results are displayed
	b) Verify each result contains the filter string, 'Programmes', in the tag section
5) Repeat test 4 with 'News'
6) Repeat test 4 with 'Sport'
7) Repeat test 4 with 'About the BBC'
8) Repeat test 4 with 'World Service'

Test to be implemented (Bugs):
1) Test for the More filters section
 - could not get selenium to reference the more filters link tried class and xpath
2) Chrome version is failing because the 'text' function renders the contents differently, so this needs revision

Approach:
I though of useing Watir, but I had got stuck on referencing elements and sporadic failures on previous projects
and I noticed more documentation on Selenium-webdriver.  That is the reason I used Selenium-webdriver

Future enhacements:
1) To display the results in an HTML report
3) headless browser option
