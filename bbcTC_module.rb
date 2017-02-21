#require 'rubygems'
#!/usr/bin/ruby
require 'selenium-webdriver'
require 'test/unit'
#require 'heading'
include Test::Unit::Assertions

class TC_bbc < Test::Unit::TestCase
  
  @@driver
  @@element
  @@searchStr
  def startup(browser)
    if browser == 'chrome'
    #@driver = Selenium::WebDriver.for:firefox
      @driver = Selenium::WebDriver.for:chrome
    else
      @driver = Selenium::WebDriver.for:firefox
    end
    @driver.navigate.to "http://bbc.com"
    
  end
  
  def setupSearch (searchString)   
    # Validate the title in the page
    puts @driver.title()
    assert_equal 'BBC - Homepage', @driver.title(), 'Home page title is incorrect'
      
    @driver.find_element(:id, 'orb-search-q').send_keys(searchString)
    @driver.find_element(:class, 'se-searchbox__submit').submit
 
    # Wait for search results tag to appear   
    waitVar = Selenium::WebDriver::Wait.new(:timeout => 15)
    form = waitVar.until {
        @element = @driver.find_element(:id, 'search-content')
        @element if @element.displayed?
    }
    puts "Test Passed: search result page found" if form.displayed?
    
    @searchStr = searchString
    # Check the search field has the search String after results are displayed
  #  element = @driver.find_element(:id, 'se-searchbox-input-field')
  #  puts element.text
 #   puts @element.text
  end
  
  def validateResult
   # Get the source of the page in a string
    @element = @driver.find_element(:id, 'search-content')
    pageSource = @element.text
    
    # Validate the title in the page
    puts @driver.title()
    assert_equal 'BBC - Search results for World Market', @driver.title(), 'Search title is incorrect'
    puts "Test Passed: Title page is " + @driver.title()
    
    # Create an array of the search string
    searchList = @searchStr.split(' ')
    #puts searchList
    
    # Put the text source of the page into an array
    sourceList = pageSource.split( /\r?\n/ )
    puts sourceList
    # parse the results into an array
    puts sourceList.length
    i = 0
    resultsList = []
    while (i < (sourceList.length - 1)) and (sourceList[i] != "Show more results")
      if sourceList[i] ==("Published Date")
        i += 2
        resultsList << (sourceList[i] + sourceList[i + 1])
        i += 1
      else
        temp = sourceList[i].to_s + sourceList[i + 1].to_s
        resultsList << temp
      end
      i += 4
    end
    puts resultsList
    
    #Verify there are 10 results
    assert_equal resultsList.length, 10, "Results are not 10"
    puts "Test Passed: 10 results"
    
    #Verify the search all strings exist on each of the results"
    missing = 0
    for s in searchList
      for r in resultsList
        if !((r.include?(s)) or r.include?(s.downcase))
          missing = 1
          puts "missing on " + r.to_s
        end
      end
    end
    
 #   puts resultsList  
    assert_equal missing, 0, "Results are not contained in the contents of the results"
    puts "Test Passed: The string or strings are found in the content of the results"

    #Validate the "More results button" exists     
 #   element = @driver.find_element(:link_text, "Show more results")
 #   puts "Show more results button exits" if element.displayed?    
  end
  
  
  def moreResults
    #Set focus back on the search content element
    @element = @driver.find_element(:id, 'search-content')
    
    #incase results are still rendering
    sleep 2
    
    #Validate clicking on the "More results button" exists   
    element = @driver.find_element(:partial_link_text, "Show").click
    
    waitVar = Selenium::WebDriver::Wait.new(:timeout => 15)
    form = waitVar.until {
        @element = @driver.find_element(:link_text, "Show more results")
        @element if @element.displayed?
    }
    puts "Test Passed: Show more results found" if form.displayed?

    #Set focus back on the search more content element
    @element = @driver.find_element(:id, 'search-content')
    pageSource = @element.text    
        
#    pageSource = @element.text
#    puts pageSource
    sourceList = pageSource.split( /\r?\n/ )
    i = 0
    resultsList = []
    while (i < (sourceList.length - 1)) and (sourceList[i] != "Show more results")
      if sourceList[i] ==("Published Date")
        i += 2
        resultsList << (sourceList[i] + sourceList[i + 1])
        i += 1
      else
        temp = sourceList[i].to_s + sourceList[i + 1].to_s
        resultsList << temp
      end
      i += 4
    end    
    puts resultsList
    
    #Verify there are 20 results
    assert_equal resultsList.length, 20, "Results are not 20"
    puts "Test Passed: 20 results"
  end
  
  def filterSearch(filter, moreFilter)
    #click on the filter
    puts moreFilter
    if moreFilter > 0
      @element = @driver.find_element(:id, 'orb-modules')
      element = @element.find_element(:xpath, "//a[contains(text(),'More Filters')]").click
      element = @element.find_element(:xpath, "//div[@id='orb-modules']/section/div/ol[2]/li/a").click      
    else
      @element = @driver.find_element(:class, 'filters')
      element = @element.find_element(:link_text, filter).click         
    end
    sleep 4
    waitVar = Selenium::WebDriver::Wait.new(:timeout => 15)
    form = waitVar.until {
        @element = @driver.find_element(:link_text, "Show more results")
        @element if @element.displayed?
    }
    puts "Test Passed: Show more results found" if form.displayed?

    #incase results are still rendering
    sleep 2
    
    #Set focus back on the search content element orb-modules
    @element = @driver.find_element(:id, 'orb-modules') 
    @element = @driver.find_element(:id, 'search-content')
    pageSource = @element.text
   
    # Put the text source of the page into an array
    sourceList = pageSource.split( /\r?\n/ )
    
    # parse the results into an array
    puts "with filter " + sourceList.length.to_s
    puts pageSource
    i = 0
    resultsList = []
    while (i < (sourceList.length - 1)) and (sourceList[i] != "Show more results")
      if sourceList[i] ==("Published Date")
        i += 2
        resultsList << (sourceList[i] + sourceList[i + 1])
        i += 1
      else
        temp = sourceList[i].to_s + sourceList[i + 1].to_s
        resultsList << temp
      end
      i += 4
    end
    puts resultsList
    
    #Verify there are 10 results
    assert_equal resultsList.length, 10, "Results are not 10"
    puts "Test Passed: 10 results"
    
    #Verify the results contain the filter string the tags
    i = 0
    resultsList = []
    while (i < (sourceList.length - 1)) and (sourceList[i] != "Show more results")
      if sourceList[i] ==("Tags")
        i += 1
        resultsList << sourceList[i]
      end
      i += 1
    end

    puts resultsList   
    missing = 0
    for r in resultsList
      if !(r.include?(filter))
        missing = 1
        puts "missing " + filter + " in " + r.to_s
      end
    end 

    assert_equal missing, 0, "Results does not contain the filter in the Tags of all the results"
    puts "Test Passed: Results does contain the filter in the Tags of all the results"
    
  end
  
  def moreFilter(filter)
    
    @element = @driver.find_element(:id, 'orb-modules')
    
  #  //*[@id="orb-modules"]/section[1]/div/header/ol/li[7]/a/text()
#    element = @element.find_element(:class, 'more').click
  #  element = @element.find_element(:xpath, "//*[@id='orb-modules']/section[1]/div/header/ol/li[7]/a/text()").click
    element = @element.find_element(:xpath, "//a[contains(text(),'More Filters')]").click
    element = @element.find_element(:xpath, "//div[@id='orb-modules']/section/div/ol[2]/li/a").click
    
  end
end

#require 'test/unit/ui/console/testrunner'

test = TC_bbc.new("Marv")
test.startup(ARGV[0])
test.setupSearch("World Market")
test.validateResult()
test.moreResults()
test.filterSearch('Programmes', 0)
test.filterSearch('News', 0)
test.filterSearch('Sport', 0)
test.filterSearch('About the BBC', 0)
test.filterSearch('World Service', 0)
sleep 2
test.filterSearch('Bitesize', 1)



#Test::Unit::UI::Console::TestRunner.run(TC_bbc)