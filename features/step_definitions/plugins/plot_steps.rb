When /^I configure plot group "([^"]*)"$/ do |group|
  find(:xpath, "(//div[@descriptorid='hudson.plugins.plot.PlotPublisher']//input[@name='group'])[last()]").set(group)
end

When /^I configure plot title "([^"]*)"$/ do |title|
  find(:xpath, "(//div[@descriptorid='hudson.plugins.plot.PlotPublisher']//input[@name='title'])[last()]").set(title)
end

When /^I configure plot y-axis label "([^"]*)"$/ do |yaxis|
  find(:xpath, "(//div[@descriptorid='hudson.plugins.plot.PlotPublisher']//input[@name='yaxis'])[last()]").set(yaxis)
end

When /^I add resource$/ do
  find(:xpath, "(//div[@descriptorid='hudson.plugins.plot.PlotPublisher']//button[text()='Add'])[last()]").click()
end

When /^I add plot$/ do
  find(:xpath, "//div[@descriptorid='hudson.plugins.plot.PlotPublisher']//button[text()='Add Plot']").click()
end

When /^I set (properties|csv|xml) file type$/ do |type|
  if(type=="properties")
    find(:xpath, "(//div[@descriptorid='hudson.plugins.plot.PlotPublisher']//input[@value='properties'])[last()]").set(true)
  end
  if(type=="csv")
    find(:xpath, "(//div[@descriptorid='hudson.plugins.plot.PlotPublisher']//input[@value='csv'])[last()]").set(true)
  end
  if(type=="xml")
    find(:xpath, "(//div[@descriptorid='hudson.plugins.plot.PlotPublisher']//input[@value='xml'])[last()]").set(true)
  end
end

When /^I confiture date series file "([^"]*)"$/ do |file|
  find(:xpath, "(//div[@descriptorid='hudson.plugins.plot.PlotPublisher']//input[@name='file'])[last()]").set(file)
end

When /^I set data series legend label for properties file "([^"]*)"$/ do |label|
  find(:xpath, "(//div[@descriptorid='hudson.plugins.plot.PlotPublisher']//input[@name='label'])[last()]").set(label)
end

Then /^I should see plot image$/ do
  visit @job.job_url + "/plot/getPlot?index=0&width=750&height=450"
  page.should have_xpath("/html/body/img")
end

Then /^I should see plot with group name "([^"]*)"$/ do |group|
  visit @job.job_url + "/plot/getPlot?index=0&width=750&height=450"
  page.should have_xpath("//a[text()='#{group}']")
end
