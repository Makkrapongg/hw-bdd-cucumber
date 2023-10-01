# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create(movie)
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  expect(Movie.count).to eq n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  # ensure that that e1 occurs before e2.
  # page.body is the entire content of the page as a
  # string.
  begin
  # Check if e1 and e2 are dates.
    DateTime.parse e1
    DateTime.parse e2
    within(:xpath, %(//table[@id="movies"]/tbody)) do
      release_dates = page.all(:xpath, "//td[3]")
      .to_a.map do
        |el| DateTime.parse(el.text)
      end.compact
      expect(
        release_dates.index(e1) < release_dates.index(e2)
      ).to be true
    end
  rescue ArgumentError
    expect(
      page.body.index(e1) < page.body.index(e2)
    ).to be true
  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  ratings = rating_list.split(', ')
  ratings.each do |rating|
    steps %Q{ Then I #{uncheck}check "#{rating}"}
  end
end
# Part 2, Step 3
Then /^I should (not )?see the following movies: (.*)$/ do |no, movie_list|
  movies = movie_list.split(', ')
  movies.each do |movie|
    steps %Q{ Then I should #{no }see "#{movie}"}
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  Movie.all.each do |movie|

    steps %Q{ Then I should see "#{movie.title}"}
  end
end

### Utility Steps Just for this assignment.

Then /^debug$/ do
  # Use this to write "Then debug" in your scenario to open a console.
   require "byebug"; byebug
  1 # intentionally force debugger context in this method
end

Then /^debug javascript$/ do
  # Use this to write "Then debug" in your scenario to open a JS console
  page.driver.debugger
  1
end


Then /complete the rest of of this scenario/ do
  # This shows you what a basic cucumber scenario looks like.
  # You should leave this block inside movie_steps, but replace
  # the line in your scenarios with the appropriate steps.
  fail "Remove this step from your .feature files"
end
